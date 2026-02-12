# Architecture

BillBuddy uses **MVVM (Model–View–ViewModel)** with Swift's `@Observable` macro, introduced in iOS 17. This gives us fine-grained property-level tracking without the boilerplate of `ObservableObject` + `@Published`, while keeping all business logic testable and separate from views.

---

## Folder Structure

```
billBudy/
├── billBudyApp.swift                    # @main entry point, WindowGroup scene
├── ContentView.swift                    # Root view
├── Models/
│   ├── TipPreset.swift                  # Enum: zero/five/ten/fifteen/twenty/twentyFive/custom
│   ├── Currency.swift                   # Enum: nok/usd/kes with symbol, flag, locale
│   └── TipCalculation.swift             # Struct: computed result snapshot
├── ViewModels/
│   └── CalculatorViewModel.swift        # @Observable, all business logic
├── Views/
│   ├── Calculator/
│   │   ├── CalculatorView.swift         # Main screen composition (ScrollView)
│   │   ├── BillInputView.swift          # Currency-prefixed decimal text field
│   │   ├── TipSelectorView.swift        # Preset grid + custom slider
│   │   ├── TipPresetButton.swift        # Reusable selected/unselected chip
│   │   └── SplitControlView.swift       # +/- stepper for people count
│   ├── Results/
│   │   ├── ResultsCardView.swift        # Tip/total/per-person card
│   │   └── BreakdownRow.swift           # Label-value display row
│   └── Components/
│       ├── CurrencyPickerView.swift     # Segmented NOK | USD | KES
│       └── GlassCard.swift              # Reusable elevated card container
├── Services/
│   ├── HapticManager.swift              # enum namespace, wraps UIImpactFeedbackGenerator
│   └── CurrencyFormatter.swift          # enum namespace, cached NumberFormatters per locale
├── DesignSystem/
│   ├── AppColors.swift                  # Color tokens (bbTeal, bbCardBackground, etc.)
│   ├── AppTypography.swift              # Font presets (largeTitle, title, headline, etc.)
│   └── AppSpacing.swift                 # Spacing scale (xs–xxl) + corner radii
├── Extensions/
│   └── Double+CurrencyFormatted.swift   # .formatted(as:) helper
└── Assets.xcassets/
    └── AccentColor.colorset/            # Teal #00E5CC
```

---

## Key Architecture Decisions

| Decision | Rationale |
|----------|-----------|
| `@Observable` over `ObservableObject` | Fine-grained property tracking without `@Published` boilerplate; iOS 17+ idiomatic |
| Single `CalculatorViewModel` for V1 | All state lives on one screen — tip input, split count, currency, and results are tightly coupled |
| `@Environment` injection | ViewModel created with `@State` at the App level, distributed to child views via `.environment()` |
| `@ObservationIgnored` on `@AppStorage` | `@AppStorage` doesn't compose with `@Observable`; bridged manually in `init()` + `savePreferences()` |
| `enum` namespaces for stateless services | `HapticManager` and `CurrencyFormatter` are pure utility — enum prevents accidental instantiation |
| Cached `NumberFormatter` instances | `NumberFormatter` is expensive to create; one instance per locale is reused |

---

## Data Flow

```
User Input → ViewModel (stored properties) → Computed Properties → View (reads & displays)
    │                                                                        │
    └── Tap / type / slide ─────────────────────────────────────────────────┘
```

1. **User acts** — types a bill amount, taps a tip preset, adjusts the slider, or changes the split count
2. **ViewModel updates** — the corresponding stored property changes (`billAmountText`, `selectedPreset`, `customTipPercent`, `splitCount`, `selectedCurrency`)
3. **Computed properties refire** — `@Observable` tracks which properties each view reads; only affected views re-render
4. **Views display** — `tipAmount`, `totalAmount`, and `perPersonAmount` are shown via `CurrencyFormatter`
5. **Persistence** — on relevant changes, `savePreferences()` writes to `@AppStorage` (currency, tip preset, split count, custom tip %)

---

## CalculatorViewModel — Core Design

### Input Properties

| Property            | Type          | Default        |
|---------------------|---------------|----------------|
| `billAmountText`    | `String`      | `""`           |
| `selectedPreset`    | `TipPreset`   | `.fifteen`     |
| `customTipPercent`  | `Double`      | `18.0`         |
| `splitCount`        | `Int`         | `1`            |
| `selectedCurrency`  | `Currency`    | `.nok`         |

### Computed Properties

| Property              | Type              | Derivation |
|-----------------------|-------------------|------------|
| `billAmount`          | `Double`          | Parsed from `billAmountText` (0.0 if invalid) |
| `effectiveTipPercent` | `Double`          | Preset's percentage, or `customTipPercent` if `.custom` |
| `tipAmount`           | `Double`          | `billAmount * effectiveTipPercent / 100` |
| `totalAmount`         | `Double`          | `billAmount + tipAmount` |
| `perPersonAmount`     | `Double`          | `totalAmount / Double(splitCount)` |
| `calculation`         | `TipCalculation`  | Snapshot struct bundling all the above |

### Persistence Bridge

```swift
@ObservationIgnored @AppStorage("savedCurrency")  private var savedCurrency: String = "nok"
@ObservationIgnored @AppStorage("savedTip")        private var savedTip: Int = 3        // TipPreset rawValue
@ObservationIgnored @AppStorage("savedSplit")       private var savedSplit: Int = 1
@ObservationIgnored @AppStorage("savedCustomTip")  private var savedCustomTip: Double = 18.0
```

- **Load:** `init()` reads `@AppStorage` values and sets corresponding `@Observable` properties
- **Save:** `savePreferences()` writes current state back; called on relevant property changes

---

## View Hierarchy

Single `ScrollView` screen — no `NavigationStack` in V1.

```
CalculatorView (ScrollView, .vertical)
│
├── CurrencyPickerView              ← Segmented control at top: NOK | USD | KES
│
├── BillInputView                   ← Large mono text field + currency symbol prefix
│
├── TipSelectorView
│   ├── LazyVGrid (2 columns)
│   │   └── TipPresetButton ×6     ← 0%, 5%, 10%, 15%, 20%, 25%
│   └── Slider 0...50              ← Shown only when .custom is selected
│
├── SplitControlView                ← −/+ buttons with count label, clamped 1–20
│
└── ResultsCardView (GlassCard)
    ├── BreakdownRow                ← Tip amount
    ├── BreakdownRow                ← Total
    └── BreakdownRow                ← Per person (visible only when splitCount > 1)
```

- **CurrencyPickerView** sits at the top so the user sets context before entering a bill
- **BillInputView** is the primary interaction — large type, immediate decimal pad
- **TipSelectorView** presets are in a 2-column grid for easy thumb reach; custom slider appears conditionally
- **SplitControlView** uses custom +/- buttons (not the system Stepper) for styling control
- **ResultsCardView** is always visible at the bottom, updating in real time as inputs change
