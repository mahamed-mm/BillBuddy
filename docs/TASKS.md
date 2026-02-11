# Tasks

BillBuddy development to-do list, organized by milestone.

---

## Milestone 1: Foundation (Day 1, ~5h)

### Project Scaffolding

- [ ] Create folder structure: Models/, ViewModels/, Views/Calculator/, Views/Results/, Views/Components/, Services/, DesignSystem/, Extensions/
- [ ] Update AccentColor asset to teal `#00E5CC`

### Models

- [ ] `TipPreset.swift` — enum with cases: zero, five, ten, fifteen, twenty, twentyFive, custom; percentage computed property
- [ ] `Currency.swift` — enum with cases: nok, usd, kes; symbol, flag, locale properties
- [ ] `TipCalculation.swift` — struct with tipAmount, totalAmount, perPersonAmount, tipPercent, splitCount

### Design System

- [ ] `AppColors.swift` — bbTeal, bbBackground, bbCardBackground, bbPrimaryText, bbSecondaryText, bbSelectedChip, bbSelectedBorder, bbUnselectedBorder
- [ ] `AppTypography.swift` — largeTitle, title, headline, body, caption, mono font presets
- [ ] `AppSpacing.swift` — xs(4), sm(8), md(16), lg(24), xl(32), xxl(48), cornerRadius(16), cardRadius(20)

### Services

- [ ] `HapticManager.swift` — enum with lightImpact(), mediumImpact(), success() static methods
- [ ] `CurrencyFormatter.swift` — enum with cached NumberFormatter per Currency locale, format(amount:currency:) method

### Extensions

- [ ] `View+HapticFeedback.swift` — .onHaptic() view modifier
- [ ] `Double+CurrencyFormatted.swift` — .formatted(as:) method using CurrencyFormatter

---

## Milestone 2: Core UI (Day 2–3, ~9h)

### ViewModel

- [ ] `CalculatorViewModel.swift` — @Observable class with all input/computed properties
- [ ] Wire up @AppStorage persistence with @ObservationIgnored bridge
- [ ] Unit-test-ready computed properties (tip math, split math)

### Calculator Views

- [ ] `CalculatorView.swift` — ScrollView composing all sub-views
- [ ] `BillInputView.swift` — TextField with decimal pad, currency symbol prefix, large mono font
- [ ] `TipSelectorView.swift` — LazyVGrid (2 columns) of preset buttons + conditional custom slider
- [ ] `TipPresetButton.swift` — selected/unselected states with bbTeal accent
- [ ] `SplitControlView.swift` — minus/plus buttons with count label, clamped 1–20

### Results Views

- [ ] `ResultsCardView.swift` — GlassCard containing BreakdownRows for tip, total, per-person
- [ ] `BreakdownRow.swift` — horizontal label + formatted currency value

### Component Views

- [ ] `CurrencyPickerView.swift` — segmented control with flag + currency code for NOK, USD, KES
- [ ] `GlassCard.swift` — rounded rect with bbCardBackground, shadow, cardRadius

### Screen Composition

- [ ] Wire CalculatorView into ContentView
- [ ] Inject CalculatorViewModel via @State + .environment() in billBudyApp.swift
- [ ] Verify full screen renders in SwiftUI Preview

---

## Milestone 3: Polish (Day 3–4, ~7h)

### Animations

- [ ] Spring animation on tip/total/per-person value changes
- [ ] Staggered entrance animation for result card rows
- [ ] Smooth slider thumb tracking

### Haptics

- [ ] Light impact on tip preset selection
- [ ] Medium impact on split count change
- [ ] Success notification on first calculation result

### Persistence

- [ ] Load saved currency, tip preset, split count in ViewModel init()
- [ ] Save preferences on each change via savePreferences()
- [ ] Verify preferences survive app restart

### Dark/Light Mode QA

- [ ] Dark mode: all text readable, card surfaces elevated, teal accent visible
- [ ] Light mode: functional, no invisible text or elements
- [ ] Test both modes on multiple simulator devices

### Edge Cases

- [ ] Empty bill amount shows zero tip/total
- [ ] Bill amount of 0 handled gracefully
- [ ] Split count at bounds (1 and 20) — stepper disables correctly
- [ ] Very large bill amounts don't overflow layout
- [ ] Rapid input doesn't cause lag or glitches
- [ ] Currency switch updates all displayed amounts immediately

### Previews

- [ ] #Preview block in every view file
- [ ] All previews render without crashes
- [ ] Preview with sample data for both light and dark mode

---

## Milestone 4: Release Prep

- [ ] Run full manual QA checklist (see TESTING.md)
- [ ] Verify zero Xcode build warnings
- [ ] Capture screenshots for README (dark mode, light mode)
- [ ] Update README.md with real screenshots
- [ ] Move [Unreleased] items to [1.0.0] in CHANGELOG.md
- [ ] Tag release: `git tag v1.0.0`
