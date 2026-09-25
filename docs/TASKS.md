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

### V2 Bug Fixes

- [ ] **BF-1** Currency picker flags and rounding-row clipping on iOS 26 (reported 2026-09-25 from a simulator screenshot) · deps: —
  - AC: every currency option shows a rendered flag and its full code (NOK, USD, KES), with no "?" boxes or truncation, at the default text size and AX5, in light and dark mode. Keep the native segmented control if the flags render in it; otherwise use a chip row with flags (product decision)
  - AC: no rounding pill is clipped at the content-padding edge, and all 4 are reachable at AX5
  - AC: currency selection, persistence, haptics, VoiceOver selection state, and tokens only as before; code review plus design review Mode B, with before/after screenshots

### Phase 2A — Unequal Splits

Planned 2026-09-25 by v2-planner; decisions recorded the same day. 16 tasks, ~27h (design ~3h, dev ~24h). Critical path: 2A-1, 2A-2, 2A-4 → 2A-5 → 2A-6 → 2A-7 → 2A-8 → 2A-13 → 2A-14. Design (2A-0) runs alongside 2A-2 to 2A-5 and must be APPROVED before 2A-6, which implements the spec's row behavior. 2A-15 (iOS 17.0 target) must land before the first UI task, 2A-9. `‖` = parallel-safe: no open dependencies, so the task can go in any order and overlap with design work (still one ios-developer task at a time).

**Exit criteria:** every task ticked with code review APPROVED (plus design review Mode B for UI tasks) · deployment target iOS 17.0 and a build with 0 warnings · the 50 pre-2A tests pass with unchanged expectations · switching to Custom starts balanced from the equal-split prefill · custom shares sum exactly (Int minor units) to the displayed total for 1–20 people under None, Tip ↑, and Total ↑, and Per Person ↑ shows the surplus as its own line · comma and point decimals work in the bill and custom fields · equal mode behaves as before.

#### Decisions (2026-09-25)

- **Q1** Custom input is amounts only; percentages are deferred.
- **Q2** Custom amounts are pre-tip bill portions that must add up to the bill. Tip and rounding are split in proportion.
- **Q3** People are labeled "Person 1…N", with no names.
- **Q4** Nothing persists: the app launches in equal mode, and amounts last for the session only.
- **Q5** Tip ↑ and Total ↑ split the rounded total in proportion. Per Person ↑ rounds each custom share up to a whole unit and shows the surplus as its own line.
- **Q6** While the split is invalid, no per-person amounts are shown; only a left/over status with text + icon.
- **Q7** (refined) Switching to Custom starts from the equal split: rows are prefilled with equal portions of the bill that add up exactly to it, with any leftover øre/cent going to the lowest-numbered people (the `ShareAllocator` tie rule). Typed amounts are kept for the session and rechecked live. Mode, currency, tip, and rounding switches keep them. + adds a row and − removes the last. The spec (2A-0) sets what a newly added row contains and whether untouched prefilled rows follow bill or count changes.
- **Q8** Yes: 2A-1 also ships early as hotfix 2.0.1, cherry-picked onto `main`. The PM handles the release mechanics and asks the human before pushing.
- **Q9** Lower the deployment target to iOS 17.0 (the project is set to 26.2; the docs say 17+). Done in 2A-15, before the first UI task.

#### Tasks

- [ ] **2A-0** Design spec `docs/design/2A-unequal-splits.md` (ui-designer → design-reviewer Mode A) (~3h) · deps: — (Q1–Q9 decided)
  - AC: design-reviewer returns APPROVED (Mode A) within 3 rounds
  - AC: specifies the split-mode control, `PersonSplitRow`, a left/over/balanced indicator that uses text + icon (never color alone), and the results-card breakdown, including the invalid state (no per-person amounts, Q6) and the Per Person ↑ surplus line (Q5)
  - AC: specifies the custom-mode rows (Q7): the prefilled equal split and its text format, what a row added by + contains, and whether untouched prefilled rows follow bill or count changes, including a switch to Custom before a bill is typed
  - AC: specifies the 1-person case, the keyboard flow across the bill and person fields (one Done, Next/Previous), the AX5 row layout, a VoiceOver label and value per control, and Reduce Motion
  - AC: lists new tokens (for example a warning color) with light and dark values, or states "none"; uses only iOS 17 APIs
