# Testing

BillBuddy's test strategy, coverage goals, and QA checklists.

---

## Current State

Unit test target `billBudyTests` is configured with 39 passing tests using the Swift Testing framework. UI test target (`billBudyUITests`) is not yet configured.

---

## Testing Goals (V1)

- **90%+ code coverage** on `CalculatorViewModel` (all business logic)
- **100% preview coverage** — every view file has a working `#Preview` block
- **All edge cases** covered in unit tests
- **Manual QA pass** before each release
- Zero test failures in CI (once configured)

---

## Test Targets to Add

### Unit Test Target: `billBudyTests`

**In Xcode:** File → New → Target → Unit Testing Bundle → name it `billBudyTests`

**What to test:**

#### CalculatorViewModel — Tip Math

| Test Case | Input | Expected |
|-----------|-------|----------|
| 15% tip on $100 | bill: 100, preset: .fifteen | tipAmount: 15.0, total: 115.0 |
| 0% tip | bill: 100, preset: .zero | tipAmount: 0.0, total: 100.0 |
| 25% tip | bill: 200, preset: .twentyFive | tipAmount: 50.0, total: 250.0 |
| Custom 18% tip | bill: 100, preset: .custom, customTip: 18 | tipAmount: 18.0, total: 118.0 |
| Custom 0% tip | bill: 100, preset: .custom, customTip: 0 | tipAmount: 0.0, total: 100.0 |
| Custom 50% tip | bill: 100, preset: .custom, customTip: 50 | tipAmount: 50.0, total: 150.0 |

#### CalculatorViewModel — Split Math

| Test Case | Input | Expected |
|-----------|-------|----------|
| No split (1 person) | total: 115, split: 1 | perPerson: 115.0 |
| Split by 2 | total: 115, split: 2 | perPerson: 57.5 |
| Split by 3 (repeating decimal) | total: 100, split: 3 | perPerson: 33.33... |
| Split by 20 (max) | total: 100, split: 20 | perPerson: 5.0 |

#### CalculatorViewModel — Edge Cases

| Test Case | Input | Expected |
|-----------|-------|----------|
| Empty bill amount | billAmountText: "" | billAmount: 0.0, all results: 0.0 |
| Zero bill | billAmountText: "0" | tipAmount: 0.0, total: 0.0 |
| Invalid input | billAmountText: "abc" | billAmount: 0.0 |
| Very large bill | billAmountText: "999999.99" | Correct calculation, no overflow |
| Decimal input | billAmountText: "42.50" | billAmount: 42.5 |

#### CurrencyFormatter

| Test Case | Input | Expected Pattern |
|-----------|-------|------------------|
| NOK formatting | 1234.5, .nok | Uses `nb_NO` locale, `kr` symbol |
| USD formatting | 1234.5, .usd | Uses `en_US` locale, `$` symbol |
| KES formatting | 1234.5, .kes | Uses `en_KE` locale, `KSh` symbol |
| Zero amount | 0.0, .usd | Formatted zero (e.g. "$0.00") |
| Large amount | 1000000.0, .nok | Correct grouping separators |

#### Models

| Test Case | Expected |
|-----------|----------|
| TipPreset.fifteen.percentage | 15.0 |
| TipPreset.zero.percentage | 0.0 |
| Currency.nok.symbol | "kr" |
| Currency.nok.locale | "nb_NO" |
| All TipPreset cases exist | 7 cases total |
| All Currency cases exist | 3 cases total |

### UI Test Target: `billBudyUITests`

**In Xcode:** File → New → Target → UI Testing Bundle → name it `billBudyUITests`

**What to test:**

