# Style Guide

BillBuddy's visual design system. All values are defined in the `DesignSystem/` folder and must be used through their tokens — never use raw colors, fonts, or spacing values directly.

---

## Design Principles

- **Dark-mode-first** — dark mode is the primary design target; light mode must be functional but dark mode gets the polish
- **Teal accent** — `#00E5CC` is the brand color, used sparingly for selections, accents, and interactive elements
- **Elevated surfaces** — cards float above the background with subtle shadows and translucency
- **High contrast** — text is always readable; primary text on dark backgrounds, secondary for labels
- **Rounded design** — all fonts use `.rounded` design; cards and chips use generous corner radii

---

## Colors — `AppColors`

Defined in `DesignSystem/AppColors.swift`. Access via `AppColors.bbTeal`, `AppColors.bbCardBackground`, etc.

All adaptive colors use `Color(UIColor { traits in ... })` with explicit dark/light variants.

| Token               | Light Mode                    | Dark Mode                      | Usage |
|----------------------|-------------------------------|--------------------------------|-------|
| `bbTeal`             | `#00E5CC`                     | `#00E5CC`                      | Accent color — selected states, borders, highlights |
| `bbBackground`       | `#F2F2F7`                     | `#0A0A0F`                      | Screen background (warm off-white / deep dark) |
| `bbCardBackground`   | `#FFFFFF`                     | `#1C1C1E`                      | Card and surface fills (white / elevated dark) |
| `bbPrimaryText`      | `.primary`                    | `.primary`                     | Main text — amounts, labels, headings |
| `bbSecondaryText`    | `.secondary`                  | `.secondary`                   | Supporting text — descriptions, captions |
| `bbSelectedChip`     | `bbTeal` @ 10% opacity        | `bbTeal` @ 15% opacity         | Background fill for selected tip preset chips |
| `bbSelectedBorder`   | `bbTeal`                      | `bbTeal`                       | Border for selected tip preset chips |
| `bbUnselectedBorder` | `systemGray4` (`#D1D1D6`)     | `systemGray3` (`#3A3A3C`)      | Border for unselected tip preset chips |
| `bbCardBorder`       | `black` @ 4% opacity          | `white` @ 8% opacity           | Subtle glass-edge border on cards |
| `bbCardShadow`       | `black` @ 8% opacity          | `black` @ 40% opacity          | Card shadow (soft light / deep dark elevation) |
| `bbWarning`          | `#C93400`                     | `#FF9F0A`                      | Problem states only, always paired with an icon and words: split-status icons (bill unreadable, invalid row, over, left) and the invalid-amount field border, icon, and caption. Source: `docs/design/2A-unequal-splits.md` §5 |
| `bbTealText`         | `#00695C`                     | `#00E5CC` (= `bbTeal`)         | Teal *text and glyphs*: the selected split-mode chip's label and checkmark, and the "Clear amounts" button. `bbTeal` text is 1.4:1 on light surfaces. Source: `docs/design/2A-unequal-splits.md` §5 |

### Color Usage Rules

- **Never** use raw hex values, `Color.blue`, or `Color(.systemGray5)` directly in views
- **Always** reference `AppColors` tokens
- `bbTeal` is for interactive and selected states only — don't use it for large fills
- Use `bbPrimaryText` for all amounts and headings, `bbSecondaryText` for labels and descriptions
  - **Exception:** automatic previews (input previews) use `bbSecondaryText`. An automatic `PersonSplitRow` (no typed amount) previews its share this way, so it reads as a suggestion, not a typed value. Typed amounts stay `bbPrimaryText`. Source: `docs/design/2A-unequal-splits.md` §4.5

---

## Typography — `AppTypography`

Defined in `DesignSystem/AppTypography.swift`. All fonts use the `.rounded` design variant.

| Token         | Font Definition                                              | Usage |
|---------------|--------------------------------------------------------------|-------|
| `.largeTitle` | `.system(.largeTitle, design: .rounded, weight: .bold)`      | Bill amount display |
| `.title`      | `.system(.title2, design: .rounded, weight: .semibold)`      | Section headings, result values |
| `.headline`   | `.system(.headline, design: .rounded, weight: .medium)`      | Card titles, stepper labels |
| `.body`       | `.system(.body, design: .rounded)`                           | General text, descriptions |
| `.caption`    | `.system(.caption, design: .rounded)`                        | Fine print, secondary labels |
| `.mono`       | `.system(.title, design: .monospaced, weight: .bold)`        | Currency amounts in results (tabular alignment) |
| `.amountField` | `.system(.headline, design: .rounded, weight: .medium).monospacedDigit()` | Typed and automatic amounts in `PersonSplitRow` |
| `.amountMinimumScale` | `0.5` (`CGFloat`, used with `.minimumScaleFactor`) | One-line amounts that must shrink instead of wrapping: `PersonSplitRow` automatic amounts and `BreakdownRow` values |

