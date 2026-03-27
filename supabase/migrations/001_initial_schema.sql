-- ========================================
-- Recipick 초기 스키마
-- Supabase SQL Editor에서 실행
-- ========================================

-- 1. pgvector 확장 활성화
create extension if not exists vector with schema extensions;

-- 2. ingredients (재료 마스터)
create table public.ingredients (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  category text not null check (category in ('solid', 'liquid', 'countable', 'spice', 'powder', 'sheet', 'bunch')),
  default_unit text not null,
  aliases text[] default '{}',
  created_at timestamptz default now()
);

-- 3. recipes (레시피)
create table public.recipes (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  instructions jsonb not null default '[]',
  cook_time int,
  difficulty text check (difficulty in ('쉬움', '보통', '어려움')),
  servings int default 2,
  image_url text,
  source text,
  created_at timestamptz default now()
);

-- 4. recipe_ingredients (레시피-재료 매핑)
create table public.recipe_ingredients (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  ingredient_id uuid not null references public.ingredients(id) on delete cascade,
  quantity numeric,
  unit text,
  unique (recipe_id, ingredient_id)
);

-- 5. recipe_embeddings (벡터 검색용)
create table public.recipe_embeddings (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade unique,
  embedding extensions.vector(768) not null,
  content text not null
);

-- 6. user_fridge (사용자 냉장고)
create table public.user_fridge (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  ingredient_id uuid not null references public.ingredients(id) on delete cascade,
  quantity numeric not null,
  unit text not null,
  added_at timestamptz default now()
);

-- ========================================
-- 인덱스
-- ========================================

create index idx_recipe_ingredients_recipe on public.recipe_ingredients(recipe_id);
create index idx_recipe_ingredients_ingredient on public.recipe_ingredients(ingredient_id);
create index idx_user_fridge_user on public.user_fridge(user_id);
create index idx_recipe_embeddings_vector on public.recipe_embeddings
  using hnsw (embedding extensions.vector_cosine_ops);

-- ========================================
-- RLS (Row Level Security)
-- ========================================

-- recipes, ingredients: 누구나 읽기 가능
alter table public.recipes enable row level security;
alter table public.ingredients enable row level security;
alter table public.recipe_ingredients enable row level security;
alter table public.recipe_embeddings enable row level security;
alter table public.user_fridge enable row level security;

-- 레시피/재료: 공개 읽기
create policy "recipes_select" on public.recipes for select using (true);
create policy "ingredients_select" on public.ingredients for select using (true);
create policy "recipe_ingredients_select" on public.recipe_ingredients for select using (true);
create policy "recipe_embeddings_select" on public.recipe_embeddings for select using (true);

-- user_fridge: 본인 데이터만 CRUD
create policy "fridge_select" on public.user_fridge
  for select using (auth.uid() = user_id);

create policy "fridge_insert" on public.user_fridge
  for insert with check (auth.uid() = user_id);

create policy "fridge_update" on public.user_fridge
  for update using (auth.uid() = user_id);

create policy "fridge_delete" on public.user_fridge
  for delete using (auth.uid() = user_id);

-- ========================================
-- 벡터 유사도 검색 함수
-- ========================================

create or replace function public.match_recipes(
  query_embedding extensions.vector(768),
  match_threshold float default 0.3,
  match_count int default 20
)
returns table (
  recipe_id uuid,
  similarity float
)
language sql stable
as $$
  select
    re.recipe_id,
    1 - (re.embedding <=> query_embedding) as similarity
  from public.recipe_embeddings re
  where 1 - (re.embedding <=> query_embedding) > match_threshold
  order by re.embedding <=> query_embedding
  limit match_count;
$$;
