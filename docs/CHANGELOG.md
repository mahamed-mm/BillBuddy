# Changelog

All notable changes to BillBuddy will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- Project scaffolding with MVVM folder structure
- `TipPreset` model — 6 presets (0/5/10/15/20/25%) + custom
- `Currency` model — NOK, USD, KES with locale and symbol
- `TipCalculation` result snapshot struct
- `CalculatorViewModel` with `@Observable` — all tip/split business logic
- `CalculatorView` — main screen composition (single ScrollView)
- `BillInputView` — currency-prefixed decimal text field
- `TipSelectorView` — preset grid + custom slider (0–50%)
- `TipPresetButton` — reusable selected/unselected chip
- `SplitControlView` — +/- stepper for 1–20 people
- `ResultsCardView` — tip, total, and per-person breakdown
- `BreakdownRow` — label-value display row
- `CurrencyPickerView` — segmented NOK | USD | KES selector
- `GlassCard` — reusable elevated card container
- `HapticManager` — light/medium impact and success notification
- `CurrencyFormatter` — cached locale-aware NumberFormatters
- `AppColors` — teal accent (#00E5CC), card backgrounds, text colors
- `AppTypography` — rounded system font presets
- `AppSpacing` — spacing scale (4–48pt) and corner radii
- `View+HapticFeedback` extension
- `Double+CurrencyFormatted` extension
- `@AppStorage` persistence for currency, tip %, and split count
- Spring animations on value changes (`.spring(response: 0.4, dampingFraction: 0.7)`)
- Staggered card entrance animations
- Dark-mode-first UI with functional light mode
- Project documentation: README, ARCHITECTURE, STYLE-GUIDE, TASKS, TESTING, CHANGELOG

---

## [1.0.0] — TBD

> First public release. All items from [Unreleased] will be moved here upon release.

### Added

- V1 tip calculator with 6 presets + custom slider
- Equal bill splitting for 1–20 people
- Multi-currency display (NOK, USD, KES)
- Dark-mode-first UI with teal accent
- Haptic feedback on interactions
- Preference persistence across sessions
