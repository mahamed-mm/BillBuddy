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

Planned 2026-09-25 by v2-planner: 15 tasks, ~25h (design ~3h, dev ~22h). Critical path: 2A-1, 2A-2, 2A-4 → 2A-5 → 2A-6 → 2A-7 → 2A-8 → 2A-13 → 2A-14. Design (2A-0) runs alongside the logic tasks. `‖` = parallel-safe: no open dependencies, so the task can go in any order and overlap with design work (still one ios-developer task at a time).

**Exit criteria:** every task ticked with code review APPROVED (plus design review Mode B for UI tasks) · build with 0 warnings · the 50 pre-2A tests pass with unchanged expectations · custom shares sum exactly (Int minor units) to the displayed total for 1–20 people under None, Tip ↑, and Total ↑, and the Per Person ↑ surplus is shown (pending Q5) · comma and point decimals work in the bill and custom fields · equal mode behaves as before.

#### Open decisions

Tasks are planned with the recommended option below. An AC tagged "(pending Q#)" changes if the human decides otherwise. The options and trade-offs are in the planner's report to the PM.

- **Q1** Custom input: amounts only; percentages deferred
- **Q2** Tip: custom amounts are pre-tip bill portions that must sum to the bill; tip and rounding are split in proportion
- **Q3** People: labeled "Person 1…N", no names
- **Q4** Persistence: none; the app launches in equal mode and amounts last for the session only
- **Q5** Rounding: Tip ↑ and Total ↑ split the rounded total in proportion; Per Person ↑ rounds each share up to a whole unit and shows the surplus
- **Q6** Invalid split: no per-person amounts until balanced; show the amount left or over
- **Q7** Edits: keep typed amounts and re-validate; the stepper adds or removes the last row; mode and currency switches keep amounts
- **Q8** Parsing fix: ships in 2A as 2A-1, accepts "," and "." on any region, and is also cherry-picked to `main` as 2.0.1
- **Q9** Deployment target: the project is set to iOS 26.2 while the docs say 17+; lower it to 17.0 before 2A-9

#### Tasks

- [ ] **2A-0** Design spec `docs/design/2A-unequal-splits.md` (ui-designer → design-reviewer Mode A) (~3h) · deps: answers to Q1–Q3 and Q5–Q7 (Mobbin research can start now)
  - AC: design-reviewer returns APPROVED (Mode A) within 3 rounds
  - AC: specifies the split-mode control, `PersonSplitRow`, a left/over/balanced indicator that uses text + icon (never color alone), and the results-card breakdown, including the invalid state (pending Q6) and the Per Person ↑ surplus (pending Q5)
  - AC: specifies stepper behavior in custom mode (pending Q7), the 1-person case, the keyboard flow across the bill and person fields (one Done, Next/Previous), the AX5 row layout, a VoiceOver label and value per control, and Reduce Motion
  - AC: lists new tokens (for example a warning color) with light and dark values, or states "none"; uses only iOS 17 APIs (pending Q9)
- [ ] **2A-1** `AmountParser`: locale-tolerant amount parsing that fixes comma-decimal bill input (~1.5h) · deps: — · ‖
  - AC: pure `enum AmountParser` in `Services/`, tested in a new `AmountParserTests.swift`
  - AC: `"12,50"` and `"12.50"` → 12.5; `"12"`, `"12,"`, `"12."` → 12; `",5"` → 0.5 (pending Q8)
  - AC: `""`, `"abc"`, `"12abc"`, `"1,2,3"`, `"1.234,50"`, `"-5"`, `"nan"`, `"inf"`, `"1e5"` → nil (today `Double(_:)` accepts the last four)
  - AC: minor units come straight from the text with no `Double` step: `"12,50"` → 1250, `"0.29"` → 29, `"1.005"` → 101 (half-up)
  - AC: `billAmount` uses the parser (`billAmountText = "12,50"` → `billAmount == 12.5`); the 50 existing tests pass unchanged
  - AC: one self-contained commit (parser, `billAmount`, tests, CHANGELOG "Fixed") that cherry-picks cleanly onto `main` (pending Q8)
- [ ] **2A-2** Test isolation: injectable `UserDefaults` for `CalculatorViewModel` (~1h) · deps: — · ‖
  - AC: `init(defaults: UserDefaults = .standard)`; all 5 persisted preferences read and write that store; app and preview behavior unchanged
  - AC: tests get a fresh `UserDefaults(suiteName:)` per ViewModel through one shared helper; `grep -rn "CalculatorViewModel()" billBudyTests` → 0 matches
  - AC: new round-trip test: set currency, tip, custom %, split, and rounding → `savePreferences()` → a new ViewModel on the same suite restores all 5
  - AC: the suite passes with `savedRounding = 2` (Total ↑) pre-seeded in the simulator app's standard defaults (by inspection, `EdgeCaseTests.veryLargeBill` fails in that state today)
