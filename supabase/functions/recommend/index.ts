import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface UserIngredient {
  name: string;
  quantity: number;
  unit: string;
}

interface MatchedRecipe {
  recipe_id: string;
  match_rate: number;
  matched_ingredients: string[];
  missing_ingredients: { name: string; quantity: number | null; unit: string | null }[];
}

interface VectorResult {
  recipe_id: string;
  similarity: number;
}

interface RankedCandidate {
  recipe_id: string;
  final_score: number;
  match_rate: number;
  similarity: number;
  matched_ingredients: string[];
  missing_ingredients: { name: string; quantity: number | null; unit: string | null }[];
}

interface RecipeDetail {
  id: string;
  title: string;
  description: string | null;
  cook_time: number | null;
  difficulty: string | null;
  servings: number | null;
  image_url: string | null;
  instructions: { step: number; text: string }[];
}

interface Recommendation {
  recipe_id: string;
  title: string;
  description: string | null;
  cook_time: number | null;
  difficulty: string | null;
  servings: number | null;
  image_url: string | null;
  match_rate: number;
  matched_ingredients: string[];
  missing_ingredients: { name: string; quantity: number | null; unit: string | null }[];
  ai_reason: string;
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { ingredients } = (await req.json()) as {
      ingredients: UserIngredient[];
    };

