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

- [x] **BF-1** Currency picker flags and rounding-row clipping on iOS 26 (reported 2026-09-25 from a simulator screenshot) · deps: — · 9cd3765 + ab13cb8, code review APPROVED 5/5 and design review Mode B APPROVED in round 2 (round 1 [B1]: dead tap bands on the widened pills; found by both reviewers and CodeRabbit)
  - AC: every currency option shows a rendered flag and its full code (NOK, USD, KES), with no "?" boxes or truncation, at the default text size and AX5, in light and dark mode. Keep the native segmented control if the flags render in it; otherwise use a chip row with flags (product decision)
    - Resolved without an app change: the "?" boxes come from the iOS 26.3.1 Simulator runtime, whose emoji font file is missing (Safari shows the same boxes), and 9cd3765 traces the truncation to the same fallback glyphs. The unchanged `CurrencyPickerView` renders the Norwegian, US, and Kenyan flags correctly on iOS 17.5 (PM check, 2026-09-25), so the native segmented control stays
  - AC: no rounding pill is clipped at the content-padding edge, and all 4 are reachable at AX5
  - AC: currency selection, persistence, haptics, VoiceOver selection state, and tokens only as before; code review plus design review Mode B, with before/after screenshots
  - Flags: no app change. Both variants of the iOS 26.3.1 Simulator runtime (arm64-only and universal, reinstalled 2026-09-26) ship the emoji font only as `Fonts/CoreAddition/AppleColorEmoji-160px.ttc`, while CoreText opens `Fonts/Core/AppleColorEmoji.ttc`, so every emoji renders as a "?" box (Safari too). The flags render correctly on iOS 17.5. Check flags on iOS 17.5 or a device.
  - Backlog (from the BF-1 reviews):
    - `TipPresetButton` has a `.clear` fill without `contentShape`, so taps on the empty chip area can miss (design N1, code N2). `TipSelectorView` still uses `LazyVGrid`, whose off-screen chips leave the accessibility tree at AX5 (code r2 N3). It keeps 2 columns at AX sizes, so "Custom" hyphenates (design r2 N6): reuse `columnCount(for:)` and an eager `Grid`.
    - The rounding pills use `Capsule()`, while STYLE-GUIDE says chip radius is `cornerRadius` (16 pt) (design N2).
    - Rounding VoiceOver labels read "Tip up arrow rounding". Suggested: "Round tip up" and so on, with the `.isSelected` trait and `.isHeader` on "Rounding" (design N3).
    - In light previews, selected chip text (`bbTeal` on `bbSelectedChip`) is 1.4:1 (design N4). Forced dark hides it at runtime; 2A-18's `bbTealText` addresses it.
    - ARCHITECTURE's view hierarchy omits `RoundingSelectorView` and says "TipPresetButton ×6" (there are 7) (code N4).
    - The UI harness `LazyTreeProbeUITests` needs `.firstMatch` on its "Results" query (scratch harness only).

### Phase 2A — Unequal Splits

Planned 2026-09-25 by v2-planner; decisions recorded the same day. Aligned the same day with the approved spec `docs/design/2A-unequal-splits.md` (automatic rows; its §3.1 impact table and §6 ACs): 2A-6's status work moved to 2A-16, `SplitStatusView` moved out of 2A-11 into 2A-17, and the five new tokens got their own task, 2A-18. 19 tasks, ~34.5h (design ~3h, dev ~31.5h). The ~7.5h over the first plan comes mostly from the spec's UI scope (pinned status card, Clear amounts, AX layouts, announcements), plus the iOS 17.5 smoke run and the input cap. Longest chain: 2A-2 → 2A-5 → 2A-6 → 2A-16 → 2A-17 → 2A-11 → 2A-12 → 2A-14, with 2A-16 → 2A-7 → 2A-8 → 2A-13 alongside. 2A-15 (iOS 17.0 target) must land before any task that adds or changes a view (2A-9 to 2A-13, 2A-17). `‖` = parallel-safe: no open dependencies, so the task can go in any order (still one ios-developer task at a time).

