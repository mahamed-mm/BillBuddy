# Changelog

All notable changes to BillBuddy will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Changed

- **Deployment target lowered to iOS 17.0** — the project was set to iOS 26.2, so the app couldn't be installed on any older iOS version, although the README, `plan.md`, and `CLAUDE.md` promise iOS 17+. `IPHONEOS_DEPLOYMENT_TARGET` is now 17.0 in the project's Debug and Release configurations, which both targets inherit. No code changes were needed: the app and the tests use no API newer than iOS 17, and the build has 0 warnings. Verified on the iOS 17.5 simulator (iPhone 15): the full test suite passes, and a smoke run covered bill entry (including "12,50"), tip, split, rounding, currency, and preferences surviving a relaunch.

### Fixed

- **Half-øre tip and total rounding** — a tip that came to exactly half an øre or cent could round down, because the math ran in floating point: a bill of 33,30 at 15 % showed a tip of 4,99 kr and a total of 38,29 kr. The tip and total are now computed exactly in øre and cents, with the tip rounded half-up to the nearest øre or cent, so that bill shows 5,00 kr and 38,30 kr. A bill typed with more than two decimals now counts as rounded to the nearest øre or cent ("1,005" is 1,01). Tip ↑ and Total ↑ now round up the tip or total as shown: 15 % of 6,67 shows a tip of 1,00 kr, and Tip ↑ keeps it at 1,00 kr instead of raising it to 2,00 kr. A bill above 10 000 000 000 000,00 now counts as invalid input, like any other text the app can't read.

---

## [2.0.1] — 2026-09-26

### Fixed

- **Comma-decimal bill input** — in regions that use a decimal comma, such as Norway, the decimal pad types "," and every result showed 0. The new `AmountParser` enum accepts "," or "." as the decimal separator on any region and rejects text that `Double(_:)` used to accept ("-5", "nan", "inf", "1e5"). It also converts typed text to exact minor units (øre, cents) with half-up rounding, at the scale set by the new `Currency.fractionDigits`. `CalculatorViewModel.billAmount` now parses through it. Covered by 11 new tests in `AmountParserTests.swift`.
- **Clipped rounding pills** — at the default text size the four rounding pills need 387 pt in one row, but a 6.1" or 6.3" iPhone has 361–370 pt inside the screen padding. "Per Person ↑" was cut off at the right padding edge of a horizontal scroll view with no sign that the row scrolled, and at the largest accessibility text size only two pills were fully in view. `RoundingSelectorView` now wraps the pills into a two-column grid, like the tip presets, and into one full-width column at accessibility text sizes, so every pill is fully visible without scrolling. Covered by 5 new tests in `RoundingSelectorViewTests.swift`.

---

## [2.0.0] — 2026-02-12

### Added

- **Rounding options** — new `RoundingMode` model (none, round tip, round total, round per person) with `RoundingSelectorView` horizontal pill UI, ViewModel integration with `@AppStorage` persistence, and 11 unit tests
- **New color tokens** — `bbCardBorder` and `bbCardShadow` for fine-grained card surface styling across color schemes

### Improved

- **Adaptive dark-mode color system** — all `AppColors` tokens now use `Color(UIColor { traits in ... })` with explicit dark/light variants: deep off-black background (`#0A0A0F`), elevated card surface (`#1C1C1E`), tuned chip and border opacities per mode
- **GlassCard enhancement** — added subtle `bbCardBorder` glass-edge overlay (white @ 8% dark, black @ 4% light) and adaptive `bbCardShadow` (deeper in dark mode for perceived elevation)
- **Forced dark mode** — app always renders in dark color scheme via `.preferredColorScheme(.dark)`

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
