# Tasks

BillBuddy development to-do list, organized by milestone.

---

## Milestone 1: Foundation (Day 1, ~5h)

### Project Scaffolding

- [x] Create folder structure: Models/, ViewModels/, Views/Calculator/, Views/Results/, Views/Components/, Services/, DesignSystem/, Extensions/
- [x] Update AccentColor asset to teal `#00E5CC`

### Models

- [x] `TipPreset.swift` — enum with cases: zero, five, ten, fifteen, twenty, twentyFive, custom; percentage computed property
- [x] `Currency.swift` — enum with cases: nok, usd, kes; symbol, flag, locale properties
- [x] `TipCalculation.swift` — struct with tipAmount, totalAmount, perPersonAmount, tipPercent, splitCount

### Design System

- [x] `AppColors.swift` — bbTeal, bbBackground, bbCardBackground, bbPrimaryText, bbSecondaryText, bbSelectedChip, bbSelectedBorder, bbUnselectedBorder
- [x] `AppTypography.swift` — largeTitle, title, headline, body, caption, mono font presets
- [x] `AppSpacing.swift` — xs(4), sm(8), md(16), lg(24), xl(32), xxl(48), cornerRadius(16), cardRadius(20)

### Services

- [x] `HapticManager.swift` — enum with lightImpact(), mediumImpact(), success() static methods
- [x] `CurrencyFormatter.swift` — enum with cached NumberFormatter per Currency locale, format(amount:currency:) method

### Extensions

- [x] `View+HapticFeedback.swift` — .onHaptic() view modifier
- [x] `Double+CurrencyFormatted.swift` — .formatted(as:) method using CurrencyFormatter

---

## Milestone 2: Core UI (Day 2–3, ~9h)

### ViewModel

- [x] `CalculatorViewModel.swift` — @Observable class with all input/computed properties
- [x] Wire up @AppStorage persistence with @ObservationIgnored bridge
- [x] Unit-test-ready computed properties (tip math, split math)

### Calculator Views

- [x] `CalculatorView.swift` — ScrollView composing all sub-views
- [x] `BillInputView.swift` — TextField with decimal pad, currency symbol prefix, large mono font
- [x] `TipSelectorView.swift` — LazyVGrid (2 columns) of preset buttons + conditional custom slider
- [x] `TipPresetButton.swift` — selected/unselected states with bbTeal accent
- [x] `SplitControlView.swift` — minus/plus buttons with count label, clamped 1–20

### Results Views

- [x] `ResultsCardView.swift` — GlassCard containing BreakdownRows for tip, total, per-person
- [x] `BreakdownRow.swift` — horizontal label + formatted currency value

### Component Views

- [x] `CurrencyPickerView.swift` — segmented control with flag + currency code for NOK, USD, KES
- [x] `GlassCard.swift` — rounded rect with bbCardBackground, shadow, cardRadius

### Screen Composition

- [x] Wire CalculatorView into ContentView
- [x] Inject CalculatorViewModel via @State + .environment() in billBudyApp.swift
- [x] Verify full screen renders in SwiftUI Preview

---

## Milestone 3: Polish (Day 3–4, ~7h)

### Animations

- [x] Spring animation on tip/total/per-person value changes
- [x] Staggered entrance animation for result card rows
- [x] Smooth slider thumb tracking

### Haptics

- [x] Light impact on tip preset selection
- [x] Medium impact on split count change
- [x] Success notification on first calculation result

### Persistence

- [x] Load saved currency, tip preset, split count in ViewModel init()
- [x] Save preferences on each change via savePreferences()
- [x] Verify preferences survive app restart

### Dark/Light Mode QA

- [x] Dark mode: all text readable, card surfaces elevated, teal accent visible
- [x] Light mode: functional, no invisible text or elements
- [ ] Test both modes on multiple simulator devices

### Edge Cases

- [x] Empty bill amount shows zero tip/total
- [x] Bill amount of 0 handled gracefully
- [x] Split count at bounds (1 and 20) — stepper disables correctly
- [x] Very large bill amounts don't overflow layout
- [x] Rapid input doesn't cause lag or glitches
- [x] Currency switch updates all displayed amounts immediately

### Previews

- [x] #Preview block in every view file
- [x] All previews render without crashes
- [ ] Preview with sample data for both light and dark mode

---

## V1 Bug Fixes

- [x] Wire HapticManager.success() in ResultsCardView on first calculation
- [x] Add keyboard dismiss toolbar with Done button to BillInputView
- [x] Save customTipPercent via savePreferences() when slider changes

---

## V1 UX Polish

- [x] Add `.contentTransition(.numericText())` to tip, total, and per-person values in BreakdownRow
- [x] Animate ResultsCardView on currency change (spring animation on selectedCurrency)
- [ ] Test dark/light mode on multiple simulators — deferred to V2 Dark-Mode UI

---

## V1 Code Quality

- [x] Remove unused `View+HapticFeedback` extension methods (`onLightHaptic`, `onMediumHaptic`, `withHapticFeedback`)
- [x] Add `accessibilityLabel` and `accessibilityValue` to all interactive controls (BillInputView, TipPresetButton, SplitControlView, CurrencyPickerView, ResultsCardView)

---

## V1 Testing

- [x] Create `billBudyTests` unit test target in Xcode project (shared scheme, host app dependency)
- [x] Write `CalculatorViewModel` unit tests — tip math, split math, edge cases, model tests (32 tests)
- [x] Write `CurrencyFormatter` unit tests — NOK/USD/KES formatting, zero, large amounts (7 tests)
- [x] All 39 tests passing

---

## Milestone 4: Release Prep

- [ ] Run full manual QA checklist (see TESTING.md)
- [x] Verify zero Xcode build warnings
- [x] Capture screenshots for README (dark mode, light mode)
- [x] Update README.md with real screenshots
- [x] Move [Unreleased] items to [1.0.0] in CHANGELOG.md
- [x] Tag release: `git tag v1.0.0`

---

## V2 — Power Features

### Dark-Mode UI

- [ ] Implement full dark-mode color scheme — dark backgrounds, elevated card surfaces, teal accent visibility
- [ ] Update `AppColors` with dark-mode-specific adaptive colors using `Color(.init(dynamicProvider:))`
- [ ] QA all views in dark mode — text readability, contrast ratios, card elevation
- [ ] Add dark-mode screenshots to README

### Unequal Splits

- [ ] Assign custom amounts/percentages per person

### Live Currency Conversion

- [ ] API-backed real-time exchange rates

### VisionKit Receipt Scanner

- [ ] OCR to extract bill total from photos

### SwiftData Bill History

- [ ] Saved calculations with search/filter

### Rounding Options

- [ ] Round tip, total, or per-person to nearest unit

### WidgetKit Home Screen Widget

- [ ] Quick-access recent calculation
