# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

BillBuddy (Xcode project name: `billBudy`) is a native iOS tip-calculator app built with SwiftUI, targeting iOS 17+. Swift 5.9+, MVVM architecture with `@Observable`, zero external dependencies — Apple frameworks only. Bundle ID: `com.hurud.billBudy`.

## Build

```bash
xcodebuild -project billBudy.xcodeproj -scheme billBudy -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Test

```bash
# Run all unit tests (39 tests)
xcodebuild test -project billBudy.xcodeproj -scheme billBudy -destination 'platform=iOS Simulator,name=iPhone 16'

# Run only CalculatorViewModel tests
xcodebuild test -project billBudy.xcodeproj -scheme billBudy -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:billBudyTests/CalculatorViewModelTests

# Run only CurrencyFormatter tests
xcodebuild test -project billBudy.xcodeproj -scheme billBudy -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:billBudyTests/CurrencyFormatterTests
```

Test target: `billBudyTests` (unit testing bundle, hosted by `billBudy.app`). Uses Swift Testing framework (`@Suite`, `@Test`, `#expect`). See `docs/TESTING.md` for full test strategy and coverage goals.

## Documentation

All documentation lives in the `docs/` folder (except this file).

| Document | Description |
|----------|-------------|
| `README.md` | Project overview, setup instructions, tech stack (root) |
| `docs/plan.md` | Feature specs and roadmap (V1/V2/V3), timeline, success metrics |
| `docs/ARCHITECTURE.md` | MVVM architecture, folder structure, ViewModel design, view hierarchy, data flow |
| `docs/STYLE-GUIDE.md` | Design tokens — colors, typography, spacing, haptics, animations |
| `docs/TASKS.md` | Development to-do list by milestone |
| `docs/TESTING.md` | Test strategy, what to test, how to run, coverage goals |
| `docs/CHANGELOG.md` | Version history (Keep a Changelog format) |

## Architecture

Two-target Xcode project using file-system-synchronized groups (source files auto-discovered). Info.plist is auto-generated. MVVM pattern with a single `CalculatorViewModel` for V1.

**ViewModel injection:** Created with `@State` at the App level, distributed to child views via `.environment()`.

See `docs/ARCHITECTURE.md` for full folder structure, architecture decisions, ViewModel property design, and view hierarchy.

### Folder Structure

```
billBudy/
├── billBudyApp.swift          # @main entry point
├── ContentView.swift          # Root view
├── Models/                    # TipPreset, Currency, TipCalculation
├── ViewModels/                # CalculatorViewModel (@Observable)
├── Views/
│   ├── Calculator/            # Main screen views
│   ├── Results/               # Result card and breakdown rows
│   └── Components/            # Reusable components (CurrencyPicker, GlassCard)
├── Services/                  # HapticManager, CurrencyFormatter (enum namespaces)
├── DesignSystem/              # AppColors, AppTypography, AppSpacing
├── Extensions/                # Double+CurrencyFormatted
└── Assets.xcassets/           # Asset catalog (AccentColor #00E5CC)

billBudyTests/
├── CalculatorViewModelTests.swift  # Tip math, split math, edge cases, model tests
└── CurrencyFormatterTests.swift    # NOK/USD/KES formatting tests
```

## Conventions

### Design Tokens

Always use the design system — never use raw color, font, or spacing values. See `docs/STYLE-GUIDE.md` for full token tables and usage rules.

- **Colors:** `AppColors.bbTeal`, `.bbCardBackground`, `.bbPrimaryText`, etc.
- **Typography:** `AppTypography.largeTitle`, `.title`, `.headline`, `.body`, `.caption`, `.mono`
- **Spacing:** `AppSpacing.xs` (4), `.sm` (8), `.md` (16), `.lg` (24), `.xl` (32), `.xxl` (48)
- **Corner radii:** `AppSpacing.cornerRadius` (16), `.cardRadius` (20)

### Naming Patterns

- Views: `SomethingView` (e.g. `BillInputView`, `ResultsCardView`)
- ViewModels: `SomethingViewModel` (e.g. `CalculatorViewModel`)
- Extensions: `Type+Capability` (e.g. `View+HapticFeedback`, `Double+CurrencyFormatted`)
- Models: plain nouns (e.g. `TipPreset`, `Currency`, `TipCalculation`)

### Swift Style Rules

- Use `@Observable` — **not** `ObservableObject`/`@Published`
- Use `enum` for stateless utility types (`HapticManager`, `CurrencyFormatter`) — prevents accidental instantiation
- Mark classes `final` unless designed for inheritance
- Include `#Preview` blocks in every view file
- Format currency through `CurrencyFormatter` — never construct `NumberFormatter` inline
- Trigger haptics through `HapticManager` — never use `UIImpactFeedbackGenerator` directly
- Use `@ObservationIgnored` on any `@AppStorage` properties inside `@Observable` classes
- Animations: `.spring(response: 0.4, dampingFraction: 0.7)` for value changes

## Roadmap

Full roadmap (V1/V2/V3), development timeline, and success metrics are documented in `docs/plan.md`. Current task progress is tracked in `docs/TASKS.md`.