| Test Case | Steps | Expected |
|-----------|-------|----------|
| Basic flow | Enter "100" → tap 15% → verify result | Tip: 15, Total: 115 displayed |
| Currency switch | Tap USD → enter "50" → tap NOK → verify | Amount reformatted with `kr` symbol |
| Split stepper | Enter "100" → 15% → tap + to 2 people | Per-person shows ~57.50 |
| Stepper bounds (min) | Tap − when split is 1 | Count stays at 1 |
| Stepper bounds (max) | Tap + until split is 20, tap + again | Count stays at 20 |
| Custom slider | Tap Custom preset → slide to 30% | Tip updates to 30% of bill |

---

## Preview Tests

Every view file must include a `#Preview` block that renders without crashes.

| View | Preview Requirements |
|------|---------------------|
| `CalculatorView` | Full screen with sample ViewModel |
| `BillInputView` | With and without entered amount |
| `TipSelectorView` | With a preset selected, and with custom selected |
| `TipPresetButton` | Selected state and unselected state |
| `SplitControlView` | Count at 1, count at mid-range, count at 20 |
| `ResultsCardView` | With 1 person (no per-person row), with multiple people |
| `BreakdownRow` | With sample label and formatted value |
| `CurrencyPickerView` | All three currencies |
| `GlassCard` | With sample content |

---

## Manual QA Checklist

Run through this checklist before each release.

### Functionality

- [ ] Enter bill amount → tip and total update in real time
- [ ] All 6 presets produce correct tip amounts
- [ ] Custom slider (0–50%) works in 1% steps
- [ ] Split 1–20 produces correct per-person amounts
- [ ] Per-person row hidden when split is 1
- [ ] Currency picker switches formatting for NOK, USD, KES
- [ ] Decimal separators correct for each locale (comma for NOK, period for USD/KES)

### Persistence

- [ ] Set currency to USD → kill app → reopen → USD is still selected
- [ ] Set tip to 20% → kill app → reopen → 20% is selected
- [ ] Set split to 4 → kill app → reopen → split is 4
- [ ] Bill amount is NOT persisted (starts empty on reopen)

### Haptics

- [ ] Light haptic on tip preset tap (test on physical device)
- [ ] Medium haptic on split +/- tap
- [ ] Success haptic on first calculation result

### Visual

- [ ] Dark mode: all text readable, cards elevated, teal accent visible
- [ ] Light mode: all text readable, no invisible elements
- [ ] No layout clipping on iPhone SE (smallest screen)
- [ ] No excessive whitespace on iPhone 15 Pro Max (largest screen)
- [ ] Keyboard dismisses properly after bill input

### Animations

- [ ] Tip/total values animate smoothly on change
- [ ] Result card rows stagger in on first appearance
- [ ] Chip selection transitions feel responsive

---

## How to Run Tests

### Command Line

```bash
# Unit tests
xcodebuild test \
  -project billBudy.xcodeproj \
  -scheme billBudy \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:billBudyTests

# UI tests
xcodebuild test \
  -project billBudy.xcodeproj \
  -scheme billBudy \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:billBudyUITests

# All tests
xcodebuild test \
  -project billBudy.xcodeproj \
  -scheme billBudy \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

### Xcode

`Cmd + U` to run all tests, or click the diamond icon next to individual test methods.

---

## Edge Cases to Always Cover

These are the inputs most likely to cause bugs — ensure they're tested in both unit and manual QA:

| Edge Case | Why It Matters |
|-----------|---------------|
| Empty string input | `Double("")` returns nil — must default to 0.0 |
| Bill amount "0" | Division and tip math must handle zero gracefully |
| Bill amount "0.00" | Same as zero but entered differently |
| Split count 1 | Per-person should equal total; row may be hidden |
| Split count 20 | Maximum bound; stepper must not exceed |
| Custom tip 0% | Same as "No Tip" preset — results should match |
| Custom tip 50% | Maximum slider value |
| Rapid typing | ViewModel must not lag or produce intermediate glitches |
| Currency switch mid-calculation | Amounts must reformat immediately, values unchanged |
| Locale with comma decimals (NOK) | `NumberFormatter` must use correct separator |
