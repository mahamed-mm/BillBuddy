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

### Phase 1A — Dark-Mode UI

- [x] Build adaptive color system — update `AppColors` with dark/light variants using `Color(.init(dynamicProvider:))` for all tokens
- [x] Enhance `GlassCard` — add elevated surface material, subtle border, shadow adjustments for dark mode
- [x] View-by-view QA — verify text readability, contrast ratios, card elevation, and teal accent visibility in both modes on multiple simulators
- [x] Docs update — add dark-mode screenshots to README, update STYLE-GUIDE.md with adaptive color table, note in CHANGELOG.md

### Phase 1B — Rounding Options

- [x] `RoundingMode` model — enum with cases: none, roundTip, roundTotal, roundPerPerson; display label computed property
- [x] ViewModel integration — add `selectedRoundingMode` property to `CalculatorViewModel`, apply rounding logic to computed outputs, persist via `@AppStorage`
- [x] `RoundingSelectorView` — segmented control or chip row for selecting rounding mode, wire into `CalculatorView`
- [x] Unit tests — rounding math for each mode, edge cases (zero bill, custom tip with rounding), persistence round-trip (11 tests)
- [x] Docs update — add rounding feature to ARCHITECTURE.md, STYLE-GUIDE.md tokens if needed, CHANGELOG.md

### Phase 2A — Unequal Splits

- [ ] `SplitMode` model — enum with cases: equal, custom; display label property
- [ ] `PersonSplit` model — struct with personIndex, name (optional), customAmount or percentage
- [ ] ViewModel extensions — add `splitMode`, `personSplits` array, computed per-person breakdowns, validation (splits sum to total)
- [ ] `SplitModeToggle` — toggle/segmented control to switch between equal and custom split modes
- [ ] `PersonSplitRow` — editable row per person showing name, amount field, percentage, with inline validation
- [ ] Update `SplitControlView` — conditionally show equal stepper or custom split list based on `splitMode`
- [ ] Update `ResultsCardView` — show per-person breakdown table when custom splits are active
- [ ] Unit tests — equal vs custom splits, validation (over/under allocation), edge cases (1 person custom, max persons)
- [ ] Docs update — add split models to ARCHITECTURE.md, update TASKS.md progress, CHANGELOG.md

### Phase 2B — Live Currency Conversion

- [ ] `ExchangeRate` model — struct with baseCurrency, targetCurrency, rate, fetchedAt timestamp
- [ ] `ExchangeRateService` — async service to fetch rates from a free API, caching layer, error handling, rate-limit awareness
- [ ] ViewModel integration — add `convertedAmount` computed property, `refreshRates()` action, loading/error states, auto-refresh interval
- [ ] `ConversionBannerView` — inline banner below results showing converted amount, last-updated timestamp, refresh button
- [ ] Update `CurrencyPickerView` — show live rate hint next to each currency option when rates are available
- [ ] Unit tests — rate fetching mock, conversion math, cache expiry, error states, offline fallback
- [ ] Docs update — add service layer to ARCHITECTURE.md, document API key setup if needed, CHANGELOG.md

### Phase 2C — SwiftData History

- [ ] `SavedCalculation` model — `@Model` class with billAmount, tipPercent, splitCount, currency, tipAmount, totalAmount, perPersonAmount, date, optional note
- [ ] ModelContainer setup — configure `ModelContainer` in `billBudyApp.swift`, inject into environment
- [ ] `HistoryViewModel` — `@Observable` class with fetch, delete, search/filter logic using `@Query` or manual predicates
- [ ] Save action — add "Save" button to `ResultsCardView`, create `SavedCalculation` from current state, success haptic
- [ ] `HistoryListView` — list of saved calculations with date, amount, currency, swipe-to-delete
- [ ] `HistoryDetailView` — full breakdown of a saved calculation, option to restore values to calculator
- [ ] Navigation setup — add tab bar or navigation link from `ContentView` to history, deep-link support
- [ ] Unit tests — save/fetch/delete operations, search filtering, model encoding, edge cases (empty history)
- [ ] Docs update — add SwiftData layer to ARCHITECTURE.md, update folder structure, CHANGELOG.md

### Phase 3A — Receipt Scanner

- [ ] Camera permission — add `NSCameraUsageDescription` to Info.plist, handle permission request flow and denied state
- [ ] `ReceiptScannerService` — VisionKit `DataScannerViewController` wrapper, text recognition to extract bill total, confidence scoring
- [ ] `ScannerSheetView` — sheet presenting camera scanner, overlay with guidance text, cancel/confirm actions
- [ ] `BillInputView` integration — add camera icon button, present scanner sheet, populate bill amount from scan result
- [ ] Error handling — no text found, low confidence, camera unavailable, permission denied states with user-friendly messages
- [ ] Unit tests — text extraction parsing logic, amount pattern matching, edge cases (multiple amounts, foreign formats)
- [ ] Docs update — add VisionKit integration to ARCHITECTURE.md, document permissions, CHANGELOG.md

### Phase 3B — WidgetKit

- [ ] Widget target — add `billBudyWidget` extension target to Xcode project, configure shared app group for data access
- [ ] Timeline provider — `TimelineProvider` returning latest saved calculation or placeholder, refresh policy
- [ ] Widget views — small and medium widget families showing last calculation summary (amount, tip, total, currency)
- [ ] Configuration — `AppIntentConfiguration` for user to select which currency or calculation to display
- [ ] Deep link — tapping widget opens app to calculator or history detail, URL scheme handling in `billBudyApp.swift`
- [ ] Docs update — add widget target to ARCHITECTURE.md folder structure, document app group setup, CHANGELOG.md

### Phase 4 — Integration & Release

- [ ] Standards audit — verify all new code follows STYLE-GUIDE.md tokens, naming conventions, Swift style rules from CLAUDE.md
- [ ] Cross-feature tests — test interactions between features (e.g., rounding + unequal splits, scanner + currency conversion, save + history)
- [ ] Edge cases — stress-test with extreme values, rapid feature switching, offline mode, low memory, backgrounding mid-scan
- [ ] Test coverage — ensure all new ViewModels and Services have unit tests, target 80%+ line coverage across new code
- [ ] Docs sweep — update all docs (ARCHITECTURE.md, STYLE-GUIDE.md, TESTING.md, TASKS.md, README.md) to reflect V2 features
- [ ] CHANGELOG v2.0.0 — move all [Unreleased] items to [2.0.0] section with date, summarize all phases
- [ ] Tag release — `git tag v2.0.0` after all checks pass