- [ ] **2A-3** Split models: `SplitMode`, `PersonSplit`, `PersonShare` (~1h) · deps: — · ‖
  - AC: `SplitMode: Int, CaseIterable, Identifiable` with `.equal` = 0 and `.custom` = 1; `displayText` "Equal" / "Custom" (mirrors `RoundingMode`)
  - AC: `PersonSplit` (input) is `Identifiable` with a stable `id` (not the array index), a 1-based person number, and `amountText` (pending Q1); `label` == "Person N" (pending Q3)
  - AC: `PersonShare` (output) holds the person number, bill portion, and share as Int minor units, plus `Double` accessors for display
  - AC: tests in a new `SplitModelTests.swift` cover case count, raw values, display text, and labels
- [ ] **2A-4** `ShareAllocator`: exact largest-remainder allocation in minor units (~2h) · deps: — · ‖
  - AC: pure `enum ShareAllocator` in `Services/`, Int minor units in and out; the minor-unit scale has one source (for example `Currency.fractionDigits`, 2 for NOK, USD, and KES)
  - AC: parameterized test over n = 1…20 × totals {0, 1, 99, 100, 101, 11_500, 99_999_999}: `sum == total` exactly (Int equality, no tolerance), every share ≥ 0, count == n; with equal weights, max − min ≤ 1
  - AC: `allocate(10_000, [1, 1, 1]) == [3334, 3333, 3333]`; leftover units go to the largest remainders, ties to the lowest index
  - AC: each weighted share is within 1 minor unit of total × wᵢ / Σw; `allocate(1_150, [333, 333, 334]) == [383, 383, 384]`
  - AC: all-zero weights → equal split; empty weights → `[]`; never divides by zero
  - AC: whole-unit round-up helper: 250 → 300, 300 → 300, 0 → 0
- [ ] **2A-5** ViewModel: tip and total in exact minor units (~1.5h) · deps: 2A-1, 2A-2, 2A-4
  - AC: tip and total are computed as Int minor units (tip rounded half-up to 1 øre/cent; Tip ↑ and Total ↑ round up to a whole unit as today), and `tipAmount` and `totalAmount` derive from them
  - AC: bill "33.30" at 15% → `tipAmount == 5.0` and `totalAmount == 38.3` (today these are 4.99499… and 38.29499…, displayed as "4,99 kr" and "38,29 kr")
  - AC: equal-mode `perPersonAmount` is unchanged; all pre-existing tests pass with unchanged expectations
- [ ] **2A-6** ViewModel: custom split state and validation (~2.5h) · deps: 2A-3, 2A-5
  - AC: `splitMode` (default `.equal`) and `personSplits`; `personSplits.count == splitCount` after init (restored count), `incrementSplit()`, `decrementSplit()`, and direct assignment; + appends an empty row and − removes the last (pending Q7)
  - AC: `allocationStatus` is `.balanced` iff the sum of parsed amounts (empty = 0) equals the bill in minor units (Int equality), otherwise `.under(remaining)` or `.over(excess)` in minor units (pending Q1, Q2)
  - AC: bill "20" with rows "12,50" + "7.50" → `.balanced`; "12,50" + "7" → `.under(50)`; "15" + "7.50" → `.over(250)`
  - AC: bill, tip, rounding, and currency changes never modify `personSplits`; equal → custom → equal → custom keeps typed amounts (pending Q7)
  - AC: no new `@AppStorage` keys; a new ViewModel starts in `.equal` (pending Q4)
- [ ] **2A-7** ViewModel: per-person shares with proportional tip (~2h) · deps: 2A-6
  - AC: `personShares` has one `PersonShare` per person in custom mode when `.balanced`, and is empty otherwise (pending Q6)
  - AC: the shares sum exactly to the total in minor units for n = 1…20 under None, Tip ↑, and Total ↑ (parameterized test)
  - AC: tip is split in proportion to bill portions (pending Q2): bill 100 at 15% with [60, 40] → [69.00, 46.00]; bill 10 at 15% with [3.33, 3.33, 3.34] → [3.83, 3.83, 3.84]
  - AC: custom mode with 1 person and amount == bill → one share == total; equal mode unchanged