- [x] **2A-1** `AmountParser`: locale-tolerant amount parsing that fixes comma-decimal bill input (~1.5h) · deps: — · ‖ · b33aca0, code review APPROVED 5/5, 0 fix rounds
  - AC: pure `enum AmountParser` in `Services/`, tested in a new `AmountParserTests.swift`
  - AC: `"12,50"` and `"12.50"` → 12.5; `"12"`, `"12,"`, `"12."` → 12; `",5"` → 0.5
  - AC: `""`, `"abc"`, `"12abc"`, `"1,2,3"`, `"1.234,50"`, `"-5"`, `"nan"`, `"inf"`, `"1e5"` → nil (today `Double(_:)` accepts the last four)
  - AC: minor units come straight from the text with no `Double` step: `"12,50"` → 1250, `"0.29"` → 29, `"1.005"` → 101 (half-up)
  - AC: `billAmount` uses the parser (`billAmountText = "12,50"` → `billAmount == 12.5`); the 50 existing tests pass unchanged
  - AC: one self-contained commit (parser, `billAmount`, tests, CHANGELOG "Fixed") that cherry-picks cleanly onto `main` for hotfix 2.0.1 (Q8)
- [ ] **2A-2** Test isolation: injectable `UserDefaults` for `CalculatorViewModel` (~1h) · deps: — · ‖
  - AC: `init(defaults: UserDefaults = .standard)`; all 5 persisted preferences read and write that store; app and preview behavior unchanged
  - AC: tests get a fresh `UserDefaults(suiteName:)` per ViewModel through one shared helper, including the 3 calls in the `BillParsingTests` suite that 2A-1 added (`billBudyTests/AmountParserTests.swift`); `grep -rn "CalculatorViewModel()" billBudyTests` → 0 matches (36 today)
  - AC: new round-trip test: set currency, tip, custom %, split, and rounding → `savePreferences()` → a new ViewModel on the same suite restores all 5
  - AC: the suite passes with `savedRounding = 2` (Total ↑) pre-seeded in the simulator app's standard defaults (by inspection, `EdgeCaseTests.veryLargeBill` fails in that state today)
- [ ] **2A-3** Split models: `SplitMode`, `PersonSplit`, `PersonShare` (~1h) · deps: — · ‖
  - AC: `SplitMode: Int, CaseIterable, Identifiable` with `.equal` = 0 and `.custom` = 1; `displayText` "Equal" / "Custom" (mirrors `RoundingMode`)
  - AC: `PersonSplit` (input) is `Identifiable` with a stable `id` (not the array index), a 1-based person number, and `amountText`; `label` == "Person N"
  - AC: `PersonSplit.isEdited` (default false, true once the user types in the row) lets 2A-6 tell untouched prefilled rows from typed ones (Q7); 2A-6 removes it if the approved spec never uses it
  - AC: `PersonShare` (output) holds the person number, bill portion, and share as Int minor units, plus `Double` accessors for display
  - AC: tests in a new `SplitModelTests.swift` cover case count, raw values, display text, labels, and a new `PersonSplit` starting unedited
- [ ] **2A-4** `ShareAllocator`: exact largest-remainder allocation in minor units (~2h) · deps: — · ‖
  - AC: pure `enum ShareAllocator` in `Services/`, Int minor units in and out; the minor-unit scale comes from `Currency.fractionDigits` (added by 2A-1; 2 for NOK, USD, and KES)
  - AC: parameterized test over n = 1…20 × totals {0, 1, 99, 100, 101, 11_500, 99_999_999}: `sum == total` exactly (Int equality, no tolerance), every share ≥ 0, count == n; with equal weights, max − min ≤ 1
  - AC: `allocate(10_000, [1, 1, 1]) == [3334, 3333, 3333]`; leftover units go to the largest remainders, ties to the lowest index (also the Q7 prefill rule)
  - AC: each weighted share is within 1 minor unit of total × wᵢ / Σw; `allocate(1_150, [333, 333, 334]) == [383, 383, 384]`
  - AC: all-zero weights → equal split; empty weights → `[]`; never divides by zero
  - AC: whole-unit round-up helper: 250 → 300, 300 → 300, 0 → 0
- [ ] **2A-5** ViewModel: tip and total in exact minor units (~1.5h) · deps: 2A-1, 2A-2, 2A-4
  - AC: one bill source: `billMinorUnits` = `AmountParser.minorUnits(from: billAmountText, currency: selectedCurrency)` (nil → 0), and `billAmount` derives from it, so the two always agree: `"1.005"` → 101 and `billAmount == 1.01` (today `billAmount` is 1.005 while the minor units are 101); tip, total, and shares start from `billMinorUnits`, every displayed result derives from them, and the bill field keeps the text as typed
  - AC: tip and total are computed as Int minor units (tip rounded half-up to 1 øre/cent; Tip ↑ and Total ↑ round up to a whole unit as today), and `tipAmount` and `totalAmount` derive from them
  - AC: bill "33.30" at 15% → `tipAmount == 5.0` and `totalAmount == 38.3` (today these are 4.99499… and 38.29499…, displayed as "4,99 kr" and "38,29 kr")
  - AC: equal-mode `perPersonAmount` is unchanged; all pre-existing tests pass with unchanged expectations (none uses a bill with more than 2 decimals)
