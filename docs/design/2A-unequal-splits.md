# 2A: Unequal Splits (design spec)

| | |
|---|---|
| Phase | V2 Phase 2A (Unequal Splits) |
| Tasks covered | 2A-9 `SplitModeToggle` · 2A-10 `PersonSplitRow` · 2A-11 custom list and status · 2A-12 keyboard focus flow · 2A-13 `ResultsCardView` custom breakdown |
| Status | Revised for design-reviewer Mode A, round 2. Round-1 findings and resolutions are in §8 |
| Binding decisions | Q1–Q9 (2026-09-25); automatic rows and the Q6 reading were approved by the human in round 1 (§3.1) |
| Platform | iOS 17.0+, SwiftUI and Apple frameworks only. The app forces dark mode at runtime (`billBudyApp.swift`), so light mode appears only in previews |

---

## 1. Summary

"Split the bill" gets an **Equal / Custom** toggle. In Custom mode, one amount row per person ("Person 1…N") appears. Each row holds that person's part of the bill before tip. A row you type in keeps your amount. A row you leave empty is **automatic**: it previews, and pays, an even share of what the typed rows leave. A status card pinned just above the keyboard always says, in words plus an icon, whether the rows add up to the bill. The results card lists what each person pays (tip and rounding shared in proportion) only while the rows add up. Equal mode keeps today's behavior.

---

## 2. Research

### 2.1 Mobbin references

† = opened and checked by the designer on 2026-09-25. Rows without † come from the research helper's Mobbin search results.