### Typography Usage Rules

- **Never** use `.font(.title)` or `.font(.system(size: 24))` directly — use `AppTypography` tokens
- Bill input field uses `.mono` for the entered amount
- Result card amounts use `.mono` for aligned decimal columns
- Section labels use `.headline`
- The currency picker and preset buttons use `.body`

---

## Spacing — `AppSpacing`

Defined in `DesignSystem/AppSpacing.swift`. A consistent spatial scale used for padding, gaps, and margins.

| Token          | Value (pt) | Usage |
|----------------|------------|-------|
| `xs`           | 4          | Tight internal padding (icon-to-text gaps) |
| `sm`           | 8          | Chip internal padding, small gaps between elements |
| `md`           | 16         | Standard section padding, card internal padding |
| `lg`           | 24         | Spacing between sections |
| `xl`           | 32         | Large section gaps |
| `xxl`          | 48         | Top/bottom screen margins |
| `cornerRadius` | 16         | Buttons, chips, small cards |
| `cardRadius`   | 20         | Main result card, GlassCard containers |
| `minTapTarget` | 44         | Minimum width and height of every tap target (HIG default). Apply it as `minWidth`/`minHeight` so targets grow with Dynamic Type |

### Spacing Usage Rules

- **Never** use raw numbers for padding or spacing — use `AppSpacing` tokens
- Card internal padding: `md` (16pt)
- Space between sections in ScrollView: `lg` (24pt)
- Screen horizontal padding: `md` (16pt)
- Chip corner radius: `cornerRadius` (16pt)
- Result card corner radius: `cardRadius` (20pt)

---

## Haptic Feedback

All haptics go through `Services/HapticManager.swift` — never use `UIImpactFeedbackGenerator` directly.

| Interaction              | Method                      | Haptic Style         |
|--------------------------|-----------------------------|----------------------|
| Tip preset selection     | `HapticManager.lightImpact()`  | Light impact         |
| Split count change (+/-) | `HapticManager.mediumImpact()` | Medium impact        |
| First calculation result | `HapticManager.success()`      | Success notification |

### Haptic Rules

- Fire haptics **before** the visual update for perceived responsiveness
- Only trigger success haptic on the **first** result after app launch or bill amount entry — not on every change
- Use the `View+HapticFeedback` extension for declarative haptic attachment

---

## Animations

### Value Change Animation

```swift
.spring(response: 0.4, dampingFraction: 0.7)
```

Applied to:
- Tip amount, total, and per-person amount when values change
- Slider thumb position
- Chip selection state transitions

### Staggered Card Entrance

Result card rows animate in with incremental delay:

```swift
.offset(y: isVisible ? 0 : 20)
.opacity(isVisible ? 1 : 0)
.animation(.spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05), value: isVisible)
```

### Animation Rules

- **Always** use the spring config above — don't use `.default` or `.easeInOut` for value animations
- Stagger delay: `0.05s` per row index
- Use `withAnimation` sparingly — prefer `.animation()` modifier tied to specific values
- Keep animations subtle — they should feel responsive, not distracting

---

## Component Styling

### GlassCard

- Background: `AppColors.bbCardBackground` (white in light, `#1C1C1E` in dark)
- Corner radius: `AppSpacing.cardRadius` (20pt)
- Internal padding: `AppSpacing.md` (16pt)
- Border: 1pt `AppColors.bbCardBorder` (subtle glass edge — white @ 8% in dark, black @ 4% in light)
- Shadow: `AppColors.bbCardShadow`, radius 10, y-offset 5 (deeper in dark mode for elevation)
- Used for: results card, and potentially future card surfaces

### TipPresetButton States

| State      | Background             | Border                     | Text Color              |
|------------|------------------------|----------------------------|-------------------------|
| Unselected | `.clear`               | `AppColors.bbUnselectedBorder` | `AppColors.bbPrimaryText` |
| Selected   | `AppColors.bbSelectedChip` | `AppColors.bbSelectedBorder`   | `AppColors.bbTeal`        |

- Corner radius: `AppSpacing.cornerRadius` (16pt)
- Transition between states uses spring animation
- Border width: 1.5pt

### CurrencyPickerView

- Segmented style with flag emoji + currency code (e.g. "🇳🇴 NOK")
- Uses system `.segmented` picker style
- Teal tint for selected segment
