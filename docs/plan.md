# BillBuddy — Project Plan

> Single source of truth for the BillBuddy tip-calculator app.

- **Display name:** BillBuddy
- **Xcode project:** `billBudy`
- **Bundle ID:** `com.hurud.billBudy`
- **Language:** Swift 5.9+
- **UI framework:** SwiftUI
- **Minimum target:** iOS 17+
- **External dependencies:** None — Apple frameworks only
- **Milestones:** V1 (MVP) → V2 (Power Features) → V3 (Platform Expansion)

---

## Documentation

| Document | Description |
|----------|-------------|
| [README.md](../README.md) | Project overview, setup instructions, tech stack |
| [ARCHITECTURE.md](ARCHITECTURE.md) | MVVM architecture, folder structure, ViewModel design, view hierarchy |
| [STYLE-GUIDE.md](STYLE-GUIDE.md) | Design tokens — colors, typography, spacing, haptics, animations |
| [TASKS.md](TASKS.md) | Development to-do list by milestone |
| [TESTING.md](TESTING.md) | Test strategy, coverage goals, QA checklists |
| [CHANGELOG.md](CHANGELOG.md) | Version history (Keep a Changelog format) |
| [CLAUDE.md](../CLAUDE.md) | Claude Code guidance — conventions, build commands |

---

## V1 — Feature Specs (MVP)

### Tip Calculator

- Bill amount input with **decimal pad** keyboard
- **6 preset buttons:** 0%, 5%, 10%, 15%, 20%, 25%
- **Custom slider:** 0–50% in 1% steps (shown when "Custom" preset selected)
- **Real-time computation:** tip amount and total update on every input change

### Bill Splitting

- **Stepper:** 1–20 people
- **Equal split only** (V1 scope)
- Per-person amount displayed when split > 1

### Currency Display

| Currency | Locale  | Symbol | Flag |
|----------|---------|--------|------|
| NOK      | `nb_NO` | `kr`   | 🇳🇴  |
| USD      | `en_US` | `$`    | 🇺🇸  |
| KES      | `en_KE` | `KSh`  | 🇰🇪  |

Display formatting only — no live conversion in V1.

### Dark-Mode-First UI

- Teal accent: `#00E5CC`
- Elevated card surfaces with subtle translucency
- High-contrast text on dark backgrounds
- Light mode functional but dark mode is the primary design target

### Haptic Feedback

| Interaction              | Haptic Style         |
|--------------------------|----------------------|
| Tip preset selection     | Light impact         |
| Split count change       | Medium impact        |
| First calculation result | Success notification |

### Spring Animations

- Value changes: `.spring(response: 0.4, dampingFraction: 0.7)`
- Card entrances: staggered with incremental delay

### Persistence (`@AppStorage`)

| Key              | Persisted? |
|------------------|------------|
| Currency         | Yes        |
| Tip preset       | Yes        |
| Custom tip %     | Yes        |
| Split count      | Yes        |
| Bill amount      | **No**     |

---

## V2 — Power Features

- **Dark-mode UI** — full dark-mode color scheme with adaptive colors, elevated surfaces, and teal accent visibility
- **Unequal splits** — assign custom amounts/percentages per person
- **Live currency conversion** — API-backed real-time rates
- **VisionKit receipt scanner** — OCR to extract bill total from photos
- **SwiftData bill history** — saved calculations with search/filter
- **Rounding options** — round tip, total, or per-person to nearest unit
- **WidgetKit home screen widget** — quick-access recent calculation

---

## V3 — Platform Expansion

- **Payment links** — Vipps (Norway), M-Pesa (Kenya), WhatsApp share
- **Region-aware tip suggestions** — Norway 0–10%, USA 15–25%, Kenya 5–15%
- **Multi-language** — EN, NO, SO, SW via String Catalogs
- **AI natural language input** — e.g. "Split 450 kr between 3 people with 10% tip"
- **Apple Watch companion** — quick tip calculation on wrist

---

## Architecture & Design

> Full architecture details (folder structure, decisions, ViewModel design, view hierarchy) are in [ARCHITECTURE.md](ARCHITECTURE.md).
>
> Full design tokens (colors, typography, spacing, haptics, animations) are in [STYLE-GUIDE.md](STYLE-GUIDE.md).

---

## Development Timeline

Solo developer, estimated ~21 hours over 3–4 days.

| Phase | Tasks | Est. |
|-------|-------|------|
| **Day 1: Foundation** | Folder scaffolding, Models (`TipPreset`, `Currency`, `TipCalculation`), DesignSystem (`AppColors`, `AppTypography`, `AppSpacing`), Services (`HapticManager`, `CurrencyFormatter`), Extensions | ~5h |
| **Day 2–3: Core UI** | `CalculatorViewModel`, all Views (`CalculatorView`, `BillInputView`, `TipSelectorView`, `TipPresetButton`, `SplitControlView`, `ResultsCardView`, `BreakdownRow`, `CurrencyPickerView`, `GlassCard`), screen composition | ~9h |
| **Day 3–4: Polish** | Spring animations, haptic integration, `@AppStorage` persistence, dark/light mode QA, edge cases (zero bill, max split), SwiftUI Previews for all views | ~7h |

---

## Success Metrics

- [ ] Launches without crashes on iOS 17+ simulator and device
- [ ] All 6 presets + custom slider calculate correct tip and total
- [ ] Split 1–20 produces correct per-person amounts
- [ ] NOK/USD/KES display with correct locale symbols and decimal separators
- [ ] Dark mode polished, light mode functional
- [ ] Haptics fire on all specified interactions
- [ ] Preferences (currency, tip %, split count) survive app restart
- [ ] All views render correctly in SwiftUI Previews
- [ ] Zero Xcode build warnings