| # | App · screen or flow | Pattern | Verdict | Why, for BillBuddy |
|---|---|---|---|---|
| R1 | [Vipps · Distribute costs, Amount tab](https://mobbin.com/screens/29371741-5017-4565-8630-4f2a93ed380b) † | `Even / Amount / Percentage` switch right above the rows; "Remaining to distribute: 0 SEK" in words; boxed amount fields with a currency label; decimal pad | **Adopt** boxed fields, the remainder in words, and the mode switch directly above the rows. **Reject** Percentage (Q1) | Vipps is Norwegian, so NOK users already know this layout |
| R2 | [Vipps · same screen, unbalanced](https://mobbin.com/screens/123f3436-8185-439d-a9ad-34420d24a98d) | Fields start empty; "Remaining to distribute: 1 SEK"; Save greyed out with no reason | **Adapt** | Keep the remainder in words, but never hide results silently. The card says why per-person amounts are missing |
| R3 | [Vipps · group request error](https://mobbin.com/screens/28b1aab3-26b9-44b3-ac0b-037fc6a21fcf) | Equal breakdown first, then `Change amounts`; full-sentence red banner | **Adapt** "equal first, then edit". **Reject** the banner | A banner is too heavy for a check that updates on every keystroke |
| R4 | [Splitwise · Split options, equal](https://mobbin.com/screens/a3b1b86d-5f8e-4c44-9dca-1a297ecd0591) | Icon-only mode buttons, and a caption that explains the active mode | **Adapt** the caption. **Reject** icon-only modes | Icon-only buttons are ambiguous and weak for VoiceOver |
| R5 | [Splitwise · Split by exact amounts](https://mobbin.com/screens/d3cd7701-4eba-43ab-9dfb-957502d64c95) † | Sticky footer "$20.00 of $20.00 · $0.00 left"; thin underline fields | **Adopt** a status that stays on screen. **Reject** underline fields | Underline fields are small targets. The footer idea becomes our pinned status card |
| R6 | [Splitwise · Editing split options (flow)](https://mobbin.com/flows/c539ec1a-b25e-46d0-bfad-4fbb01d514c2) † | Exact-amount fields start at 0.00, so the footer starts at "$20.00 left" | **Reject** "empty = 0" | It forces typing every person, even when only one differs |
| R7 | [Splitwise · Adding an adjustment (flow)](https://mobbin.com/flows/233d4a6d-72fc-46fe-86d8-8cd795330352) | One line: extras are "distributed according to each person's share of the subtotal" | **Adopt** | Same rule as Q2, stated in one caption |
| R8 | [PayPal · Split $1.00](https://mobbin.com/screens/6d6e8c07-70cf-40ae-b18e-bb9465c04356) † | "We automatically calculated these amounts. You can edit each person's share." Calculated amounts shown in grey | **Adapt** | The basis for automatic rows. We add a caption and a dashed outline so the state isn't signalled by color alone |
| R9 | [Monzo · Split bill](https://mobbin.com/screens/c018c2cd-c757-4e60-8fa4-5d0a51578c11) † | Equal amounts prefilled; a tiny `−` / `+` on each row | **Adapt** the equal start. **Reject** per-row −/+ | Per-row steppers are under 44 pt and slow for money amounts |
| R10 | [Revolut · Split bill](https://mobbin.com/screens/3fc54275-80f7-41c1-83ee-2dbff8296221) | Dark pill tabs `Amount / Percent / Share`; the leftover cent goes to the last person | **Adapt** the dark chip look. **Reject** Percent/Share (Q1), and reject leftovers to the last person | Q4 gives leftover øre to the lowest-numbered people |
| R11 | [KOHO · Custom split](https://mobbin.com/screens/d5d2e965-b89d-4162-8e91-acdd6f941db2) † | Check icon + "The full $0.14 is covered"; outlined fields about 44 pt tall | **Adopt** icon + words for balanced. **Adapt** the color | Our balanced state is neutral in color. Teal stays reserved for interactive and selected states |
| R12 | [Airwallex · Line items, unbalanced](https://mobbin.com/screens/ceb48e76-cc3a-4c2a-bda3-4e8f62ef8294) † and [balanced](https://mobbin.com/screens/8b2befc5-22f7-4fa0-81a8-1a8f6c7ddad6) † | Sticky footer: "Difference −2.50 SGD" with a warning icon; "0.00 SGD" with a check icon | **Adopt** | Shape, words, and color for each state |
| R13 | [GoPay · Split bill arrangement](https://mobbin.com/screens/3dc12200-8c66-489b-a364-5c95d8fd9b47) † | Balanced state in words: "3 of 3 items counted · Full amount counted" | **Adapt** | A words-first balanced message, without the green fill |
| R14 | [Quicken · Split transaction](https://mobbin.com/screens/3b699b56-4cce-4ad6-8c7e-89ef58dbbe84) | Pinned "Left to Split"; one-tap "Add Left to Split" | **Adapt** | We keep the pinned remainder. Automatic rows make the one-tap helper unnecessary |
| R15 | [Public · Allocation](https://mobbin.com/screens/acac4197-0b12-4cf8-96ae-190867bcc1bc) | Long list with a sticky total footer | **Adopt** | Evidence for the 20-person case |
| R16 | [Origin · 20-holding allocation](https://mobbin.com/screens/5f682b47-8347-4818-9145-142cf5f8b118) | 20 rows, each with a field and a slider; `Return to default` | **Reject** per-row sliders. **Adopt** a reset | The reset becomes "Clear amounts" |
| R17 | [Chime · Add expense](https://mobbin.com/screens/1acecac5-0c7b-4079-83c4-a87a8225bf46) † | Boxed amount fields; a "Clear all" chip right under the rows | **Adopt** | The basis for the placement of "Clear amounts" |
| R18 | [Wise · Split bill](https://mobbin.com/screens/2e45a42f-2609-4eb0-adb0-43d9f78bc064) † | Prefilled boxed fields; "Reset" greyed out with no reason | **Adapt** | We hide "Clear amounts" when there's nothing to clear, instead of greying it out |
| R19 | [Greenlight · Allocate allowance](https://mobbin.com/screens/a4683aa6-7257-434f-b7fe-9e84904ef28f) | Teal progress bar + "100% Allocated" | **Reject** | A bar can't show "over" and adds height to the pinned area |
| R20 | [Rocket Money · Split error](https://mobbin.com/screens/b9264ac1-95e7-4590-9aa7-fe7931df4b4a) | Mode hidden in a dropdown; tiny, low-contrast error line | **Reject** | Hidden mode and an unreadable error |
| R21 | [Commons · Splitting a transaction](https://mobbin.com/flows/c48ed1e7-714a-493b-b11e-c3a3d6409da6) | Anonymous head count with big −/+ ("2 ways") | **Adopt** | Our stepper stays the head-count control in both modes (Q3, Q7) |
| R22 | [Yazio · Nutrition facts](https://mobbin.com/screens/8d4da5f3-dcf9-4d31-a452-0331d6b3216d) † | Up/down chevrons on the left of the bar above a decimal pad; the action on the right | **Adopt** | Previous/Next and Done share one keyboard toolbar |
| R23 | [Panera Bread · Add a tip](https://mobbin.com/screens/5f5e727c-aae8-498b-81f3-e5982058d3b7) | A Done bar above a number pad | **Adopt** | A decimal pad has no Return key |
| R24 | [Vivino · Add price](https://mobbin.com/screens/d258d5a8-8375-4abb-bed0-57471a7e6c63) † | A clear (ⓧ) button at the trailing end of the focused price field | **Adopt** | One tap returns a row to automatic |

**What the research decided**

- **Fields.** Boxed fields at least 44 pt tall, with a visible label on every row (R1, R11, R17). No underline fields (R5).
- **Status.** The remainder is always written out, with icon and color as extra cues (R5, R11, R12). It stays on screen, which the 20-person case needs (R5, R14, R15). "Over" is shown, not blocked (R12).
- **Automatic rows.** No shipped app on Mobbin lets untouched rows absorb the remainder. The helper's search and a targeted search both came up empty. The closest pattern is PayPal's grey, automatically calculated amounts (R8). BillBuddy extends that pattern because of the most common unequal case: one or two people differ from an even split. With literal prefilled text, typing the one different amount leaves every other row wrong, so the user has to recalculate and retype them, or the app needs a "split the rest" helper that guesses who absorbs the difference. With automatic rows, that case takes one edit, and untouched rows never go stale when the bill or head count changes. Editing a prefilled field is *not* the cost: the row's ⓧ clears it in one tap, and select-all-on-focus is possible on iOS 17 via `UITextField.textDidBeginEditingNotification` + `selectAll(nil)`.
- **Leftover øre.** No app explains where leftover øre go. Automatic rows show them, for example 100,00 kr ÷ 3 → 33,34 · 33,33 · 33,33.

### 2.2 Apple HIG

| HIG page | Guidance used | Where it applies |
|---|---|---|
| Accessibility › Mobility | iOS default control size **44×44 pt**, minimum 28×28 pt | All new targets are ≥ 44×44 pt and grow with text (`AppSpacing.minTapTarget`, `minWidth`/`minHeight` frames). The system segmented control (about 32 pt tall on iOS 17, not resizable from SwiftUI) is ruled out (§4.4) |
| Accessibility › Vision | 4.5:1 for text up to 17 pt (3:1 for 18 pt+ or bold); an Increase Contrast fallback when the default doesn't meet it; "Convey information with more than color alone… Offer visual indicators, like distinct shapes or icons" | §5 contrast table. Every status is icon + words. Automatic rows add a caption and a dashed outline. The selected chip adds a checkmark |
| Accessibility › Reduce Motion | "reduce automatic and repetitive animations, including zooming, scaling, and peripheral motion" | §4.10 |
| Typography › Dynamic Type | "Make sure your app's layout adapts to all font sizes."; "consider using a stacked layout where text appears above secondary items… Reduce the number of columns when the font size increases"; "Keep text truncation to a minimum as font size increases" | `PersonSplitRow` stacks from `.xxLarge` (§4.5). Amounts stay on one line and scale down instead of wrapping. Only the pinned status card is capped, and it has a full-size fallback (§4.6) |
| Segmented controls | "Use a segmented control to provide closely related choices that affect an object, state, or view"; "keep segment size consistent"; use text or images, not a mix | Two equal-width text chips that behave like a segmented control: exactly one is always selected |
| Text fields | "Display a Clear button in the trailing end of a text field…"; "Validate fields when it makes sense…"; placeholder text disappears while typing, so keep a separate label | Trailing clear button; inline invalid state; the "Person N" label is always shown |
| Virtual keyboards | "Choose a keyboard that matches the type of content…"; "Place custom controls above the keyboard thoughtfully… make sure they're relevant to the current task" | Decimal pad. The toolbar holds only Previous, Next, and Done |
| Steppers | "Make the value that a stepper affects obvious" | The count label stays between − and + |

---

## 3. User flow

### 3.1 Split rules

**Terms** (the developer and reviewers should use these words)

- **Typed row**: the field's text is non-empty after trimming whitespace. Its bill portion is whatever `AmountParser` makes of that text. The app never changes a typed row.
- **Automatic row**: the field's text is empty. Its bill portion is an even share of `max(0, bill − sum of valid typed rows)`, split across all automatic rows with `ShareAllocator` equal weights, so leftover øre or cents go to the lowest-numbered automatic rows. It is computed, never written into `amountText`.
- Whether a row is typed or automatic depends only on its text, so `PersonSplit.isEdited` isn't needed.

**The two details delegated to design (Q4/Q7)**

- **(a) A row added with + is empty, so it is automatic.** It takes an even share of what's left, and the other automatic rows re-split with it. For example, 4 automatic rows at 312,50 kr become 5 rows at 250,00 kr. No typed amount changes.
- **(b) Yes: every untouched (empty) row follows bill, head-count, and other-row changes until the user types in it.** The rule the user sees is: *type the amounts you know; empty rows split the rest.* Why: nothing the user typed is ever overwritten, and nothing they didn't type goes stale, because untouched rows re-split what's left whenever the bill, the head count, or another row changes. Literal prefilled text would leave those rows wrong until the user recalculated and retyped them.

**Automatic amounts show in every state (PM decision, round 1).** Automatic amounts are input previews, so rows show them in every status, including S1a–S4. During S3, for example, automatic rows preview 0,00. Q6 governs only the results card, which shows no per-person amounts unless the status is S5.

**Automatic amount format.** This is display only.

- Formatted by `CurrencyFormatter` without a symbol, in the currency's locale, with `Currency.fractionDigits` (2) fraction digits and the locale's grouping separator. Examples: NOK "1 250,00" (no-break space, decimal comma); USD and KES "1,250.00".
- Never inserted into the field and never parsed. When the user types in an automatic row, their own text replaces the preview.

**Switching to Custom before a bill is typed.** Every row is automatic and previews 0,00, and the status is S1a. As the bill is typed, the previews become the equal split live, with no extra prefill step, and the status becomes S5.

**Binding decisions → this spec**

| Decision | How the spec meets it |
|---|---|
| Q1 amounts only | One amount field per row. No percentages or shares |
| Q2 pre-tip parts that add up; tip and rounding shared in proportion | Rule caption (§4.3). The status checks the rows against the bill (§3.2). The card shows `personShares` (§4.7) |
| Q3 anonymous | "Person 1…N" (`PersonSplit.label`) |
| Q4/Q7 start from the equal split, exact, leftovers to the lowest-numbered people | With no typed rows, every row is automatic, which *is* the equal split, exact to the øre (100,00 kr ÷ 3 → 33,34 · 33,33 · 33,33). Approved by the human in place of literal prefilled text |
| Q4/Q7 typed amounts kept and rechecked live | Typed rows are never modified. Previews, the status, and the card recompute on every change |
| Q4/Q7 Equal → Custom → Equal → Custom keeps them | Rows live in the ViewModel for the session. The mode switch only shows or hides them |
| Q4 nothing persists | The app launches in Equal mode with every row empty |
| Q7 + adds a row, − removes the last | + appends an automatic row. − removes the last row, typed or automatic |
| Q5 rounding | Per Person ↑ adds an "Extra from rounding up" line (§4.7). Tip ↑ and Total ↑ split the rounded total |
| Q6 no per-person amounts until balanced; status in words + icon | §3.2 and §4.7. Tip and Total stay on the card (human decision, round 1) |
| Q9 iOS 17 | §4.13 |

**Impact on logic tasks and wording (for the PM and v2-planner; not product questions)**

| Where in TASKS.md | Current wording | Change for automatic rows |
|---|---|---|
| Phase 2A exit criteria | "switching to Custom starts balanced from the equal-split prefill" | "…starts balanced, with every row automatic (the equal split)" |
| Q7 decision text | "rows are prefilled with equal portions" | Record the human's approval of automatic rows |
| 2A-3 AC3 and AC5 | `PersonSplit.isEdited`, and the test for "a new `PersonSplit` starting unedited" | Drop both. Typed vs automatic is decided by the text (§3.1) |
| 2A-6 AC1 | "a new row's content per spec" | An empty, automatic row |
| 2A-6 AC2 | "prefills every row… rows parse to [3334, 3333, 3333]" | Switching to Custom writes no text. For bill "100" with 3 people, every `amountText` stays empty and the rows' **bill portions** are [3334, 3333, 3333] minor units, so it starts `.balanced` |
| 2A-6 AC3 | Prefilled text parses back with no grouping separator (bill "3000", 2 people → 150_000 each) | For bill "3000" with 2 people, the portions are [150_000, 150_000]. Their display text is the automatic format in §3.1 ("1 500,00" / "1,500.00"), which is never written or parsed |
| 2A-6 AC4 | `allocationStatus`… "(empty = 0)" | "(empty rows are automatic, §3.1)". The status order is §3.2's S1a–S5. The three examples are unchanged, because none of them has an empty row |
| 2A-6 AC6 | "whether untouched prefilled rows follow… per spec" | Empty rows follow automatically, because their portions are computed. Typed rows never change |
| 2A-6 outputs (new) | none | Per-row bill portions (typed or automatic) in minor units; the lowest-numbered invalid row; "bill text is non-empty but rejected" (for S1b). **This may trigger 2A-6's split-out note.** Automatic rows replace both the prefill and the `isEdited` tracking, so the logic is similar in size, but the planner should decide |
| 2A-9 AC2 | "equal-mode stepper unchanged" | "…unchanged except that its row is 44 pt tall (hit areas, §4.3)" |
| 2A-10 AC3 | Previews: empty, filled, invalid, AX5 | Add §4.5's KES / `.xxxLarge` / 375 pt preview |
| 2A-11 AC1 | "shows the prefilled equal split… sets `isEdited`" | "shows every row automatic with the equal split, balanced; a row is typed iff its text is non-empty" |
| 2A-11 AC5 | "equal mode renders as before" | "…apart from the toggle and the 44 pt stepper row" |
| 2A-12 | Visible-field AC | Restated for every text size and orientation in §6 |
| 2A-14 AC4 | "starting from the prefilled equal split" | "starting from the automatic equal split" |

### 3.2 Split status (evaluated top to bottom; the first match wins)

| # | State | Condition | Icon (SF Symbol) | Icon color | Sentence (NOK example) |
|---|---|---|---|---|---|
| S1a | Bill missing | Bill text is empty, or parses to 0 | `info.circle.fill` | `AppColors.bbSecondaryText` | "Enter the bill amount first" |
| S1b | Bill unreadable | Bill text is non-empty and `AmountParser` rejects it | `exclamationmark.triangle.fill` | `AppColors.bbWarning` | "Check the bill amount" |
| S2 | Invalid row | Any typed row that `AmountParser` rejects; name the lowest-numbered one | `exclamationmark.triangle.fill` | `AppColors.bbWarning` | "Check Person 3's amount" |
| S3 | Over | Sum of typed rows > bill | `exclamationmark.triangle.fill` | `AppColors.bbWarning` | "2,50 kr over the bill" |
| S4 | Left | No automatic rows, and sum of typed rows < bill | `exclamationmark.circle.fill` | `AppColors.bbWarning` | "50,00 kr left to assign" |
| S5 | Balanced | Anything else | `checkmark.circle.fill` | `AppColors.bbSecondaryText` | "Adds up to 1 250,00 kr" |

- Amounts are formatted with `CurrencyFormatter.format(amount:currency:)`. S3 and S4 show the difference; S5 shows the bill.
- While a typed row is invalid, it counts as 0 when the automatic share is computed.
- The icon shape differs between calm states (S1a info, S5 check) and problem states (S1b, S2, and S3 triangle; S4 exclamation circle). Color is only a third cue.

### 3.3 Main flow

1. **Launch.** Equal mode, with every row empty and hidden. The section shows the headline, the stepper, and the toggle with Equal selected. The results card is today's card.
2. The user enters the bill, tip, and head count as today.
3. The user taps **Custom**. A light haptic fires. The rule caption and one row per person expand below the toggle, and the status card slides in, pinned at the bottom. Every row is automatic and previews the equal split (1 250,00 kr ÷ 4 → 312,50 each). The status reads "Adds up to 1 250,00 kr", and the card lists what each person pays, tip included.
4. The user taps Person 1's field. The decimal pad opens with the toolbar `∧  ∨  ……  Done`.
5. The user types `150`. Person 1 becomes typed, and its "Splits the rest" caption goes blank. Persons 2–4 update live to 366,67 · 366,67 · 366,66. The status stays S5. At 15 % tip, the card shows 172,50 · 421,67 · 421,67 · 421,66 kr.
6. **∨ (Next)** moves focus through Person 2 … Person N. **∧ (Previous)** moves back through Person 1 to the bill field. Each move scrolls the focused field into view above the status card. **Done** dismisses the keyboard.
7. Suppose every row gets typed and the total doesn't match, for example 150 + 500 + 300 + 250 = 1 200. The status becomes S4, "50,00 kr left to assign", with a warning icon. The card replaces its per-person rows with the same status and "Each person's share appears once the amounts add up to the bill." To fix it, the user edits a row, or clears one with ⓧ so it becomes automatic. It then previews 300,00, and the status returns to S5.
8. When the user taps **Equal**, the rows and the status card collapse. Typed amounts stay for the session.

### 3.4 Empty, error, and edge states

| # | Situation | Behavior |
|---|---|---|
| E1 | Custom before the bill is typed | Automatic rows preview 0,00; status S1a. The card shows Tip and Total at 0,00 plus the S1a status. As the bill is typed, the previews become the equal split and the status becomes S5 |
| E1b | Bill text rejected by `AmountParser` (for example a pasted "1 234,50") | Status S1b "Check the bill amount". Automatic rows preview 0,00. The card behaves as in E1 |
| E2 | A row's text is rejected (for example "1,2,3" or pasted "12abc") | The row shows the invalid state (§4.5), and the status is S2. The card hides per-person amounts, and the text is kept as typed. A leading separator (",5") can show S2 for one keystroke. That's accepted, and it isn't announced (§4.1) |
| E3 | Typed rows add up to more than the bill | S3. Automatic rows preview 0,00. The card hides per-person amounts |
| E4 | Every row is typed and they add up to less than the bill | S4 (step 7) |
| E5 | + in Custom | Appends Person N+1 as an automatic row, and automatic rows re-split. There's no auto-scroll, so the stepper stays under the thumb. + is disabled at 20 (existing) |
| E6 | − in Custom | Removes the last row and discards its typed amount, if any. Automatic rows re-split. − is disabled at 1 (existing) |
| E7 | The focused row is removed | Focus is set to `nil`. Stepping 20 → 1 with Person 20 focused doesn't crash |
| E8 | − or + in Equal mode | The same (hidden) rows change. − also discards the last person's typed amount (Q7) |
| E9 | 1 person | The toggle stays enabled. Custom shows one row (automatic, the whole bill) and the hint "Add people with + to split by amount." In S5 the card equals Equal mode's 1-person card; otherwise it adds the status |
| E10 | 20 people | 20 rows. The pinned card is visible at every scroll position (§4.1), and Next/Previous walk all 20 fields |
| E11 | Bill, tip, rounding, or currency changes | Typed text is untouched. Previews, the status, and the card recompute. A currency change only swaps the symbol and formatting |
| E12 | Switch to Equal while a person field is focused | Focus is set to `nil`, and the rows and card collapse |
| E13 | Switch to Custom while the bill field is focused | Focus stays on the bill. Previous and Next appear |
| E14 | "Clear amounts" | Confirmation, then every row becomes automatic, which is the equal split again |
| E15 | The user types `0` | That row is typed at 0, so the person pays nothing. It is not automatic |
| E16 | Relaunch | Equal mode, every row empty (Q4) |
| E17 | iPhone landscape with the keyboard up | The pinned card's sentence is limited to 1 line, so the focused field still fits (§4.6) |

---

## 4. Screen specs

Spring = `.spring(response: 0.4, dampingFraction: 0.7)`. "RM" = Reduce Motion (`@Environment(\.accessibilityReduceMotion)`). "AX sizes" = `dynamicTypeSize.isAccessibilitySize`. "Large sizes" = `dynamicTypeSize >= .xxLarge`, which includes AX sizes.

### 4.0 Layout overview

Custom mode, 4 people, Person 1 focused, keyboard up, default text size:

```
│ Split the bill                                   │  headline
│  (−)    4    (+)                                 │  stepper row, 44 pt tall
│ ┌──────────────────────┐ ┌─────────────────────┐ │
│ │        Equal         │ │     ✓ Custom        │ │  SplitModeToggle, 44 pt chips
│ └──────────────────────┘ └─────────────────────┘ │
│ Amounts are before tip. Tip and rounding are     │  rule caption
│ shared in proportion.                            │
│ Person 1          ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ │  typed + focused:
│                   ┃ kr             150,00    ⓧ ┃ │  teal border and fill, clear slot
│                   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ │
│ Person 2          ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┐ │  automatic:
│ Splits the rest     kr             366,67        │  dashed outline, secondary text
│                   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘ │
│ Person 3 …                         366,67        │
│ Person 4 …                         366,66        │
│                                  Clear amounts   │  footer (only with a typed row)
│ ╭──────────────────────────────────────────────╮ │
│ │ ✓  Adds up to 1 250,00 kr                     │ │  pinned status (GlassCard)
│ ╰──────────────────────────────────────────────╯ │
│  ∧   ∨                                     Done  │  keyboard toolbar
```

The label column is the same width in every row, so all fields line up. At large sizes each row stacks: label, then the full-width field, then the caption (§4.5).

### 4.1 `CalculatorView` (changed: 2A-11, 2A-12)

**Layout (order unchanged):** `CurrencyPickerView` → `BillInputView` → `TipSelectorView` → `SplitControlView` → `RoundingSelectorView` → `ResultsCardView`. They sit in `ScrollView` / `VStack(spacing: AppSpacing.lg)`, with horizontal padding `AppSpacing.md`, vertical padding `AppSpacing.xxl`, and background `AppColors.bbBackground`.

**Pinned status card (2A-11)**

- **Placement.** `.safeAreaInset(edge: .bottom)` on the `ScrollView`, only in Custom mode. It contains `GlassCard { SplitStatusView(state:, style: .pinned) }` with `.padding(.horizontal, AppSpacing.md)` and `.padding(.bottom, AppSpacing.sm)`.
- **Why it stays visible.** The inset sits directly above the keyboard toolbar while typing, and above the home indicator otherwise. The scroll content gets a matching inset.
- **Size rules** are in §4.6 (`.pinned` style): capped at AX1, at most 2 lines (1 line in landscape), and the Large Content Viewer shows the full sentence.
- **Height budget with the keyboard up at AX5**, estimated for the decimal pad plus toolbar:

  | | Pinned card | Content left for the focused field |
  |---|---|---|
  | iPhone SE (3rd gen), portrait | ≤ ≈ 100 pt | ≈ 279 pt |
  | iPhone 16, portrait | ≤ ≈ 100 pt | ≈ 350 pt |
  | iPhone landscape (1 line) | ≈ 66 pt | ≈ 87–107 pt |

  An AX5 field box is ≈ 64 pt tall, so it always fits.
- **Motion.** `.transition(.move(edge: .bottom).combined(with: .opacity))` with the spring. No animation under RM.
- **Announcements (debounced).** Post `AccessibilityNotification.Announcement(<sentence>)`:
  - when Custom mode turns on
  - after a focus change (including Done), a stepper tap, or a confirmed "Clear amounts", but only if the S-state differs from the last one announced

  Never announce while the user is typing. For example, typing the bill "1250" announces once, when the user leaves the field, and ",5" (E2) announces nothing.

**Focus and keyboard (2A-12)**

- **One owner.** `@FocusState private var focusedField: CalculatorField?`, where `enum CalculatorField: Hashable { case bill; case person(PersonSplit.ID) }`. The binding is passed to `BillInputView` and, through `SplitControlView`, to each `PersonSplitRow`.
- **One toolbar.** `.toolbar { ToolbarItemGroup(placement: .keyboard) { … } }` here, and nowhere else in the app.
  - **Equal mode:** `Spacer()`, `Button("Done")`. Identical to today.
  - **Custom mode:** `Button` with `Image(systemName: "chevron.up")` (Previous), `Button` with `Image(systemName: "chevron.down")` (Next), `Spacer()`, `Button("Done")`.
  - **Focus order:** bill → Person 1 → … → Person N. Previous is `.disabled` on the bill, and Next is `.disabled` on Person N. Done sets `focusedField = nil`.
  - **Color.** The items use the app's AccentColor (#00E5CC, the same value as `bbTealText` in dark mode). There's no view-level `.tint`, which may not reach keyboard-toolbar items; see the developer note in §5.
  - No other controls go in the toolbar. Automatic rows already split the rest.
- **Scroll to focus.** Wrap the content in `ScrollViewReader`. The `.id` sits on the **field box**, not the whole row:
  - `BillInputView`'s field: `.id(CalculatorField.bill)`
  - each `PersonSplitRow`: `.id(<its focus value>)` on its `fieldBox` (§4.5)

  On every change of `focusedField` to a non-nil value, call `proxy.scrollTo(field)` with no anchor (minimum scroll). Animate it with the spring, or not at all under RM. Moving forward (Next), the row's label stays visible above its field. Moving back at large sizes, the label can sit just above the top edge; VoiceOver and the Previous/Next order still identify the person.
- **Focus clean-up.** If the focused person row disappears (E7, E12), set `focusedField = nil`.

### 4.2 `BillInputView` (changed: 2A-12)

- Remove its private `@FocusState` and its `.toolbar`. It takes the shared focus binding, applies `.focused(focus, equals: .bill)`, and carries `.id(CalculatorField.bill)`.
- Everything else is unchanged: the currency prefix, the `AppTypography.mono` field, `.decimalPad`, and the VoiceOver label and value.
- **Previews:** a small wrapper view that owns a local `@FocusState private var focus: CalculatorField?` and passes `$focus`, in light and dark.

### 4.3 `SplitControlView` (changed: 2A-9, 2A-11)

Top to bottom, in `VStack(alignment: .leading, spacing: AppSpacing.sm)`:

1. **Headline** "Split the bill": `AppTypography.headline`, `bbPrimaryText` (unchanged).
2. **Stepper row.** Glyphs, glyph size, colors, count label, `HapticManager.mediumImpact()`, bounds, and VoiceOver label and value are unchanged.
   - Put `.frame(minWidth: AppSpacing.minTapTarget, minHeight: AppSpacing.minTapTarget)` and `.contentShape(Rectangle())` **on the `Image` inside each button's label**. With `.buttonStyle(.plain)`, the label's shape is the hit area.
   - The row becomes 44 pt tall (it's ≈ 28 pt today), and the −/+ glyph centers move ≈ 8 pt outward. This is the only visible change in Equal mode besides the toggle, and the ACs say so.
   - In Custom mode only, add VoiceOver hints: − "Removes Person N" and + "Adds Person N+1".
3. **`SplitModeToggle`** (§4.4). It sits below the stepper, so nothing moves under the thumb when the head count changes.
4. **Custom block** (Custom mode only). This is a private `CustomSplitListView` in the same file: `VStack(alignment: .leading, spacing: AppSpacing.sm)` with `.padding(.top, AppSpacing.xs)`.
   - a. **Rule caption:** "Amounts are before tip. Tip and rounding are shared in proportion." Style: `AppTypography.caption`, `bbSecondaryText`, wrapping.
   - b. **Rows:** `ForEach($viewModel.personSplits) { $split in PersonSplitRow(…) }`. Iterate over stable ids with element bindings.
   - c. **Footer row.** Present only when at least one item is shown. It's an `HStack(alignment: .firstTextBaseline)`, or a `VStack(alignment: .leading)` at AX sizes:
     - **Leading:** the 1-person hint "Add people with + to split by amount." (`AppTypography.caption`, `bbSecondaryText`), only when `splitCount == 1`.
     - **Trailing:** **"Clear amounts"**, only when at least one row is typed. It's hidden, not greyed out, when there's nothing to clear.
   - **Motion:** the block uses `.transition(.opacity.combined(with: .move(edge: .top)))` with the spring, and rows added or removed by the stepper use the same. No animation under RM.

**"Clear amounts" button**

| Property | Value |
|---|---|
| Label | `Text("Clear amounts")`, `AppTypography.body`, `AppColors.bbTealText` |
| Target | `.frame(minHeight: AppSpacing.minTapTarget)`, `.contentShape(Rectangle())` |
| Tap | `.confirmationDialog("Clear typed amounts?", isPresented:, titleVisibility: .visible)` with the message "Everyone goes back to an even share of the bill." and the buttons "Clear Amounts" (`role: .destructive`) and "Cancel" |
| Confirm | `HapticManager.lightImpact()`, then every `amountText = ""` (spring; none under RM). Focus is unchanged |
| VoiceOver | Label "Clear amounts". Hint "Empties every typed amount so everyone shares the bill evenly" |

### 4.4 `SplitModeToggle` (new: 2A-9)

- **File:** `Views/Calculator/SplitModeToggle.swift`.
- **Input:** `@Binding var mode: SplitMode`. It has no ViewModel dependency.
- **Why chips and not `Picker(.segmented)`.** The system control is about 32 pt tall on iOS 17 and can't be resized from SwiftUI, while 2A-9 requires targets of at least 44 pt. The chip is BillBuddy's existing selection idiom (`TipPresetButton`). It follows the HIG's segmented-control rules: equal widths, text labels, and exactly one selected.

**Layout**

- **Default sizes:** `HStack(spacing: AppSpacing.sm)` of two chips, in `SplitMode.allCases` order.
- **AX sizes:** `VStack(spacing: AppSpacing.sm)`.
- **Each chip:**
  - frame: `.frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)`
  - hit area: `.contentShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))`, so the whole chip is tappable even when its fill is `.clear`
  - content: `HStack(spacing: AppSpacing.xs) { Image(systemName: "checkmark"); Text(mode.displayText) }` in `AppTypography.body`
  - the checkmark is always laid out, with `.opacity(isSelected ? 1 : 0)` and `.accessibilityHidden(true)`

**Chip styles**

| | Unselected | Selected |
|---|---|---|
| Fill | `.clear` | `AppColors.bbSelectedChip` |
| Border (1.5 pt, `RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)`) | `AppColors.bbUnselectedBorder` | `AppColors.bbSelectedBorder` |
| Text and checkmark | `AppColors.bbPrimaryText`, checkmark hidden | `AppColors.bbTealText`, checkmark visible |

**Behavior**

- Tapping the unselected chip fires `HapticManager.lightImpact()` first, then `withAnimation(reduceMotion ? nil : spring) { mode = tapped }`. Tapping the selected chip does nothing.
- The toggle is enabled at every head count from 1 to 20.

**VoiceOver**

- The container uses `.accessibilityElement(children: .contain)` with the label "Split mode".
- The chips are labeled "Equal split" and "Custom split", with the value "Selected" or "Not selected" (the `TipPresetButton` pattern).
- The Custom chip's hint is "Type the amounts you know; empty rows split the rest".

**Previews:** light, dark, and `.accessibility5`, each with either chip selected.

### 4.5 `PersonSplitRow` (new: 2A-10)

- **File:** `Views/Calculator/PersonSplitRow.swift`. It's standalone, with no ViewModel dependency.
- **Inputs:**
  - `personNumber: Int`
  - `@Binding var amountText: String`
  - `currency: Currency`
  - `automaticAmountText: String`: the §3.1 format, produced by `CurrencyFormatter`
  - a focus hook: a generic `FocusState<Value?>.Binding` plus `focusValue: Value`. The row uses it for `.focused(_:equals:)`, for its focused styling, and as the scroll `.id` of its `fieldBox`. Previews supply a local focus state.
- **Derived state:**
  - `isEmpty`: the text is empty after trimming whitespace
  - `isInvalid`: `!isEmpty` and `AmountParser` rejects the text
  - `isFocused`

**Layout: two arrangements, chosen by text size**

| Text size | Arrangement |
|---|---|
| Up to `.xLarge` | **Horizontal:** `HStack(alignment: .center, spacing: AppSpacing.md) { labelColumn.fixedSize(); fieldBox.frame(maxWidth: .infinity) }` |
| `.xxLarge` and up (all AX sizes) | **Stacked:** `VStack(alignment: .leading, spacing: AppSpacing.xs) { labelLine; fieldBox; captionLine }`. The field is full width, and the caption sits under the field, like a form's helper text |

**Label column (horizontal arrangement).** `VStack(alignment: .leading, spacing: AppSpacing.xs) { labelLine; captionLine }` with a **constant width in every row**, set by hidden sizing views rather than a number:

- `labelLine` = `ZStack(alignment: .leading) { Text("Person 20").hidden(); Text(label) }`
- `captionLine` = `ZStack(alignment: .leading) { automaticCaption.hidden(); invalidCaption.hidden(); visibleCaption }`

The column is therefore as wide as the widest of "Person 20" and both captions at the current text size. That keeps every field aligned and scales with Dynamic Type. In the stacked arrangement, `labelLine` is just `Text(label)`, and `captionLine` keeps the same `ZStack`, so its height never changes.

**Captions.** Every caption slot is always laid out, so a row never changes height while the user types.

| Row state | Caption |
|---|---|
| Automatic | "Splits the rest", `AppTypography.caption`, `bbSecondaryText` |
| Invalid | `Label("Invalid amount", systemImage: "exclamationmark.triangle.fill")`, `AppTypography.caption`, `AppColors.bbWarning` |
| Typed and valid | Blank (the hidden sizing views keep the height) |

**`fieldBox`**

- Contents: `HStack(spacing: AppSpacing.xs)` holding:
  1. `Text(currency.symbol)`: `AppTypography.body`, `bbSecondaryText`, `.accessibilityHidden(true)`.
  2. An amount area, `ZStack(alignment: .trailing)` with `.frame(maxWidth: .infinity, alignment: .trailing)`:
     - When `isEmpty`: `Text(automaticAmountText)` in `AppTypography.amountField` and `bbSecondaryText`. It keeps `.lineLimit(1)`, and `.minimumScaleFactor(AppTypography.amountMinimumScale)` shrinks it to fit, down to 50 %. Beyond that it truncates at the tail; that only happens for amounts of 1 000 000 or more at AX4–AX5 on a 375 pt screen, and VoiceOver and the results card still have the full amount. It also gets `.contentTransition(.numericText())` (`.opacity` under RM) and `.accessibilityHidden(true)`. It's drawn as a `Text`, not the system placeholder (≈ 2.3:1).
     - `TextField("", text: $amountText)` in `AppTypography.amountField`, `bbPrimaryText`, `.multilineTextAlignment(.trailing)`, `.keyboardType(.decimalPad)`, `.autocorrectionDisabled()`. It stays on one line; typed text longer than the field scrolls horizontally, as a system text field does.
  3. **While focused only**, a clear slot sized `.frame(minWidth: AppSpacing.minTapTarget, minHeight: AppSpacing.minTapTarget)`. The slot is present for the whole focus session. Its button is visible only when `!isEmpty`, and the button uses the same min-frame, so the slot grows with the glyph (≈ 48 pt at AX3, ≈ 60 pt at AX5) and never overflows or overlaps the amount.
- Padding: leading `AppSpacing.md`. Trailing `AppSpacing.md`, or `AppSpacing.xs` while focused, so the glyph never touches the border.
- Frame: `.frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)`.
- Shape: clip, `strokeBorder`, and `.contentShape` all use `RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)`.
- **Tap to focus:** `.onTapGesture { focus.wrappedValue = focusValue }`. A content shape alone doesn't focus the field. A tap anywhere in the box, including the symbol, focuses the field with the caret at the end.
- **Scroll target:** `.id(focusValue)` (§4.1).

**Width check**

Estimates for SF Rounded tabular digits at ≈ 0.61 em, KES, and a focused row (the tightest case). Label column ≈ 102 pt at Large and ≈ 111 pt at xLarge.

| Screen width · text size | Arrangement | Space for the amount | "12,345.67" needs | Result |
|---|---|---|---|---|
| 375 pt · Large (default) | horizontal | ≈ 125 pt | ≈ 83 pt | fits |
| 375 pt · xLarge | horizontal | ≈ 113 pt | ≈ 92 pt | fits |
| 375 pt · xxxLarge (review preview) | stacked | ≈ 233 pt | ≈ 111 pt | fits |
| 393 pt · xxxLarge, NOK "1 250,00" | stacked | ≈ 269 pt | ≈ 98 pt | fits |
| 375 pt · AX5 | stacked | ≈ 160 pt | ≈ 257 pt | scales to ≈ 62 % |
| 320 pt (Display Zoom) · Large | horizontal | ≈ 70 pt | ≈ 83 pt | scales to ≈ 84 % |

**Visual states** (border color precedence: invalid, then focused, then default)

| State | Condition | Border (1.5 pt) | Fill | Amount shown | Caption | Clear slot |
|---|---|---|---|---|---|---|
| Automatic | empty, not focused | **dashed**: `StrokeStyle(lineWidth: 1.5, dash: [AppSpacing.xs])`, `bbUnselectedBorder` | `.clear` | preview, `bbSecondaryText` | "Splits the rest" | none |
| Automatic, focused | empty, focused | solid, `bbSelectedBorder` | `bbSelectedChip` | preview, `bbSecondaryText` | "Splits the rest" | slot, no button |
| Typed | valid, not focused | solid, `bbUnselectedBorder` | `.clear` | typed text, `bbPrimaryText` | blank | none |
| Typed, focused | valid, focused | solid, `bbSelectedBorder` | `bbSelectedChip` | typed text | blank | button |
| Invalid | rejected, not focused | solid, `bbWarning` | `.clear` | typed text | ⚠ "Invalid amount" | none |
| Invalid, focused | rejected, focused | solid, `bbWarning` | `bbSelectedChip` | typed text | ⚠ "Invalid amount" | button |

- **Row height** never changes while typing or focusing. The caption slot is always laid out, amounts are one line, and the clear glyph is no taller than the amount's text line.
- **Non-color cues** for the automatic state: the words in its caption, the dashed outline (a shape), and the lower-contrast preview.
- **Text handling:** kept as typed, never reformatted. Validity comes only from `AmountParser`, so "12,50" and "12.50" are both valid.

**Clear button**

| Property | Value |
|---|---|
| Glyph | `Image(systemName: "xmark.circle.fill")`, `AppTypography.body`, `bbSecondaryText` |
| Action | `HapticManager.lightImpact()`, then `amountText = ""`. Focus stays, and the row is automatic again |
| VoiceOver | Label "Clear Person N amount" |

**VoiceOver.** The `TextField` is the row's single element. The label, symbol, caption, and preview are hidden. It uses one phrase for automatic rows, "splits the rest", matching the caption.

| | Value |
|---|---|
| Label | "Person N amount" |
| Value, automatic | "366,67 NOK, splits the rest" |
| Value, typed | "\<text as typed\> NOK" |
| Value, invalid | "\<text\>, invalid amount" |
| Hint, automatic rows only | "Type an amount, or leave empty to split the rest" |

**Motion.** Border, fill, and caption changes use the spring. No animation under RM.

**Previews** (light and dark):

- automatic, typed, automatic-focused, typed-focused, invalid, and `.accessibility5`
- **KES, 1 person, bill "12345.67" (preview "12,345.67"), focused, 375 pt wide (`#Preview(traits: .fixedLayout(width: 375, height: …))` with `.padding(.horizontal, AppSpacing.md)`), `.xxxLarge`**. Expected: stacked arrangement, the whole amount on one line, no scaling

### 4.6 `SplitStatusView` (new: 2A-11, reused by 2A-13)

- **File:** `Views/Components/SplitStatusView.swift`.
- **Inputs:** a display state for S1a–S5 with the already-formatted strings, plus a `style` (`.pinned` or `.inline`). The caller maps ViewModel state, and this view does no arithmetic.

**Layout.** `HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm)` containing:

- `Image(systemName:)` in `AppTypography.headline`, colored per §3.2
- `Text(sentence)` in `AppTypography.headline`, `bbPrimaryText`

Then `.frame(maxWidth: .infinity, alignment: .leading)`.

**Styles**

| | `.pinned` (in `CalculatorView`'s `GlassCard`) | `.inline` (in `ResultsCardView`) |
|---|---|---|
| Dynamic Type | Capped: `.dynamicTypeSize(...DynamicTypeSize.accessibility1)` | Scales fully, up to AX5 |
| Lines | `.lineLimit(2)`, or `.lineLimit(1)` when `verticalSizeClass == .compact` (iPhone landscape). Truncates at the tail | Unlimited |
| Full-size fallback | `.accessibilityShowsLargeContentViewer { Label(sentence, systemImage: icon) }`, so a long press shows the full sentence at the user's size | Not needed |
| Extra caption | none | For S2–S4 only, below the status: "Each person's share appears once the amounts add up to the bill." (`AppTypography.caption`, `bbSecondaryText`, `VStack` spacing `AppSpacing.xs`) |

- At AX1 the longest sentences ("Check Person 20's amount", "KSh 1,234,567.89 left to assign") fit in 2 lines, so truncation is a rare fallback. The full sentence is always in VoiceOver, and in the card when not balanced.
- **Motion:** the sentence uses `.contentTransition(.numericText())` with the spring (`.opacity` without the spring under RM). The icon swaps with a crossfade (instant under RM).
- **VoiceOver:** when pinned, `.accessibilityElement(children: .ignore)`, the label "Split status", and the sentence as the value. Inline, the text becomes part of the card's combined value (§4.7).
- **Previews:** S1a, S1b, S2–S5 in light and dark, plus S4 at `.accessibility5` in both styles.

### 4.7 `ResultsCardView` (changed: 2A-13)

Inside the existing `GlassCard` and `VStack(alignment: .leading, spacing: AppSpacing.sm)`, top to bottom:

1. "Results" (unchanged).
2. `BreakdownRow` Tip, then `BreakdownRow` Total (unchanged). They stay in every mode and state (human decision on Q6).
3. The rest depends on mode and state:

| Mode · people · state | Rows after Total |
|---|---|
| Equal | Unchanged: "Per Person" when `splitCount > 1` |
| Custom · 1 · S5 | Nothing. The card equals Equal mode's 1-person card, with no extra line |
| Custom · any · S1a or S1b | Inline status, no caption |
| Custom · any · S2, S3, or S4 | Inline status plus the caption. **No per-person amounts** |
| Custom · 2–20 · S5 | "Each person pays" (`AppTypography.caption`, `bbSecondaryText`, `.padding(.top, AppSpacing.xs)`), then one `BreakdownRow(label: "Person k", value:)` per person from `personShares`. Then, only with Per Person ↑, a last `BreakdownRow(label: "Extra from rounding up", value: roundingSurplus)`, shown even at 0,00 |

**Rules.** All values come from the ViewModel and are formatted with `CurrencyFormatter`; the view does no arithmetic. Tip ↑ and Total ↑ add no line.

**Worked example** (bill 1 250 kr, 15 % tip, rows 150 + three automatic):

| Rounding | Tip | Total | Person 1 | Person 2 | Person 3 | Person 4 | Extra from rounding up |
|---|---|---|---|---|---|---|---|
| None | 187,50 kr | 1 437,50 kr | 172,50 kr | 421,67 kr | 421,67 kr | 421,66 kr | — |
| Per Person ↑ | 187,50 kr | 1 437,50 kr | 173,00 kr | 422,00 kr | 422,00 kr | 422,00 kr | 1,50 kr |

**Motion**

- The first-appearance stagger is unchanged, except under RM: no offset, no delay, opacity only.
- Swapping between per-person rows and the status, and inserting or removing person rows, uses `.transition(.opacity)` with the spring (instant under RM).
- Add `.animation(spring, value:)` for `splitMode`, the S-state, and `personShares` (`nil` under RM).

**VoiceOver.** Keep `.combine` and the label "Results". Values:

| State | Value |
|---|---|
| Custom, S5 | "Tip: 187,50 kr, Total: 1 437,50 kr, Person 1: 172,50 kr, …, Person 4: 421,66 kr", plus ", Extra from rounding up: 1,50 kr" when shown |
| Custom, S2–S4 | "Tip: …, Total: …, 50,00 kr left to assign. Each person's share appears once the amounts add up to the bill." |
| Custom, S1a or S1b | "Tip: …, Total: …, Enter the bill amount first." (or "Check the bill amount.") |
| Equal | Unchanged |

The first-result `HapticManager.success()` is unchanged.

**Previews** (light and dark): Equal; Custom S5 with 4 people; Custom S5 with Per Person ↑; Custom S1a; Custom S2 (this is 2A-13's "custom invalid" preview); Custom S3; Custom S4.

### 4.8 `BreakdownRow` (changed: 2A-13)

- **AX sizes:** `VStack(alignment: .leading, spacing: AppSpacing.xs) { label; value }` instead of the `HStack`.
- **At every size:**
  - the value keeps `.lineLimit(1)`, `.minimumScaleFactor(AppTypography.amountMinimumScale)`, and `.layoutPriority(1)`
  - the label wraps

  So "Extra from rounding up" wraps instead of pushing the amount, and a long amount shrinks instead of breaking mid-number.
- **Value transition:** `.contentTransition(.numericText())`, or `.opacity` under RM.
- In Equal mode these changes show only at AX sizes, with Reduce Motion on, or when an amount is too long for its row. They are deliberate accessibility fixes.
- **Previews:** light, dark, and `.accessibility5`.

### 4.9 Copy (all new user-facing strings)

| Where | Text |
|---|---|
| Toggle chips | "Equal", "Custom" (`SplitMode.displayText`) |
| Rule caption | "Amounts are before tip. Tip and rounding are shared in proportion." |
| Row label | "Person N" (`PersonSplit.label`) |
| Automatic caption | "Splits the rest" |
| Invalid caption | "Invalid amount" |
| 1-person hint | "Add people with + to split by amount." |
| Footer button | "Clear amounts" |
| Clear dialog | Title "Clear typed amounts?", message "Everyone goes back to an even share of the bill.", buttons "Clear Amounts" / "Cancel" |
| Status | S1a "Enter the bill amount first" · S1b "Check the bill amount" · S2 "Check Person N's amount" · S3 "\<amount\> over the bill" · S4 "\<amount\> left to assign" · S5 "Adds up to \<bill\>" |
| Card | "Each person pays" · "Extra from rounding up" · "Each person's share appears once the amounts add up to the bill." |

### 4.10 Motion and Reduce Motion

| Change | Animation | Under Reduce Motion |
|---|---|---|
| Mode switch: custom block and pinned card | Spring. Block: `.opacity` + `.move(edge: .top)`. Card: `.move(edge: .bottom)` + `.opacity` | Instant |
| Row added or removed | Spring, `.opacity` + `.move(edge: .top)` | Instant |
| Previews, status amount, card values | `.contentTransition(.numericText())` + spring | `.contentTransition(.opacity)`, no spring |
| Chip selection; row border, fill, and caption | Spring | Instant |
| Card: per-person rows ↔ status | `.opacity` + spring | Instant |
| Card: first-appearance stagger | Existing offset 20 → 0 + opacity, 0.05 s per row | Opacity only: no offset, no delay |
| Scroll to the focused field | Spring | Instant |

### 4.11 Haptics (all through `HapticManager`, fired before the visual update)

| Interaction | Call |
|---|---|
| Toggle chip changes the mode | `lightImpact()` |
| Stepper −/+ (both modes) | `mediumImpact()` (existing) |
| Row clear button | `lightImpact()` |
| "Clear amounts" confirmed | `lightImpact()` |
| Previous, Next, Done; status changes | none (`success()` stays reserved for the first result) |
| First calculation result | `success()` (existing) |

### 4.12 VoiceOver (every control)

| Element | Label | Value | Hint / notes |
|---|---|---|---|
| Toggle container | "Split mode" | — | `.contain` |
| Equal chip | "Equal split" | "Selected" / "Not selected" | — |
| Custom chip | "Custom split" | "Selected" / "Not selected" | "Type the amounts you know; empty rows split the rest" |
| Stepper − / + | "Decrease split" / "Increase split" (existing) | "N people" (existing) | Custom mode: "Removes Person N" / "Adds Person N+1" |
| Person field | "Person N amount" | §4.5 | Automatic rows: "Type an amount, or leave empty to split the rest" |
| Row clear button | "Clear Person N amount" | — | — |
| Clear amounts | "Clear amounts" | — | "Empties every typed amount so everyone shares the bill evenly" |
| Pinned status | "Split status" | The sentence | Announced on S-state changes, debounced (§4.1) |
| Toolbar ∧ / ∨ / Done | "Previous field" / "Next field" / "Done" | — | ∧ disabled on the bill; ∨ disabled on Person N |
| Results card | "Results" (existing) | §4.7 | `.combine` (existing) |

Decorative elements (row symbols, captions, previews, and the checkmark) are `.accessibilityHidden(true)`, because the parent value already says them. The hidden sizing views are `.hidden()` and so are not accessible.

### 4.13 iOS 17 API check (Q9)

Every API below exists on iOS 17.0:

- **Focus and keyboard:** `@FocusState` with a `Hashable` enum; `.focused(_:equals:)`; `ToolbarItemGroup(placement: .keyboard)`.
- **Layout and scrolling:** `.safeAreaInset(edge:)`; `ScrollViewReader` / `scrollTo`; `.hidden()`; `.fixedSize()`; `.layoutPriority`; `ForEach($collection)`; `StrokeStyle(dash:)`.
- **Environment:** `@Environment(\.accessibilityReduceMotion)`, `\.dynamicTypeSize` (a `Comparable` `DynamicTypeSize`), and `\.verticalSizeClass`.
- **Text:** `.dynamicTypeSize(...DynamicTypeSize.accessibility1)`; `.lineLimit`; `.minimumScaleFactor`; `.truncationMode`; `Font.monospacedDigit()`; `.contentTransition(.numericText())` and `.opacity`.
- **Accessibility:** `.accessibilityShowsLargeContentViewer(_:)` (iOS 15); `AccessibilityNotification.Announcement` (iOS 17).
- **Other:** `.confirmationDialog(_:isPresented:titleVisibility:)`; the two-parameter `.onChange(of:)` (iOS 17); `#Preview(traits: .fixedLayout(width:height:))` (iOS 17).

Nothing newer is used: no `TextSelection`, `ScrollPosition`, or `onScrollGeometryChange` (all iOS 18). There are no third-party dependencies.

---

## 5. New tokens

All five are **(proposed)** and are listed in `docs/STYLE-GUIDE.md` with that mark. They land in `DesignSystem/` with 2A-9, the first UI task that uses them.

| Token | Light | Dark | Usage | Why no existing token fits |
|---|---|---|---|---|
| `AppColors.bbWarning` | `#C93400` (Apple's Increase Contrast `systemOrange`, light) | `#FF9F0A` (Apple's `systemOrange`, dark) | Icons for S1b–S4; invalid-row border, icon, and caption | No token signals a problem. `bbTeal` is reserved for interactive and selected states. `bbSecondaryText` is neutral |
| `AppColors.bbTealText` | `#00695C` (brand hue 173°, darkened) | `#00E5CC` (= `bbTeal`) | Teal text and glyphs: the selected chip's label and checkmark, and "Clear amounts" | `bbTeal` as text measures 1.4:1 on light surfaces. The dark value equals `bbTeal`, so the runtime look is unchanged |
| `AppTypography.amountField` | `.system(.headline, design: .rounded, weight: .medium).monospacedDigit()` | same | Typed and automatic amounts in `PersonSplitRow` | A derived font used twice. Naming it keeps the no-raw-fonts rule and the code-review grep simple (N8) |
| `AppTypography.amountMinimumScale` | `0.5` (`CGFloat`) | same | `minimumScaleFactor` for one-line amounts: row previews and `BreakdownRow` values | Amounts must shrink instead of wrapping mid-number at large sizes (B3). A named value avoids a raw literal in views |
| `AppSpacing.minTapTarget` | `44` pt | same | Minimum width and height of every tap target (always `minWidth`/`minHeight`, so targets grow with text) | The HIG default is used in 6+ places. Today it exists only as a raw `44` in `SplitControlView` |

**Contrast** (WCAG relative luminance; text ≤ 17 pt, so the target is 4.5:1. Dark is what the app renders at runtime.)

| Foreground on background | Dark | Light (previews only) | Result |
|---|---|---|---|
| `bbWarning` on `bbBackground` / `bbCardBackground` | 9.6:1 / 8.3:1 | 4.7:1 / 5.3:1 | Pass |
| `bbTealText` on `bbBackground` / `bbSelectedChip` | 12.3:1 / 9.4:1 | 5.9:1 / 5.6:1 | Pass |
| `bbPrimaryText` on `bbBackground` / `bbCardBackground` | ≥ 17:1 | ≥ 18:1 | Pass. Used for status sentences, typed amounts, and labels |
| `bbSecondaryText` on `bbBackground` / `bbCardBackground` / `bbSelectedChip` (existing token) | 6.3:1 / 6.0:1 / 5.2:1 | 3.3:1 / 3.4:1 / ≈ 3.1:1 | Pass in dark. Used for automatic previews (input previews), captions, the rule line, and the currency symbol. The light values fall short at default contrast, but light mode appears only in previews, and `.secondary` darkens under Increase Contrast, which is the HIG fallback |
| For reference: `bbTeal` text on `bbSelectedChip` (existing chips) | 9.4:1 | 1.4:1 | This is why `bbTealText` exists |

Status icons are non-text elements, which need 3:1. They pass in dark (≥ 6.0:1) and in light (≥ 3.3:1).

**Developer note for 2A-9 (not a spec requirement).** Give AccentColor (`billBudy/Assets.xcassets/AccentColor.colorset`) a light appearance of `#00695C` and keep `#00E5CC` for dark. The caret, keyboard-toolbar items, and the dialog's Cancel button all use AccentColor, and a view-level `.tint` may not reach keyboard-toolbar items. At runtime (dark) nothing changes.

---

## 6. Acceptance criteria

### Spec-wide (design-reviewer Mode A; code-reviewer greps)

- [ ] Only tokens from STYLE-GUIDE.md, including the five marked (proposed). The only literal is the documented 1.5 pt chip border width.
- [ ] Every status (S1a–S5), the automatic state, the invalid state, and the selected chip each have a non-color cue.
- [ ] Every new tap target is ≥ 44×44 pt and uses `minWidth`/`minHeight`, so it grows with text and never clips its glyph.
- [ ] Layouts are defined for every text size: `SplitModeToggle` and the footer at AX sizes; `PersonSplitRow` stacked from `.xxLarge`; `BreakdownRow` at AX sizes; the pinned `SplitStatusView` capped at AX1.
- [ ] Every animation has a Reduce Motion behavior (§4.10). Only iOS 17 APIs (§4.13). All haptics go through `HapticManager`.

### 2A-9 `SplitModeToggle`

- [ ] Two equal-width chips below the stepper, bound to `splitMode`, with exactly one selected. The selected chip shows a checkmark, `bbTealText`, `bbSelectedChip`, and `bbSelectedBorder`.
- [ ] The whole chip is hit-testable, including a `.clear` unselected chip.
- [ ] Tapping the unselected chip fires `lightImpact()` before the change and animates with the spring (none under RM). Tapping the selected chip does nothing.
- [ ] Enabled at 1–20 people. The chips stack at AX sizes. VoiceOver matches §4.12.
- [ ] Stepper glyphs, colors, haptics, and VoiceOver label and value are unchanged. Its hit areas are 44×44 inside the button labels, so the row is 44 pt tall. Custom-mode hints match §4.12.
- [ ] `#Preview`s in light, dark, and AX5.

### 2A-10 `PersonSplitRow`

- [ ] The horizontal arrangement is used up to `.xLarge` and the stacked one from `.xxLarge`. The label column is sized by the hidden "Person 20" and both captions, so fields align in every row.
- [ ] The six states in §4.5 render with the stated border, fill, caption, and clear-slot rules and precedence.
- [ ] The automatic preview is a `Text` in `bbSecondaryText`, `AppTypography.amountField`, `.lineLimit(1)`, and `.minimumScaleFactor(AppTypography.amountMinimumScale)`, formatted per §3.1.
- [ ] The row never changes height while typing or focusing, at default size and at AX5.
- [ ] The clear slot and button use min-frames of `AppSpacing.minTapTarget`. At AX5 the glyph doesn't overflow the box or overlap the amount. The button empties the field and fires `lightImpact()`.
- [ ] A tap anywhere in the field box focuses the field.
- [ ] Text is kept as typed. "12,50" and "12.50" are valid; "1,2,3" shows "Invalid amount".
- [ ] VoiceOver matches §4.5, using the same "splits the rest" phrase as the caption.
- [ ] `#Preview`s: automatic, typed, focused, invalid, and AX5 in light and dark, plus the KES / `.xxxLarge` / 375 pt preview. That preview shows the stacked arrangement with "12,345.67" on one line and unscaled.

### 2A-11 Custom list and status

- [ ] The custom block shows only in Custom mode, in this order: rule caption (§4.9), rows (`ForEach` over stable ids with element bindings), footer.
- [ ] Switching to Custom shows every row automatic and balanced. Examples:
  - bill 100,00 kr, 3 people → previews 33,34 · 33,33 · 33,33
  - bill 1 250 kr, 4 people, Person 1 = 150 → 366,67 · 366,67 · 366,66
  - Custom before a bill → previews 0,00 and S1a; they follow the bill as it's typed
- [ ] + appends an automatic row and − removes the last. No other row's typed text ever changes.
- [ ] The pinned card shows only in Custom mode, sits directly above the keyboard toolbar while typing, and matches §3.2 and §4.6. It's capped at AX1, with 2 lines (1 in landscape) and the Large Content Viewer.
- [ ] "Clear amounts" appears only with a typed row. It asks first, with the dialog title visible, then makes every row automatic. The 1-person hint appears only at 1 person.
- [ ] Removing the focused row clears focus. Stepping 20 → 1 with Person 20 focused doesn't crash.
- [ ] Announcements follow §4.1: nothing is announced while typing.
- [ ] Rows insert and remove with the spring (none under RM).
- [ ] Equal mode renders as before, apart from the toggle and the 44 pt stepper row.
- [ ] `#Preview`s with 1, 3, and 20 people, in light and dark.

### 2A-12 Keyboard focus flow

- [ ] One `@FocusState` and one keyboard toolbar, both in `CalculatorView`. `BillInputView` has no toolbar. There's exactly one Done button for any focused field.
- [ ] Equal mode shows `[Spacer, Done]`, as today. Custom mode shows `[∧, ∨, Spacer, Done]`, with the order bill → Person 1 → … → Person N and the ends disabled.
- [ ] **At every text size from default to AX5**, on iPhone SE (3rd generation) and iPhone 16, in portrait and landscape: after any focus change, the focused **field box** is fully visible between the top of the screen and the pinned status card. The scroll `.id` is on the field box, not the row.
- [ ] Switching to Equal while a person field is focused dismisses the keyboard. The bill field's behavior is otherwise unchanged.
- [ ] `BillInputView` has previews through a wrapper with a local `@FocusState`, in light and dark.

### 2A-13 `ResultsCardView`

- [ ] The Equal-mode card is unchanged at default text size with Reduce Motion off.
- [ ] Custom with 2–20 people in S5 shows Tip, Total, "Each person pays", then Person 1…N from `personShares`. Per Person ↑ adds "Extra from rounding up" last. Values match §4.7's worked example.
- [ ] Custom with 1 person in S5 equals the Equal-mode 1-person card.
- [ ] Custom in S1a–S4 shows Tip, Total, and the inline status (plus the caption for S2–S4), and no per-person amounts.
- [ ] `BreakdownRow` stacks at AX sizes. Its values are one line and scale down (never wrap mid-number), and they crossfade under RM. The stagger has no offset or delay under RM.
- [ ] VoiceOver values match §4.7.
- [ ] `#Preview`s per §4.7 (including S1a and S2), and `BreakdownRow` in light, dark, and AX5.

---

## 7. Out of scope

- **Excluded by the product decisions:** percentage or share splits (Q1); names or contacts (Q3); persisting the mode or amounts (Q4).
- **Deliberately left out of this phase:**
  - Item-by-item receipt assignment.
  - A "use the rows' sum as the bill" helper.
  - Tapping the status card to jump to the problem row.
  - A total inside the pinned card.
  - An extra-from-rounding line in Equal mode.
  - A haptic on reaching balance.
  - Undo for "Clear amounts" (a confirmation is used instead).
  - Row-by-row VoiceOver navigation inside the results card.
  - Special iPad or landscape layouts beyond the pinned-card rule (E17).
- **Backlog candidates:**
  - Move `TipPresetButton`, `RoundingPill`, and `SplitModeToggle` to `.accessibilityAddTraits(.isSelected)`, the way the system segmented control reports selection (round-1 N4, optional).
  - Move the selected tip and rounding chips' text to `bbTealText` once it's approved.
  - Tip chips and rounding pills are ≈ 38 pt tall.
  - The stepper's VoiceOver says "1 people".
  - `BillInputView` has no invalid state for rejected text; S1b covers it only in Custom mode (see the TASKS.md Backlog).
  - `ARCHITECTURE.md` omits `RoundingSelectorView`.

---

## 8. Review history

**Round 1: design-reviewer Mode A, 2026-09-25. CHANGES REQUESTED.**

- **[B1]** The pinned status card had no Dynamic Type rule; at AX5 it could cover the field being typed in.
  - **Resolved:** the `.pinned` style is capped at AX1, `.lineLimit(2)` (1 in landscape), with the Large Content Viewer, while the inline card status scales fully (§4.6). §4.1 adds the height budget.
  - The scroll `.id` moved to `fieldBox`.
  - The 2A-12 AC is restated for every text size and orientation (§6).
- **[B2]** The clear button's fixed 44×44 frame overflowed at AX sizes.
  - **Resolved:** the slot and button use `minWidth`/`minHeight` of `AppSpacing.minTapTarget`, and the trailing padding while focused is `AppSpacing.xs` (§4.5).
- **[B3]** The 50/50 row split left too little width for amounts, so they wrapped mid-number.
  - **Resolved:** the label column is sized by hidden "Person 20" and caption views, so fields stay aligned.
  - Rows stack from `.xxLarge` up.
  - Previews are one line with `AppTypography.amountMinimumScale` and a stated tail-truncation fallback.
  - §4.5 has a width-check table, and the requested KES / `.xxxLarge` / 375 pt preview was added.
  - Captions were shortened ("Splits the rest", "Invalid amount").
- **Non-blocking, all applied:**
  - N2: rationale corrected (§2.1, §3.1b).
  - N3: full impact table plus the PM's "previews in every state" rule (§3.1).
  - N4: chip content shape (the `.isSelected` trait is in the backlog).
  - N5: tap-to-focus, `titleVisibility: .visible`, and stepper frames inside the labels, with the ACs restated.
  - N6: debounced announcements, one "splits the rest" phrase, and the Custom hint fixed.
  - N7: §5 claim corrected, and the AccentColor developer note added.
  - N8: `AppTypography.amountField`.
  - N9: previews added.
  - N10: S1b "Check the bill amount".
- **Human decisions:** automatic rows approved; Tip and Total stay on the card while not balanced.
