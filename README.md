# 💰 Tip Calculator

[![Build](https://github.com/israman30/Tip-Calculator/actions/workflows/build.yml/badge.svg)](https://github.com/israman30/Tip-Calculator/actions/workflows/build.yml)

Version 1.4

Tip Calculator is an iOS app for fast bill entry, tip math, splitting checks, and a lightweight view of your saved spending. The main screen is built in **UIKit** (card-style layout, scrollable content) with **SwiftUI** used for the save toast, SwiftUI previews, and the **WidgetKit** extension.

The focus is clarity and speed: large, right-aligned amounts, preset tip controls, optional fine-grained tipping, and local history with simple insights.

<p align="center">
<img src="/img/one.png" width="250"> <img src="/img/two.png" width="250"> <img src="/img/three.png" width="250"> <img src="/img/four.png" width="250">
<img src="/img/five.png" width="250"> <img src="/img/six.png" width="250">
</p>

## ✨ Core functionality

- **Real-time calculation** — Tip and total update as you type; invalid input clears to `$0.00` safely.
- **Preset tip percentages** — Segmented control for **10%, 15%, 20%, and 25%** with immediate recalculation.
- **Custom tip (0–30%)** — Double-tap the **total** to show or hide a slider for any whole percent in that range; the last custom value is **remembered** (UserDefaults).
- **Split bill** — UIStepper for **1–10 people**; per-person share updates with the bill, tip, and party size.
- **Haptic feedback** — Light impact when a valid calculation runs, **throttled** so typing does not buzz constantly.
- **Quick reset** — Clear all fields and reset the split stepper to one person.

## 🏠 Home screen & input

- **Scrollable layout** — Bill amount sits in a card-style area; tap outside the keyboard to dismiss it.
- **Voice input** — Microphone on the bill field uses the **Speech** framework for hands-free amount entry (with clear error handling when authorization or hardware is unavailable).
- **Categories** — Horizontal chips for **Restaurant**, **Bar**, **Delivery**, plus **user-defined custom tags** stored locally and reused when saving.

## 💾 Saved bills & data

- **Core Data** — Bills are persisted on device (amount, tip, total, metadata, date string, category/tag).
- **Saved Bills sheet** — Review history from **See all**; rows show saved breakdowns; **swipe to delete** updates the store.
- **Save affordance** — Prominent green **Save** control in the navigation bar; SwiftUI **toast** confirms a successful save.

## 📊 Spending insights

Open **Saved Bills** and tap **Insights** for a simple dashboard driven by `SpendingInsightsViewModel`:

- **Total spent this week / this month** (from saved bill totals)
- **Total tips given** — week and month side by side
- **Average tip %** across saved bills (weighted by bill input amounts)

Insights refresh when the screen appears and use the same saved bill dataset as the list.

## 📲 Widget, deep links & discovery

- **Home Screen & Lock Screen widget** — Small and medium layouts with tappable shortcuts for **10%, 15%, 20%,** and **25%** (medium also includes **Open app**). Taps use a custom URL scheme to open the app and, when applicable, **align the tip segment** with that percentage.
- **URL scheme** — `tipcalc://open` opens the app; `tipcalc://open?percent=<n>` applies quick launch when `n` is **10, 15, 20, or 25** (other values still open the app). Useful for widgets and Shortcuts.
- **Onboarding** — **How to Use** tips on first launch (sheet); the **info** button in the nav bar opens the same content anytime.

## ♿ Accessibility & localization

- **VoiceOver** — Labels and hints on nav actions, save, insights, dismiss controls, dictation, and key values.
- **String Catalog** — Copy is centralized in `Localizable.xcstrings` for localization.

## 🛠 Tech stack

| Area | Technology |
|------|------------|
| UI | UIKit (primary), SwiftUI (toast, previews, widget UI) |
| Architecture | MVVM (`CalculationsViewModel`, `SaveViewModel`, `SpendingInsightsViewModel`) |
| Persistence | Core Data |
| Speech | `Speech` / `AVFoundation` |
| Widgets | WidgetKit |
| Tests | XCTest |

## 🧪 Testing

Unit tests cover **tip math**, **split totals**, **persistence-related behavior**, **insight aggregation**, **deep link parsing**, **main handler flows**, and **onboarding flags**, so calculations and summaries stay predictable as the app evolves.

GitHub Actions runs a **CI workflow** (Xcode 15 on macOS) on pushes and pull requests to `main` (see `.github/workflows/build.yml`).

## 🎯 Design philosophy

- Financial clarity: strong type hierarchy and **right-aligned** money amounts.
- Low friction: presets first, optional slider for power users, quick save and history.
- Local-first: history and insights stay on device unless you add sync later.

## 🚀 Future improvements

Ideas that are not in the app today:

- iCloud or other sync
- Export (CSV / PDF)
- Biometric app lock
- Richer analytics beyond the current insight cards

**Note:** Custom tip control is already available via the **segment control** and the **0–30% slider**; deeper “preset management” could still be added (e.g. user-named favorites).

## 📌 Version & availability

Current version: **1.4**

Release history: early 2017, 2019, 2023, 2026

App Store: [Tip Calculator](https://itunes.apple.com/us/app/my-new-news/id1210234219?mt=8).

<p align="center">
© Copyright, Israel Manzo. All rights reserved.
</p>