**Exit criteria:** every task ticked with code review APPROVED (plus design review Mode B for tasks that touch `Views/` or `DesignSystem/`) · deployment target iOS 17.0, a build with 0 warnings, and a smoke run on the iOS 17.5 simulator · the 50 pre-2A tests pass with unchanged expectations · switching to Custom starts balanced, with every row automatic (the equal split) · custom shares sum exactly (Int minor units) to the displayed total for 1–20 people under None, Tip ↑, and Total ↑, and Per Person ↑ shows the surplus as its own line · in Custom, Tip and Total stay on the results card in every status, and per-person amounts show only while the rows add up (Q6) · comma and point decimals work in the bill and custom fields · equal mode behaves as before (its only layout changes are the spec's: the toggle, the 44 pt stepper row, and `BreakdownRow` at AX sizes and under Reduce Motion).

#### Decisions (2026-09-25)

- **Q1** Custom input is amounts only; percentages are deferred.
- **Q2** Custom amounts are pre-tip bill portions that must add up to the bill. Tip and rounding are split in proportion.
- **Q3** People are labeled "Person 1…N", with no names.
- **Q4** Nothing persists: the app launches in equal mode, and amounts last for the session only.
- **Q5** Tip ↑ and Total ↑ split the rounded total in proportion. Per Person ↑ rounds each custom share up to a whole unit and shows the surplus as its own line.
- **Q6** While the split is invalid (the rows don't add up), the results card shows no per-person amounts; a status with text + icon takes their place. Clarified by the human: Tip and Total stay on the card in every state, and only the per-person rows are replaced. PM decision: Q6 governs only the results card, so the input rows show their automatic preview amounts in every status (spec §3.1, §4.7).
- **Q7** (revised after the spec: the human approved automatic rows, which replace the prefilled amounts; spec §3.1) Custom starts from the equal split without writing any text. A row whose text is empty after trimming whitespace is *automatic*: it pays an even share of max(0, bill − the sum of valid typed rows), split with `ShareAllocator` equal weights, with leftover øre/cent going to the lowest-numbered automatic rows. Automatic amounts are computed and never written into `amountText`, so untouched rows follow bill, head-count, and other-row changes. Any other row is *typed*: the app never changes it, and it's kept for the session and rechecked live (mode, currency, tip, and rounding switches keep it). + appends an empty (automatic) row; − removes the last row, typed or automatic.
- **Q8** Yes: 2A-1 also ships early as hotfix 2.0.1, cherry-picked onto `main`. The PM handles the release mechanics and asks the human before pushing.
- **Q9** Lower the deployment target to iOS 17.0 (the project is set to 26.2; the docs say 17+). Done in 2A-15, before the first UI task.

#### Tasks

- [x] **2A-0** Design spec `docs/design/2A-unequal-splits.md` (ui-designer → design-reviewer Mode A) (~3h) · deps: — (Q1–Q9 decided) · 1ed3806, Mode A APPROVED in round 2 (round 1: [B1]–[B3] AX-size layout)
  - AC: design-reviewer returns APPROVED (Mode A) within 3 rounds
  - AC: specifies the split-mode control, `PersonSplitRow`, a left/over/balanced indicator that uses text + icon (never color alone), and the results-card breakdown, including the invalid state (no per-person amounts, Q6) and the Per Person ↑ surplus line (Q5)
  - AC: specifies the custom-mode rows (Q7): automatic rows with equal-share previews in the display-only, symbol-free locale format (two fraction digits and grouping), never prefilled or written to `amountText`; what a row added by + contains; how untouched rows follow bill or count changes; and a switch to Custom before a bill is typed
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
- [x] **2A-3** Split models: `SplitMode`, `PersonSplit`, `PersonShare` (~1h) · deps: — · ‖ · 6dcd8f0, code review APPROVED 5/5, 0 fix rounds
  - AC: `SplitMode: Int, CaseIterable, Identifiable` with `.equal` = 0 and `.custom` = 1; `displayText` "Equal" / "Custom" (mirrors `RoundingMode`)
  - AC: `PersonSplit` (input) is `Identifiable` with a stable `id` (not the array index), a 1-based person number, and `amountText` (empty by default); `label` == "Person N"
  - AC: no `isEdited`: whether a row is typed or automatic depends only on its text (spec §3.1). `PersonSplit` defines that rule once: automatic iff the text is empty after trimming whitespace (N12), usable on a bare `String` too (2A-10's row has only its text), so 2A-6 and 2A-10 share it
  - AC: `PersonShare` (output) holds the person number, bill portion, and share as Int minor units, plus `Double` accessors for display
  - AC: tests in a new `SplitModelTests.swift` cover case count, raw values, display text, labels, and the automatic rule: `""`, `"  "`, and a new `PersonSplit` are automatic; `"0"` (E15), `"12,50"`, and `"abc"` are typed
- [x] **2A-4** `ShareAllocator`: exact largest-remainder allocation in minor units (~2h) · deps: — · ‖ · b374867, code review APPROVED 5/5, 0 fix rounds
  - AC: pure `enum ShareAllocator` in `Services/`, Int minor units in and out; the minor-unit scale comes from `Currency.fractionDigits` (added by 2A-1; 2 for NOK, USD, and KES)
  - AC: parameterized test over n = 1…20 × totals {0, 1, 99, 100, 101, 11_500, 99_999_999}: `sum == total` exactly (Int equality, no tolerance), every share ≥ 0, count == n; with equal weights, max − min ≤ 1
  - AC: `allocate(10_000, weights: [1, 1, 1]) == [3334, 3333, 3333]`; leftover units go to the largest remainders, ties to the lowest index (also the Q7 automatic-row rule)
  - AC: each weighted share is within 1 minor unit of total × wᵢ / Σw; `allocate(1_150, weights: [333, 333, 334]) == [383, 383, 384]`
  - AC: all-zero weights → equal split; empty weights → `[]`; never divides by zero
  - AC: whole-unit round-up helper: 250 → 300, 300 → 300, 0 → 0
- [ ] **2A-5** ViewModel: tip and total in exact minor units, with an input cap (~2h) · deps: 2A-1, 2A-2, 2A-4
  - AC: one bill source: `billMinorUnits` = `AmountParser.minorUnits(from: billAmountText, currency: selectedCurrency)` (nil → 0), and `billAmount` derives from it, so the two always agree: `"1.005"` → 101 and `billAmount == 1.01` (today `billAmount` is 1.005 while the minor units are 101); tip, total, and shares start from `billMinorUnits`, every displayed result derives from them, and the bill field keeps the text as typed
  - AC: tip and total are computed as Int minor units (tip rounded half-up to 1 øre/cent; Tip ↑ and Total ↑ round up to a whole unit as today), and `tipAmount` and `totalAmount` derive from them
  - AC: bill "33.30" at 15% → `tipAmount == 5.0` and `totalAmount == 38.3` (today these are 4.99499… and 38.29499…, displayed as "4,99 kr" and "38,29 kr")
  - AC ([2A-4 N1]) input cap: `AmountParser.minorUnits(from:currency:)` returns nil above 10^15 minor units (10 000 000 000 000,00 kr), and the bill and every row are read through it. So tip (custom ≤ 50 %), total, 20 rounded-up shares, and row sums always fit in `Int`, and `ShareAllocator`'s `Int.max` saturation and weight-halving paths can't be reached. `"10000000000000"` → 1_000_000_000_000_000; `"10000000000000,01"` and `"92233720368547758,01"` → nil. Today the last one parses: after 2A-8, at 0 % tip with 1 person and Per Person ↑, it would show "92 233 720 368 547 758,07 kr", and with 2 people the sum of rounded shares would overflow and trap. Nothing decides validity through `amount(from:)` any more, or it applies the same cap
  - AC: over-cap text is rejected input, like `"abc"`: equal mode computes it as 0, as it does any rejected bill today (see the Backlog); in Custom it gives S1b for the bill and S2 for a row (2A-16), and the row shows "Invalid amount" (2A-10). This fits spec §3.2 and §4.5, which define those states as "`AmountParser` rejects it", so the spec needs no change
  - AC: equal-mode `perPersonAmount` is unchanged; all pre-existing tests pass with unchanged expectations (none uses a bill with more than 2 decimals)
  - AC ([2A-3 N1–N3]) one minor-units → `Double` conversion: move `PersonShare.amount(minorUnits:fractionDigits:)` to `Currency` as `amount(minorUnits:)`, next to `fractionDigits`, and keep the static seam. `billAmount`, `tipAmount`, and `totalAmount` (and 2A-8's `roundingSurplus`) derive through it, and `PersonShare`'s accessors call it. Its doc states both exactness bounds: ≤ 2^53 minor units and `fractionDigits` ≤ 22. The seam tests move to a `Currency` suite; `SplitModelTests.doubleAccessors` filters on `fractionDigits == 2` (as in [2A-4 N3]), and `scaleFromFractionDigits` drops the loop that recomputes its expected value with the accessor's own call (the checks at scales 0, 1, and 3 stay)
- [ ] **2A-6** ViewModel: custom split state and automatic rows (~2h) · deps: 2A-0, 2A-3, 2A-5
  - AC: `splitMode` (default `.equal`) and `personSplits`; `personSplits.count == splitCount` after init (restored count), `incrementSplit()`, `decrementSplit()`, and direct assignment, in either mode (E8); + appends an empty (automatic) row, and − removes the last row, typed or automatic (spec §3.1a, E5, E6)
  - AC: switching to Custom writes no text: bill "100" with 3 people → every `amountText` stays empty, and the rows' bill portions are [3334, 3333, 3333] minor units
  - AC: per-row bill portions in minor units, one per row in `personSplits` order, recomputed on every change: a typed row gets its `AmountParser` value (0 while invalid or over 2A-5's cap, spec §3.2); the automatic rows (2A-3's rule, N12) split max(0, bill − the sum of valid typed rows) through `ShareAllocator.allocate(_:weights:)` with equal weights, leftover units to the lowest-numbered automatic rows
  - AC: examples: bill "3000", 2 people → [150_000, 150_000]; bill "1250", 4 people, Person 1 "150" → [15_000, 36_667, 36_667, 36_666]; 4 automatic rows at 31_250, then + → 5 rows at 25_000; typed rows over the bill → automatic rows 0; no bill → every portion 0; a row of `"  "` is automatic
  - AC: automatic-amount display text per spec §3.1, through a new `CurrencyFormatter` function without the symbol: 150_000 → NOK "1 500,00" (the locale's no-break-space grouping) and USD/KES "1,500.00", tested in `CurrencyFormatterTests`; it's never written into `amountText` and never parsed
  - AC: the app never changes typed text: bill, tip, rounding, currency, and mode changes keep it (equal → custom → type → equal → custom keeps the typed text), and +/− only append an empty row or remove the last; untouched rows follow bill and count changes because their portions are computed (spec §3.1b)
  - AC: no new `@AppStorage` keys; a new ViewModel starts in `.equal` with every row empty (Q4)
  - AC ([2A-3 N4a]) rows stay numbered in order: `personSplits.map(\.personNumber) == Array(1...splitCount)` after init, `incrementSplit()`, `decrementSplit()`, and direct `splitCount` assignment (tested). `PersonShare.id`, the "Person N" labels, and 2A-17's "Check Person N's amount" rely on it, and `PersonSplit` doesn't enforce it
  - Split (2026-09-25): with the spec's new outputs, 2A-6 came to about 3.5h and 350 lines with tests, so the status (S1a–S5 and the lowest invalid row) and the Clear amounts logic moved to 2A-16
- [ ] **2A-7** ViewModel: per-person shares with proportional tip (~2h) · deps: 2A-6, 2A-16
  - AC: `personShares` has one `PersonShare` per person in custom mode when `.balanced` (S5), and is empty otherwise; the bill portions are 2A-6's per-row portions, typed or automatic
  - AC: the shares sum exactly to the total in minor units for n = 1…20 under None, Tip ↑, and Total ↑ (parameterized test)
  - AC: tip is split in proportion to bill portions: bill 100 at 15% with [60, 40] → [69.00, 46.00]; bill 10 at 15% with [3.33, 3.33, 3.34] → [3.83, 3.83, 3.84]; spec §4.7's worked example (bill 1250 at 15%, Person 1 "150" plus 3 automatic rows, None) → [172.50, 421.67, 421.67, 421.66]
  - AC: custom mode with 1 person → one share == total, whether the row is automatic or typed == bill; a row typed "0" (E15) gets a 0 share; equal mode unchanged
- [ ] **2A-8** ViewModel: rounding × custom splits (~1.5h) · deps: 2A-7
  - AC: Per Person ↑ with custom splits rounds each share up to a whole unit; `roundingSurplus` = sum of rounded shares − total, with 0 ≤ surplus < n whole units
  - AC: bill 100 at 15%, [50, 30, 20], Per Person ↑ → [58, 35, 23] with surplus 1.00; spec §4.7's worked example with Per Person ↑ → [173, 422, 422, 422] with surplus 1.50
  - AC: Total ↑: bill 95 at 15%, [45, 50] → [52.11, 57.89]; Tip ↑: bill 55 at custom 18%, [30, 25] → [35.45, 29.55]
  - AC: matrix test of 4 rounding modes × {equal, custom} × n ∈ {1, 2, 3, 7, 20}: invariants hold, and equal-mode values match pre-2A (the existing `roundPerPerson` test still gives 39.0)
- [ ] **2A-9** `SplitModeToggle` in `SplitControlView` (~2h) · deps: 2A-0, 2A-6, 2A-15, 2A-18
  - AC: `Views/Calculator/SplitModeToggle.swift` per spec §4.4 (`@Binding var mode: SplitMode`, no ViewModel dependency), below the stepper and bound to `splitMode`: two equal-width chips, exactly one selected; the selected chip shows a checkmark, `bbTealText`, `bbSelectedChip`, and `bbSelectedBorder`; the whole chip is hit-testable, including the `.clear` unselected one
  - AC: tapping the unselected chip fires `HapticManager.lightImpact()` before the change and animates with the spring (none under Reduce Motion); tapping the selected chip does nothing; enabled at 1–20 people; the chips stack at AX sizes
  - AC: the stepper is unchanged (glyphs, colors, haptics, VoiceOver label and value) except that its hit areas are 44×44 min-frames with a content shape inside each button's label, so its row is 44 pt tall (§4.3); in Custom mode − and + get the hints "Removes Person N" / "Adds Person N+1"; VoiceOver per §4.12
  - AC: tokens only (grep clean; the raw `44` in `SplitControlView` becomes `AppSpacing.minTapTarget`); `#Preview`s in light, dark, and AX5, each with either chip selected
- [ ] **2A-10** `PersonSplitRow` view (~2.5h) · deps: 2A-0, 2A-1, 2A-3, 2A-15, 2A-18 · ‖ with 2A-5 to 2A-8 and 2A-16
  - AC: standalone view per spec §4.5 (`Views/Calculator/PersonSplitRow.swift`, no ViewModel dependency) with its inputs: person number, `amountText` binding, currency, `automaticAmountText`, and a generic focus hook (`FocusState<Value?>.Binding` plus `focusValue`)
  - AC: horizontal up to `.xLarge` and stacked from `.xxLarge`; the label column is sized by the hidden "Person 20" and both captions, so fields align in every row; the row never changes height while typing or focusing, at default size and AX5
  - AC: the six §4.5 states render with the stated border (dashed when automatic), fill, caption, and clear-slot rules and precedence; the row is automatic iff 2A-3's rule says so (text empty after trimming whitespace, N12)
  - AC: the automatic preview is a `Text` (not the placeholder) in `bbSecondaryText` and `AppTypography.amountField`, with `.lineLimit(1)` and `.minimumScaleFactor(AppTypography.amountMinimumScale)`
  - AC: the clear slot and button use `AppSpacing.minTapTarget` min-frames, and the button's min-frame and `.contentShape(Rectangle())` sit inside its label, so the whole 44 pt slot is tappable (N11); at AX5 the glyph doesn't overflow the box or overlap the amount; the button empties the field and fires `lightImpact()`; a tap anywhere in the field box focuses the field
  - AC: keeps the text as typed and decides validity only through `AmountParser.minorUnits(from:currency:)`, so 2A-5's cap applies: "12,50" and "12.50" are valid, and "1,2,3" shows "Invalid amount"; VoiceOver per §4.5, with the same "splits the rest" phrase as the caption
  - AC: `#Preview`s: automatic, typed, automatic-focused, typed-focused, invalid, and AX5, in light and dark, plus §4.5's KES / `.xxxLarge` / 375 pt preview, which shows the stacked arrangement with "12,345.67" on one line, unscaled
- [ ] **2A-11** Custom split list and pinned status card (~3h) · deps: 2A-6, 2A-9, 2A-10, 2A-15, 2A-16, 2A-17
  - AC: in Custom mode only, `SplitControlView` shows the §4.3 custom block in order: rule caption (§4.9), one `PersonSplitRow` per person via `ForEach($viewModel.personSplits)` (stable ids with element bindings, never index bindings), then the footer; each row's `automaticAmountText` comes from 2A-6's formatter
  - AC: switching to Custom shows every row automatic, with the equal split, and balanced: bill 100,00 kr with 3 people → previews 33,34 · 33,33 · 33,33; bill 1 250 kr with 4 people and Person 1 = 150 → 366,67 · 366,67 · 366,66; Custom before a bill → previews 0,00 and S1a, following the bill as it's typed. A row is typed iff its text is non-empty after trimming (N12), and automatic rows preview in every status (Q6)
  - AC: + appends an automatic row and − removes the last; no other row's typed text changes
  - AC: the pinned card (`.safeAreaInset(edge: .bottom)` with `GlassCard` and 2A-17's `.pinned` `SplitStatusView`) shows only in Custom mode and sits directly above the keyboard toolbar while typing (§4.1)
  - AC: "Clear amounts" appears only with a typed row, asks first (dialog title visible), then makes every row automatic through 2A-16's `clearTypedAmounts()`; the 1-person hint appears only at 1 person
  - AC: the rows' focus hook uses §4.1's `CalculatorField` focus state, owned by `CalculatorView` (2A-12 moves the bill field into it and adds the toolbar); removing the focused row clears focus, and stepping 20 → 1 with Person 20 focused doesn't crash (E7)
  - AC: status announcements follow §4.1 and are posted with `accessibilitySpeechAnnouncementPriority = .low` (N15); nothing is announced while typing (2A-12 checks the bill-field and Done triggers)
  - AC: the block and rows insert and remove with the spring (none under Reduce Motion); equal mode renders as before, apart from the toggle and the 44 pt stepper row; `#Preview`s with 1, 3, and 20 people, in light and dark
- [ ] **2A-12** Keyboard focus flow across bill and person fields (~2h) · deps: 2A-11, 2A-15
  - AC: one `@FocusState` (§4.1's `CalculatorField`) and one keyboard toolbar, both in `CalculatorView`; `BillInputView` has no focus state or toolbar of its own and takes the binding (§4.2); exactly one Done button for any focused field
  - AC: Equal mode shows `[Spacer, Done]`, as today; Custom mode shows `[∧, ∨, Spacer, Done]` with the order bill → Person 1 → … → Person N and the ends disabled; Done sets focus to nil
  - AC: at every text size from default to AX5, on iPhone SE (3rd generation) and iPhone 16, in portrait and landscape: after any focus change, the focused field box is fully visible between the top of the screen and the pinned status card; the scroll `.id` is on the field box, not the row
  - AC (N13): in landscape from about AX3, the "Person N" label can scroll out above the focused field box. That's accepted, because the field's VoiceOver label and the Previous/Next order still identify the person, and the PR shows it in a screenshot. Showing the person number inside the field box would be a spec change, not part of 2A-12
  - AC: switching to Equal while a person field is focused dismisses the keyboard (E12); switching to Custom with the bill focused keeps focus and shows ∧/∨ (E13); leaving the bill field and Done now trigger 2A-11's announcement check; the bill field's behavior is otherwise unchanged
  - AC: `BillInputView` previews go through a wrapper with a local `@FocusState`, in light and dark
- [ ] **2A-13** `ResultsCardView`: custom per-person breakdown (~2.5h) · deps: 2A-0, 2A-8, 2A-15, 2A-17
  - AC: Tip and Total stay in every mode and status (Q6); the Equal-mode card is unchanged at default text size with Reduce Motion off
  - AC: Custom with 2–20 people in S5 shows "Each person pays", then one `BreakdownRow` "Person k" per person, read from `personShares` (no arithmetic in the view); Per Person ↑ adds "Extra from rounding up" last, even at 0,00; values match §4.7's worked example (2A-7, 2A-8)
  - AC: Custom with 1 person in S5 equals the Equal-mode 1-person card; Custom in S1a–S4 shows the inline `SplitStatusView` (2A-17), plus the caption for S2–S4, and no per-person amounts
  - AC: `BreakdownRow` per §4.8: stacks at AX sizes; values stay on one line and scale down (`AppTypography.amountMinimumScale`), never wrapping mid-number, and crossfade under Reduce Motion; the card's stagger has no offset or delay under Reduce Motion
  - AC: VoiceOver values per §4.7; `#Preview`s per §4.7 (Equal; Custom S5 with 4 people; S5 with Per Person ↑; S1a; S2; S3; S4) in light and dark, and `BreakdownRow` in light, dark, and AX5
- [ ] **2A-14** Docs and manual QA sweep (~1h) · deps: 2A-1 to 2A-13, 2A-15 to 2A-18
  - AC: ARCHITECTURE.md covers the new types, ViewModel tables, and view hierarchy (`SplitModeToggle`, `PersonSplitRow`, `SplitStatusView`, and the `CalculatorField` focus flow); README lists unequal splits
  - AC: TESTING.md's test count matches `xcodebuild test`, and it adds split and parser test tables, manual QA items for custom splits and comma-decimal regions, and working destination and `-only-testing` examples
  - AC: CHANGELOG `[Unreleased]` has Added (unequal splits), Changed (iOS 17.0 target), and Fixed (half-cent tip rounding, plus comma decimals unless the 2.0.1 hotfix already lists it under `[2.0.1]`, Q8), with no duplicate entries
  - AC: manual QA with Region = Norway, on the default simulator and the iOS 17.5 one (2A-15): bill "12,50" computes, and a 3-person custom split works end to end in all 4 rounding modes, starting from the automatic equal split
- [x] **2A-15** Lower deployment target to iOS 17.0 (~1.5h) · deps: — · ‖ · 9d4c6b8, code review APPROVED 5/5, 0 fix rounds; idle cold launch (PM, 2026-09-26, iPhone 15 on iOS 17.5, 1 simulator booted, no builds): cmd→first frame 0.520–0.654 s, median 0.548 s (anim→first median 0.320 s)
  - AC: `IPHONEOS_DEPLOYMENT_TARGET = 17.0` in every build configuration that sets it: today the project-level Debug and Release entries (both 26.2); any target-level setting for billBudy or billBudyTests says 17.0 too (none today, both inherit)
  - AC: the build has 0 compiler warnings and all tests pass
  - AC: any API newer than iOS 17 that the compiler flags is replaced or gated with `#available` (a grep for common iOS 18/26 APIs finds none today, and the PM's 2026-09-25 build with a 17.0 override had 0 errors and ran)
  - AC: CHANGELOG notes the change under `[Unreleased]` → Changed
  - AC: a smoke run is required (compile-only no longer counts) on the iOS 17.5 simulator, iPhone 15, UDID `EADBBAF4-EA50-4F49-B936-E401EBF1AF4C`: the app installs and launches; bill (including "12,50"), tip, split, rounding, and currency work; preferences survive a relaunch; and `xcodebuild test` passes on that destination too. A test that fails only on 17.5 is reported to the PM, not skipped. The PR lists the commands and results
  - AC: cold-launch time to the first frame on that simulator with the Mac idle (no other simulator booted, no build or test running): at least 5 cold launches (app terminated first, launched with `xcrun simctl launch` and no debugger, not counting the first launch after install), each timed to the calculator's first frame rather than the white launch screen, for example from an `xcrun simctl io <UDID> recordVideo` capture. The PR lists each time and the median. Context: the PM saw 3 of 6 cold launches still on the white launch screen after 5–9 s while the Mac ran 5 simulators and 2 test runs. If any idle launch takes over 2 s, investigate (launch logs, Instruments) and record the cause in the PR; an app-side cause becomes a new V2 Bug Fixes task
- [ ] **2A-16** ViewModel: split status, lowest invalid row, and Clear amounts (~1.5h) · deps: 2A-6
  - AC: `allocationStatus` follows spec §3.2 top to bottom (first match wins), in minor units: S1a `.billMissing` (bill text empty or 0); S1b `.billUnreadable` (non-empty bill text that `AmountParser` rejects, over-cap included); S2 `.invalidRow(personNumber)` for the lowest-numbered typed row it rejects; S3 `.over(excess)` (the typed rows add up to more than the bill); S4 `.under(remaining)` (no automatic rows, and the typed rows add up to less); S5 `.balanced`. It's rechecked on every change
  - AC: the original examples still hold (none has an empty row): bill "20" with rows "12,50" + "7.50" → `.balanced`; "12,50" + "7" → `.under(50)`; "15" + "7.50" → `.over(250)`
  - AC: one test per state and per precedence step: bill "" and "0" → S1a; a pasted "1 234,50" → S1b, which wins over an invalid row; rows "5", "1,2,3", "abc" → `.invalidRow(2)`, which wins over S3; any automatic row with typed rows ≤ the bill → `.balanced` (bill "1250", 4 people, Person 1 "150")
  - AC: `hasTypedRows` drives "Clear amounts" (§4.3), and `clearTypedAmounts()` empties every `amountText`, so every row is automatic again and a readable bill above 0 gives `.balanced` (E14)
  - AC ([2A-3 N4b]) `clearTypedAmounts()` empties each `amountText` in place and never rebuilds rows, so every row keeps its `id` and focus is unchanged (spec §4.3). Rebuilt rows would get new UUIDs, and 2A-11's E7 clean-up would drop focus. A test checks that the ids are the same before and after
- [ ] **2A-17** `SplitStatusView` (~1.5h) · deps: 2A-15, 2A-16, 2A-18
  - AC: `Views/Components/SplitStatusView.swift` per spec §4.6, with `.pinned` and `.inline` styles: the §3.2 icon and icon color for S1a–S5, and the sentence in `bbPrimaryText`; no ViewModel dependency and no arithmetic in the view
  - AC: its display state (icon, color, and the §4.9 sentence, with amounts from `CurrencyFormatter.format(amount:currency:)`) is built from 2A-16's `allocationStatus` and the bill in one unit-tested place, which 2A-11 and 2A-13 both use. All six sentences are tested, for example NOK `.over(250)` → "2,50 kr over the bill", `.under(5_000)` → "50,00 kr left to assign", `.invalidRow(3)` → "Check Person 3's amount", and `.balanced` with the bill at 125_000 → "Adds up to 1 250,00 kr"
  - AC: `.pinned` is capped at `.accessibility1` with `.lineLimit(2)` (1 when `verticalSizeClass == .compact`), shows the full sentence in the Large Content Viewer, and is one VoiceOver element labeled "Split status" with the sentence as its value; `.inline` scales to AX5 with unlimited lines and adds §4.6's caption for S2–S4 only
  - AC: the sentence uses `.contentTransition(.numericText())` with the spring and the icon crossfades; under Reduce Motion, the sentence uses `.opacity` with no spring and the icon swaps instantly; tokens only
  - AC: `#Preview`s: S1a, S1b, and S2–S5 in light and dark, plus S4 at `.accessibility5` in both styles
  - Split out of 2A-11 (2026-09-25): the spec's pinned card, Clear amounts, and announcements made 2A-11 about 4h. 2A-13 reuses this component, so it no longer waits for the whole custom list
- [ ] **2A-18** Land the five 2A design tokens (~1h) · deps: — · ‖
  - AC: `AppColors.bbWarning` and `.bbTealText` (adaptive light/dark), `AppTypography.amountField` and `.amountMinimumScale`, and `AppSpacing.minTapTarget`, with exactly the values in spec §5
  - AC: STYLE-GUIDE.md: the five rows lose "(proposed)", the "waiting for design-review approval" note goes, and the "`bbPrimaryText` for all amounts" rule gets an exception: automatic previews (input previews) use `bbSecondaryText` (N14)
  - AC: AccentColor gets a light appearance of `#00695C` and keeps `#00E5CC` for dark (spec §5 developer note); nothing changes at runtime, because the app forces dark mode
  - AC: 0 warnings, and all tests pass; nothing uses the tokens yet (2A-9, 2A-10, and 2A-17 will); code review plus design review Mode B (it touches `DesignSystem/`)
  - Why a task of its own: spec §5 lands the tokens with 2A-9, but 2A-10 can start first, because 2A-9 waits on 2A-6. This finalizes them once, before every UI task that uses them

#### Backlog

- Rejected bill input (for example a pasted "1 234,50") silently computes as 0, with no feedback in the bill field. Consider reusing 2A-10's invalid-input state for `BillInputView`. The spec's S1b status covers it in Custom mode only (spec §7); over-cap input (2A-5) behaves the same way.
- `MARKETING_VERSION` is 1.0 in the project while CHANGELOG is at 2.0.0 (release hygiene). Decide before tagging the 2.0.1 hotfix (Q8).
- [2A-1 N1] The tests read the app's real saved preferences. After manual use leaves Per Person ↑ selected, `splitByTwo` and `splitByThree` fail (59/61), because they never set `selectedRounding`. 2A-2 should pre-seed every non-default rounding mode (1, 2, 3), not only 2. Until then, run tests on a simulator with clean app data (the hotfix validation included).
- [2A-1 N2] Under the any-region rule, a pasted US-grouped `"1,234"` parses as 1.234, a silent 1000× under-read. The decimal pad can't type it, so it takes a paste or a hardware keyboard. Consider rejecting more than 2 fraction digits after "," for 2-decimal currencies.
- [2A-1 N3] The scale path in `AmountParser.minorUnits` is untested, because every currency uses 2. Add an internal `minorUnits(from:fractionDigits:)` seam and test it at 0 and 3 (`",5"`@0 → 1, `"1,0005"`@3 → 1001).
- [2A-1 N4] TESTING.md still says 39 tests (61 now) and has no AmountParser section. Its manual QA lacks a "type 12,50 with Region = Norway" step, which should be checked before tagging 2.0.1 (the rest is covered by 2A-14). CLAUDE.md also says 39 (human-owned).
- [2A-1 N6] `AmountParser` is stateless, so it could be `nonisolated` if a caller off the main actor ever appears.
- [2A-4 N2] Add `#expect(shares == shares.sorted(by: >))` to the 140-case equal-weights test. It pins the lowest-index leftover rule that the automatic rows rely on for every n and total.
- [2A-4 N3] `roundsUp` assumes 2 decimals for every currency. Filter on `fractionDigits == 2`, so a JPY/0-decimal currency in 2B doesn't break the test.
- [2A-4 N4] Add an ARCHITECTURE.md decision row: exact splits in Int minor units, largest remainder, ties to the lowest index, full-width products, no `Double` (2A-14 can take it).
- [spec §7] Pre-existing tap targets: tip chips and rounding pills are about 36–38 pt tall, under the 44 pt minimum (`minTapTarget` lands in 2A-18). Tip chips also have a `.clear` fill without `contentShape`, so their hit area is roughly the text line.
- [spec §7] The split stepper's VoiceOver says "1 people"; it needs a singular/plural form.
- [2A-15 review] Currency symbol mismatch: the KES bill field shows "KSh" (`Currency.symbol`), while the results card shows "Ksh" (CLDR en_KE). Pick one.
- [2A-15 review] The bill placeholder reads "0.00" even when the decimal pad types "," (Norwegian region). Localize it.
- [2A-15 review] CHANGELOG's 2A-15 entry ends with a verification sentence that belongs in a PR body, not release notes. Trim it in 2A-14.
- [2A-15 review] TESTING.md (2A-14): Xcode 26.2 refuses every iOS simulator destination, 17.5 included, and actool fails, unless an iOS 26.x runtime is installed. The iOS 26.3.1 runtime (both variants) can't render emoji, so check flags on iOS 17.5.
- [2A-3 review] Spec question: a pasted `" 5 "` (spaces around a number) is a typed row, because it isn't empty after trimming, but `AmountParser` rejects whitespace, so the row shows "Invalid amount" (S2). That follows spec §3.1 as written, and only paste or a hardware keyboard can enter the spaces. Parsing the trimmed text instead would be a spec change; decide it together with the rejected-bill-input item above.

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
