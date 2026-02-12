# Changelog

All notable changes to BillBuddy will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Improved

- **Adaptive dark-mode color system** — all `AppColors` tokens now use `Color(UIColor { traits in ... })` with explicit dark/light variants: deep off-black background (`#0A0A0F`), elevated card surface (`#1C1C1E`), tuned chip and border opacities per mode
- **GlassCard enhancement** — added subtle `bbCardBorder` glass-edge overlay (white @ 8% dark, black @ 4% light) and adaptive `bbCardShadow` (deeper in dark mode for perceived elevation)

### Added

- **Rounding options** — new `RoundingMode` model (none, round tip, round total, round per person) with `RoundingSelectorView` horizontal pill UI, ViewModel integration with `@AppStorage` persistence, and 11 unit tests
- **New color tokens** — `bbCardBorder` and `bbCardShadow` for fine-grained card surface styling across color schemes

---

## [1.0.4] — 2026-02-12

### Added

- **Unit test target** — created `billBudyTests` with shared Xcode scheme, host app dependency, and Swift Testing framework
- **CalculatorViewModel tests** — 32 tests covering tip math (all presets + custom), split math (1–20 people, bounds clamping), edge cases (empty, zero, invalid, large, decimal), and model properties (TipPreset, Currency)
- **CurrencyFormatter tests** — 7 tests covering NOK/USD/KES formatting, zero/large amounts, grouping separators, and cross-currency uniqueness

---

## [1.0.3] — 2026-02-12

### Removed

- **Unused haptic extension methods** — removed `onLightHaptic()`, `onMediumHaptic()`, and `withHapticFeedback()` from `View+HapticFeedback.swift` (never called; all haptics go through `HapticManager` directly)

### Improved

- **VoiceOver accessibility** — added `accessibilityLabel` and `accessibilityValue` to `BillInputView`, `TipPresetButton`, `SplitControlView`, `CurrencyPickerView`, and `ResultsCardView`

---

## [1.0.2] — 2026-02-12

### Improved

- **Numeric text transitions** — added `.contentTransition(.numericText())` to tip, total, and per-person values in `BreakdownRow` for smooth digit animations
- **Currency change animation** — `ResultsCardView` now animates with spring transition when switching between NOK/USD/KES
- **Broader animation coverage** — added spring animations driven by `effectiveTipPercent` and `splitCount` so all value changes trigger the numeric transition

---

## [1.0.1] — 2026-02-12

### Fixed

- **Haptic feedback on first calculation** — wired `HapticManager.success()` in `ResultsCardView` via `.onChange` guard so it fires once when bill amount first becomes positive
- **Keyboard dismiss** — added toolbar with Done button to `BillInputView` so users can close the decimal pad
- **Custom tip persistence** — added `@AppStorage("savedCustomTip")` to `CalculatorViewModel` and trigger `savePreferences()` on slider change in `TipSelectorView`

---

## [1.0.0] — 2026-02-12

### Added

- **Tip Calculator** — 6 preset buttons (0%, 5%, 10%, 15%, 20%, 25%) + custom slider (0-50%)
- **Bill Splitting** — equal split for 1-20 people with per-person breakdown
- **Multi-Currency Display** — NOK (kr), USD ($), KES (KSh) with locale-correct formatting
- **Dark-Mode-First UI** — teal accent (#00E5CC), elevated glass cards, high-contrast text
- **Haptic Feedback** — light impact on tip selection, medium on split change, success on first result
- **Spring Animations** — smooth value transitions (`.spring(response: 0.4, dampingFraction: 0.7)`) and staggered card entrances
- **Persistent Preferences** — currency, tip %, and split count saved via `@AppStorage`
- **MVVM Architecture** — `@Observable` ViewModel with `@Environment` injection
- **Design System** — `AppColors`, `AppTypography`, `AppSpacing` token enums
- **Services** — `HapticManager` and `CurrencyFormatter` enum namespaces with cached formatters
- **Extensions** — `View+HapticFeedback` and `Double+CurrencyFormatted` helpers
- **Project Documentation** — README, ARCHITECTURE, STYLE-GUIDE, TASKS, TESTING, CHANGELOG