- [ ] **2A-6** ViewModel: custom split state, equal-split prefill, and validation (~3h) · deps: 2A-0, 2A-3, 2A-5
  - AC: `splitMode` (default `.equal`) and `personSplits`; `personSplits.count == splitCount` after init (restored count), `incrementSplit()`, `decrementSplit()`, and direct assignment; + appends a row and − removes the last; a new row's content per spec 2A-0
  - AC: the first switch to Custom in a session prefills every row with the equal split of the bill via `ShareAllocator` (leftover øre/cent to the lowest-numbered people), so it starts `.balanced`: bill "100" with 3 people → rows parse to [3334, 3333, 3333] minor units
  - AC: each prefilled text parses back through `AmountParser` to its exact share, with no grouping separator (bill "3000" with 2 people → 150_000 each); text format per spec 2A-0
  - AC: `allocationStatus` is `.balanced` iff the sum of parsed amounts (empty = 0) equals the bill in minor units (Int equality), otherwise `.under(remaining)` or `.over(excess)` in minor units; rechecked on every change
  - AC: bill "20" with rows "12,50" + "7.50" → `.balanced`; "12,50" + "7" → `.under(50)`; "15" + "7.50" → `.over(250)`
  - AC: bill, tip, rounding, currency, and mode changes never modify a row the user has typed in (equal → custom → type → equal → custom keeps the typed text), and +/− only append or remove the last row; whether untouched prefilled rows follow bill or count changes per spec 2A-0
  - AC: no new `@AppStorage` keys; a new ViewModel starts in `.equal`
  - Note: if the approved spec makes the untouched-row rule more than re-running the prefill, the v2-planner splits it out before 2A-6 starts
- [ ] **2A-7** ViewModel: per-person shares with proportional tip (~2h) · deps: 2A-6
  - AC: `personShares` has one `PersonShare` per person in custom mode when `.balanced`, and is empty otherwise
  - AC: the shares sum exactly to the total in minor units for n = 1…20 under None, Tip ↑, and Total ↑ (parameterized test)
  - AC: tip is split in proportion to bill portions: bill 100 at 15% with [60, 40] → [69.00, 46.00]; bill 10 at 15% with [3.33, 3.33, 3.34] → [3.83, 3.83, 3.84]
  - AC: custom mode with 1 person and amount == bill → one share == total; equal mode unchanged
- [ ] **2A-8** ViewModel: rounding × custom splits (~1.5h) · deps: 2A-7
  - AC: Per Person ↑ with custom splits rounds each share up to a whole unit; `roundingSurplus` = sum of rounded shares − total, with 0 ≤ surplus < n whole units
  - AC: bill 100 at 15%, [50, 30, 20], Per Person ↑ → [58, 35, 23] with surplus 1.00
  - AC: Total ↑: bill 95 at 15%, [45, 50] → [52.11, 57.89]; Tip ↑: bill 55 at custom 18%, [30, 25] → [35.45, 29.55]
  - AC: matrix test of 4 rounding modes × {equal, custom} × n ∈ {1, 2, 3, 7, 20}: invariants hold, and equal-mode values match pre-2A (the existing `roundPerPerson` test still gives 39.0)
- [ ] **2A-9** `SplitModeToggle` in `SplitControlView` (~1.5h) · deps: 2A-0, 2A-6, 2A-15
  - AC: matches the spec; bound to `splitMode`; light haptic via `HapticManager`; spring animation; 1-person state per spec
  - AC: VoiceOver label and value, ≥ 44 pt targets, tokens only (grep clean), `#Preview` in light and dark; equal-mode stepper unchanged
- [ ] **2A-10** `PersonSplitRow` view (~1.5h) · deps: 2A-0, 2A-1, 2A-3, 2A-15 · ‖ with 2A-5 to 2A-8
  - AC: standalone view that takes a binding (no ViewModel dependency): label "Person N", currency-symbol prefix, decimal-pad field, and inline invalid-input state per spec
  - AC: keeps the text as typed and parses only through `AmountParser` ("12,50" and "12.50" are both valid)
  - AC: AX5 layout per spec; VoiceOver label "Person N amount" and value with currency; tokens only; `#Preview`s for empty, filled, invalid, and AX5, in light and dark
