import 'package:flutter/material.dart';

// 색상
const kPrimaryColor = Color(0xFF5F0080);
const kPrimaryLight = Color(0xFFF3E8FF);
const kPrimaryFaint = Color(0xFFFAF5FF);
const kBackground = Color(0xFFF7F7F7);
const kTextPrimary = Color(0xFF333333);
const kTextSecondary = Color(0xFF666666);
const kTextHint = Color(0xFF999999);
const kBorder = Color(0xFFE0E0E0);
const kInputFill = Color(0xFFF5F5F5);
const kDivider = Color(0xFFF0F0F0);
const kError = Color(0xFFEF5350);
const kSuccess = Color(0xFF4CAF50);
const kWarning = Color(0xFFFFA726);

// 모서리
const kRadiusCard = 14.0;
const kRadiusButton = 12.0;
const kRadiusChip = 20.0;
const kRadiusInput = 12.0;
const kRadiusBottomSheet = 20.0;
const kRadiusIcon = 10.0;
const kRadiusIconLg = 12.0;

// 사이즈
const kButtonHeight = 52.0;
const kPaddingPage = 16.0;
const kIconSizeSm = 20.0;
const kIconSizeMd = 22.0;
const kIconSizeEmpty = 64.0;

// 그림자
List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 8,
    offset: const Offset(0, 2),
  ),
];