- [ ] **2A-8** ViewModel: rounding × custom splits (~1.5h) · deps: 2A-7
  - AC: Per Person ↑ with custom splits rounds each share up to a whole unit; `roundingSurplus` = sum of rounded shares − total, with 0 ≤ surplus < n whole units (pending Q5)
  - AC: bill 100 at 15%, [50, 30, 20], Per Person ↑ → [58, 35, 23] with surplus 1.00 (pending Q5)
  - AC: Total ↑: bill 95 at 15%, [45, 50] → [52.11, 57.89]; Tip ↑: bill 55 at custom 18%, [30, 25] → [35.45, 29.55] (pending Q2, Q5)
  - AC: matrix test of 4 rounding modes × {equal, custom} × n ∈ {1, 2, 3, 7, 20}: invariants hold, and equal-mode values match pre-2A (the existing `roundPerPerson` test still gives 39.0)
- [ ] **2A-9** `SplitModeToggle` in `SplitControlView` (~1.5h) · deps: 2A-0, 2A-6
  - AC: matches the spec; bound to `splitMode`; light haptic via `HapticManager`; spring animation; 1-person state per spec
  - AC: VoiceOver label and value, ≥ 44 pt targets, tokens only (grep clean), `#Preview` in light and dark; equal-mode stepper unchanged
- [ ] **2A-10** `PersonSplitRow` view (~1.5h) · deps: 2A-0, 2A-1, 2A-3 · ‖ with 2A-5 to 2A-8
  - AC: standalone view that takes a binding (no ViewModel dependency): label (pending Q3), currency-symbol prefix, decimal-pad field, and inline invalid-input state per spec
  - AC: keeps the text as typed and parses only through `AmountParser` ("12,50" and "12.50" are both valid)
  - AC: AX5 layout per spec; VoiceOver label "Person N amount" and value with currency; tokens only; `#Preview`s for empty, filled, invalid, and AX5, in light and dark
- [ ] **2A-11** Custom split list and remaining indicator in `SplitControlView` (~2h) · deps: 2A-6, 2A-9, 2A-10
  - AC: in custom mode, one `PersonSplitRow` per person (1–20) via `ForEach` over stable ids, never index bindings; stepper behavior per spec (pending Q7)
  - AC: a live left/over/balanced indicator per spec, as text + icon (pending Q6)
  - AC: stepping 20 → 1 while the last row is focused doesn't crash; rows insert and remove with the spring animation, and without animation under Reduce Motion
  - AC: equal mode renders as before; previews for 3 and 20 people, in light and dark
- [ ] **2A-12** Keyboard focus flow across bill and person fields (~1.5h) · deps: 2A-11
  - AC: one `@FocusState` and one keyboard toolbar, owned by `CalculatorView` (moved out of `BillInputView`)
  - AC: exactly one Done button whichever field is focused; Next/Previous moves bill → Person 1 → … → Person N per spec
  - AC: bill field behavior otherwise unchanged
- [ ] **2A-13** `ResultsCardView`: custom per-person breakdown (~2h) · deps: 2A-0, 2A-8
  - AC: custom + balanced shows one `BreakdownRow` per person, read from `personShares` (no arithmetic in the view), after the Tip and Total rows (pending Q3)
  - AC: custom + not balanced shows no per-person amounts, only the status per spec (pending Q6); Per Person ↑ adds a surplus row per spec (pending Q5)
  - AC: equal-mode card unchanged; VoiceOver value lists each share; stagger respects Reduce Motion; previews for equal, custom balanced, and custom invalid, in light and dark
- [ ] **2A-14** Docs and manual QA sweep (~1h) · deps: 2A-1 to 2A-13
  - AC: ARCHITECTURE.md covers the new types, ViewModel tables, and view hierarchy; README lists unequal splits
  - AC: TESTING.md's test count matches `xcodebuild test`, and it adds split and parser test tables, manual QA items for custom splits and comma-decimal regions, and working destination and `-only-testing` examples
  - AC: CHANGELOG `[Unreleased]` has Added (unequal splits) and Fixed (comma decimals, half-cent tip rounding)
  - AC: manual QA on a simulator with Region = Norway: bill "12,50" computes, and a 3-person custom split works end to end in all 4 rounding modes

#### Backlog


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
  - [ ] Unequal splits × 2B/2C: converted custom shares still sum exactly to the converted total, and `SavedCalculation` stores the split mode and per-person shares (added in 2A planning)
- [ ] Edge cases — stress-test with extreme values, rapid feature switching, offline mode, low memory, backgrounding mid-scan
- [ ] Test coverage — ensure all new ViewModels and Services have unit tests, target 80%+ line coverage across new code
- [ ] Docs sweep — update all docs (ARCHITECTURE.md, STYLE-GUIDE.md, TESTING.md, TASKS.md, README.md) to reflect V2 features
- [ ] CHANGELOG v2.0.0 — move all [Unreleased] items to [2.0.0] section with date, summarize all phases
- [ ] Tag release — `git tag v2.0.0` after all checks pass