    if (!ingredients || ingredients.length === 0) {
      return new Response(
        JSON.stringify({ error: "재료를 1개 이상 입력해주세요" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const geminiApiKey = Deno.env.get("GEMINI_API_KEY")!;

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // ========================================
    // Step ① 재료 매칭 (DB)
    // ========================================
    const userIngredientNames = ingredients.map((i) => i.name);

    // 사용자 재료명으로 ingredient_id 조회 (name 일치 OR aliases 포함)
    const { data: matchedIngredients } = await supabase
      .from("ingredients")
      .select("id, name")
      .or(
        userIngredientNames
          .map((n) => `name.eq.${n},aliases.cs.{${n}}`)
          .join(",")
      );

    const userIngredientIds = new Set(
      (matchedIngredients ?? []).map((i: { id: string }) => i.id)
    );
    const userIngredientNameSet = new Set(
      (matchedIngredients ?? []).map((i: { name: string }) => i.name)
    );

    // 모든 레시피의 재료 정보 조회
    const { data: allRecipeIngredients } = await supabase
      .from("recipe_ingredients")
      .select("recipe_id, ingredient_id, quantity, unit, ingredients(name)");

    // 레시피별 매칭률 계산
    const recipeMap = new Map<string, {
      total: number;
      matched: string[];
      missing: { name: string; quantity: number | null; unit: string | null }[];
    }>();

    for (const ri of allRecipeIngredients ?? []) {
      const recipeId = ri.recipe_id as string;
      const ingredientName = (ri.ingredients as { name: string } | null)?.name ?? "";

      if (!recipeMap.has(recipeId)) {
        recipeMap.set(recipeId, { total: 0, matched: [], missing: [] });
      }
      const entry = recipeMap.get(recipeId)!;
      entry.total++;

      if (userIngredientIds.has(ri.ingredient_id as string)) {
        entry.matched.push(ingredientName);
      } else {
        entry.missing.push({
          name: ingredientName,
          quantity: ri.quantity as number | null,
          unit: ri.unit as string | null,
        });
      }
    }

    const dbMatches: MatchedRecipe[] = [];
    for (const [recipeId, entry] of recipeMap) {
      if (entry.matched.length === 0) continue;
      dbMatches.push({
        recipe_id: recipeId,
        match_rate: entry.matched.length / entry.total,
        matched_ingredients: entry.matched,
        missing_ingredients: entry.missing,
      });
    }
    dbMatches.sort((a, b) => b.match_rate - a.match_rate);
    const top20Db = dbMatches.slice(0, 20);

    // ========================================
    // Step ② 벡터 유사도 검색
    // ========================================
    const queryText = userIngredientNames.join(" ");

    // Gemini Embedding API 호출
    const embeddingRes = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${geminiApiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          model: "models/gemini-embedding-001",
          content: { parts: [{ text: queryText }] },
          outputDimensionality: 768,
        }),
      }
    );

    let top20Vector: VectorResult[] = [];

    if (embeddingRes.ok) {
      const embeddingData = await embeddingRes.json();
      const queryEmbedding = embeddingData.embedding.values as number[];

      const { data: vectorResults } = await supabase.rpc("match_recipes", {
        query_embedding: queryEmbedding,
        match_threshold: 0.3,
        match_count: 20,
      });

      top20Vector = (vectorResults ?? []).map(
        (r: { recipe_id: string; similarity: number }) => ({
          recipe_id: r.recipe_id,
          similarity: r.similarity,
        })
      );
    }

    // ========================================
    // Step ③ 후보 병합 + 랭킹
    // ========================================
    const candidateMap = new Map<string, RankedCandidate>();

    for (const db of top20Db) {
      candidateMap.set(db.recipe_id, {
        recipe_id: db.recipe_id,
        final_score: 0.7 * db.match_rate,
        match_rate: db.match_rate,
        similarity: 0,
        matched_ingredients: db.matched_ingredients,
        missing_ingredients: db.missing_ingredients,
      });
    }

    for (const vec of top20Vector) {
      if (candidateMap.has(vec.recipe_id)) {
        const existing = candidateMap.get(vec.recipe_id)!;
        existing.similarity = vec.similarity;
        existing.final_score = 0.7 * existing.match_rate + 0.3 * vec.similarity;
      } else {
        // 벡터에만 있고 DB 매칭에 없는 경우
        const dbEntry = recipeMap.get(vec.recipe_id);
        candidateMap.set(vec.recipe_id, {
          recipe_id: vec.recipe_id,
          final_score: 0.3 * vec.similarity,
          match_rate: dbEntry ? dbEntry.matched.length / dbEntry.total : 0,
          similarity: vec.similarity,
          matched_ingredients: dbEntry?.matched ?? [],
          missing_ingredients: dbEntry?.missing ?? [],
        });
      }
    }

    const ranked = Array.from(candidateMap.values())
      .sort((a, b) => b.final_score - a.final_score)
      .slice(0, 10);

    if (ranked.length === 0) {
      return new Response(
        JSON.stringify({ recommendations: [] }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 레시피 상세 정보 조회
    const recipeIds = ranked.map((r) => r.recipe_id);
    const { data: recipeDetails } = await supabase
      .from("recipes")
      .select("id, title, description, cook_time, difficulty, servings, image_url, instructions")
      .in("id", recipeIds);

    const recipeDetailMap = new Map<string, RecipeDetail>();
    for (const r of recipeDetails ?? []) {
      recipeDetailMap.set(r.id, r as RecipeDetail);
    }

    // ========================================
    // Step ④ LLM 보완 (Gemini Flash)
    // ========================================
    let llmSelections: { recipe_id: string; ai_reason: string }[] = [];
    let usedFallback = false;

    try {
      const candidateList = ranked.slice(0, 10).map((c) => {
        const detail = recipeDetailMap.get(c.recipe_id);
        return {
          recipe_id: c.recipe_id,
          title: detail?.title ?? "알 수 없음",
          match_rate: Math.round(c.match_rate * 100),
          matched: c.matched_ingredients.join(", "),
          missing: c.missing_ingredients.map((m) => m.name).join(", "),
        };
      });

      const prompt = `당신은 한국 가정 요리 전문가입니다.

사용자가 냉장고에 가지고 있는 재료: ${userIngredientNames.join(", ")}

아래 후보 레시피 중에서 사용자의 재료로 가장 잘 만들 수 있는 3개를 골라주세요.

후보 레시피:
${candidateList.map((c, i) => `${i + 1}. ${c.title} (매칭률 ${c.match_rate}%, 보유: ${c.matched}, 부족: ${c.missing || "없음"})`).join("\n")}

반드시 아래 JSON 형식으로만 답해주세요. 다른 텍스트는 포함하지 마세요.
[
  {"recipe_id": "uuid", "ai_reason": "추천 이유 한 문장"},
  {"recipe_id": "uuid", "ai_reason": "추천 이유 한 문장"},
  {"recipe_id": "uuid", "ai_reason": "추천 이유 한 문장"}
]`;

      const llmRes = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${geminiApiKey}`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
            generationConfig: {
              temperature: 0.3,
              maxOutputTokens: 512,
            },
          }),
        }
      );

      if (llmRes.ok) {
        const llmData = await llmRes.json();
        const rawText =
          llmData.candidates?.[0]?.content?.parts?.[0]?.text ?? "";

        // JSON 배열 추출 (마크다운 코드블럭 대응)
        const jsonMatch = rawText.match(/\[[\s\S]*\]/);
        if (jsonMatch) {
          llmSelections = JSON.parse(jsonMatch[0]) as {
            recipe_id: string;
            ai_reason: string;
          }[];
        }
      }
    } catch (_e) {
      // LLM 실패 — fallback 사용
    }

    // Fallback: LLM 실패 시 상위 3개
    if (llmSelections.length === 0) {
      usedFallback = true;
      llmSelections = ranked.slice(0, 3).map((c) => ({
        recipe_id: c.recipe_id,
        ai_reason: "보유한 재료와 가장 잘 맞는 레시피입니다",
      }));
    }

    // ========================================
    // 응답 조립
    // ========================================
    const recommendations: Recommendation[] = [];

    for (const sel of llmSelections.slice(0, 3)) {
      const detail = recipeDetailMap.get(sel.recipe_id);
      const candidate = candidateMap.get(sel.recipe_id);

      if (!detail) continue;

      recommendations.push({
        recipe_id: sel.recipe_id,
        title: detail.title,
        description: detail.description,
        cook_time: detail.cook_time,
        difficulty: detail.difficulty,
        servings: detail.servings,
        image_url: detail.image_url,
        match_rate: candidate?.match_rate ?? 0,
        matched_ingredients: candidate?.matched_ingredients ?? [],
        missing_ingredients: candidate?.missing_ingredients ?? [],
        ai_reason: sel.ai_reason,
      });
    }

    // LLM이 3개 미만 반환 시 fallback으로 채우기
    if (recommendations.length < 3 && !usedFallback) {
      const existingIds = new Set(recommendations.map((r) => r.recipe_id));
      for (const c of ranked) {
        if (recommendations.length >= 3) break;
        if (existingIds.has(c.recipe_id)) continue;

        const detail = recipeDetailMap.get(c.recipe_id);
        if (!detail) continue;

        recommendations.push({
          recipe_id: c.recipe_id,
          title: detail.title,
          description: detail.description,
          cook_time: detail.cook_time,
          difficulty: detail.difficulty,
          servings: detail.servings,
          image_url: detail.image_url,
          match_rate: c.match_rate,
          matched_ingredients: c.matched_ingredients,
          missing_ingredients: c.missing_ingredients,
          ai_reason: "보유한 재료와 가장 잘 맞는 레시피입니다",
        });
      }
    }

    return new Response(
      JSON.stringify({ recommendations }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    const message = err instanceof Error ? err.message : "알 수 없는 오류";
    return new Response(
      JSON.stringify({ error: message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