- [ ] **2A-11** Custom split list and remaining indicator in `SplitControlView` (~2h) · deps: 2A-6, 2A-9, 2A-10, 2A-15
  - AC: in custom mode, one `PersonSplitRow` per person (1–20) via `ForEach` over stable ids, never index bindings; switching to Custom shows the prefilled equal split as balanced; a typed row counts as typed per 2A-6 (for example, the row binding's setter sets `isEdited`)
  - AC: + adds a row and − removes the last (2A-6), with new-row content per spec 2A-0
  - AC: a live left/over/balanced indicator per spec, as text + icon
  - AC: stepping 20 → 1 while the last row is focused doesn't crash; rows insert and remove with the spring animation, and without animation under Reduce Motion
  - AC: equal mode renders as before; previews for 3 and 20 people, in light and dark
- [ ] **2A-12** Keyboard focus flow across bill and person fields (~1.5h) · deps: 2A-11, 2A-15
  - AC: one `@FocusState` and one keyboard toolbar, owned by `CalculatorView` (moved out of `BillInputView`)
  - AC: exactly one Done button whichever field is focused; Next/Previous moves bill → Person 1 → … → Person N per spec
  - AC: bill field behavior otherwise unchanged
- [ ] **2A-13** `ResultsCardView`: custom per-person breakdown (~2h) · deps: 2A-0, 2A-8, 2A-15
  - AC: custom + balanced shows one `BreakdownRow` per person, labeled "Person N" and read from `personShares` (no arithmetic in the view), after the Tip and Total rows
  - AC: custom + not balanced shows no per-person amounts, only the left/over status per spec; Per Person ↑ shows the surplus as its own row per spec
  - AC: equal-mode card unchanged; VoiceOver value lists each share; stagger respects Reduce Motion; previews for equal, custom balanced, and custom invalid, in light and dark
- [ ] **2A-14** Docs and manual QA sweep (~1h) · deps: 2A-1 to 2A-13, 2A-15
  - AC: ARCHITECTURE.md covers the new types, ViewModel tables, and view hierarchy; README lists unequal splits
  - AC: TESTING.md's test count matches `xcodebuild test`, and it adds split and parser test tables, manual QA items for custom splits and comma-decimal regions, and working destination and `-only-testing` examples
  - AC: CHANGELOG `[Unreleased]` has Added (unequal splits), Changed (iOS 17.0 target), and Fixed (half-cent tip rounding, plus comma decimals unless the 2.0.1 hotfix already lists it under `[2.0.1]`, Q8), with no duplicate entries
  - AC: manual QA on a simulator with Region = Norway: bill "12,50" computes, and a 3-person custom split works end to end in all 4 rounding modes, starting from the prefilled equal split
- [ ] **2A-15** Lower deployment target to iOS 17.0 (~0.5–1h) · deps: — · ‖
  - AC: `IPHONEOS_DEPLOYMENT_TARGET = 17.0` in every build configuration that sets it: today the project-level Debug and Release entries (both 26.2); any target-level setting for billBudy or billBudyTests says 17.0 too (none today, both inherit)
  - AC: the build has 0 compiler warnings and all tests pass
  - AC: any API newer than iOS 17 that the compiler flags is replaced or gated with `#available` (a grep for common iOS 18/26 APIs finds none today)
  - AC: CHANGELOG notes the change under `[Unreleased]` → Changed
  - AC: the PR says how iOS 17 was checked: a smoke run on an iOS 17 simulator runtime, or compile-only (only iOS 26.3 is installed today)

#### Backlog

- Rejected bill input (for example a pasted "1 234,50") silently computes as 0, with no feedback in the bill field. Consider reusing 2A-10's invalid-input state for `BillInputView`.
- `MARKETING_VERSION` is 1.0 in the project while CHANGELOG is at 2.0.0 (release hygiene). Decide before tagging the 2.0.1 hotfix (Q8).
- [2A-1 N1] The tests read the app's real saved preferences. After manual use leaves Per Person ↑ selected, `splitByTwo` and `splitByThree` fail (59/61), because they never set `selectedRounding`. 2A-2 should pre-seed every non-default rounding mode (1, 2, 3), not only 2. Until then, run tests on a simulator with clean app data (the hotfix validation included).
- [2A-1 N2] Under the any-region rule, a pasted US-grouped `"1,234"` parses as 1.234, a silent 1000× under-read. The decimal pad can't type it, so it takes a paste or a hardware keyboard. Consider rejecting more than 2 fraction digits after "," for 2-decimal currencies.
- [2A-1 N3] The scale path in `AmountParser.minorUnits` is untested, because every currency uses 2. Add an internal `minorUnits(from:fractionDigits:)` seam and test it at 0 and 3 (`",5"`@0 → 1, `"1,0005"`@3 → 1001).
- [2A-1 N4] TESTING.md still says 39 tests (61 now) and has no AmountParser section. Its manual QA lacks a "type 12,50 with Region = Norway" step, which should be checked before tagging 2.0.1 (the rest is covered by 2A-14). CLAUDE.md also says 39 (human-owned).
- [2A-1 N6] `AmountParser` is stateless, so it could be `nonisolated` if a caller off the main actor ever appears.

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
