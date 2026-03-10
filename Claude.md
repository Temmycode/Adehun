# CLAUDE.md — Adehun Escrow Mobile App

## PROJECT OVERVIEW

Adehun is a modern escrow mobile application built with **Flutter**. It facilitates secure transactions between two parties — a Depositor (who pays for a service) and a Beneficiary (who delivers the service). Funds are held in escrow and released only when agreed-upon conditions are met and approved.

This is a consumer-facing fintech app. It should feel fresh, modern, lively, and trustworthy — not corporate or boring.

---

## PROJECT STRUCTURE

- `designs/` — Contains 5 concept design images that define the visual direction
- `assets/illustrations/` — Contains illustration images to be used throughout the app
- `Adehun Requirement Document.md` — Backend-originated requirements document defining escrow logic and flow

---

## DESIGN DIRECTION & PHILOSOPHY

The design should feel like a **modern fintech app** — clean, playful, lively, and fresh. Not overly corporate. Not cluttered. Think of the energy of apps like Chipper Cash, Kuda, or Piggyvest — but with its own identity.

### Design Reference Files (in `designs/`)

Read and visually analyze ALL of these before generating any screens:

1. **`concept 1.png`** — Escrow-specific layout inspiration. This shows what a dedicated escrow app could look like. Borrow ideas for the **home screen** structure — it has useful escrow-centric elements that should be adapted to feel fresh and modern.

2. **`concept 2.png`** — Card-based UI and wallet funding. Take inspiration from the **card component design** (a standard in modern fintech). Also note the **fund wallet** flow — the Depositor needs to be able to fund their wallet to send money into escrow. Use this as reference for wallet and card UI patterns.

3. **`concept 3.png`** — Playfulness, liveliness, and color. This design feels **alive and fresh** without being overwhelming. It has that modern fintech vibe. Use its **color palette** as a primary reference for the app's color scheme. Its **onboarding screens** should complement the onboarding flow from `onboarding concept 1.png`.

4. **`onboarding concept 1.png`** — Primary onboarding flow reference. The structure and flow of the onboarding screens should follow this concept closely. Combine it with the color palette and energy from `concept 3.png` to create the final onboarding experience.

5. **`combined concept (onboarding).png`** — Color and card style reference. The colors in this design are appealing — borrow from them. The card components here have a slightly **cartoonish, line-heavy** aesthetic. Take inspiration from this card style and color choices to blend into the overall design system.

### Design Principles

- **Fresh & Modern**: The app should feel current — like a 2025 fintech app, not a 2019 one
- **Playful but Trustworthy**: Escrow involves money and trust. The design should be lively and inviting but still convey reliability and security
- **Card-Based UI**: Use card components extensively — for agreements, conditions, wallet info, transaction history
- **Vibrant Color Palette**: Pull colors primarily from `concept 3.png` and `combined concept (onboarding).png` — lively, not muted
- **Generous Use of Illustrations**: Use images from `assets/illustrations/` throughout the app — onboarding, empty states, success screens, etc.
- **Clean Whitespace**: Don't overcrowd screens. Let the design breathe
- **Line-Heavy Card Accents**: Borrow the slightly cartoonish, outlined card style from `combined concept (onboarding).png` where it fits

---

## CORE CONCEPTS

- **Depositor** — The person receiving a service. They deposit money into escrow.
- **Beneficiary** — The person delivering the service. They receive the funds once conditions are met.
- **Conditions** — Requirements that must be fulfilled before funds are released.
- **Assets** — Proof files/media uploaded to demonstrate a condition has been met.

---

## ESCROW STATUS FLOW

```
DRAFT
→ PENDING_ACCEPTANCE
→ ACTIVE (funded)
→ CONDITIONS_IN_PROGRESS
→ CONDITIONS_MET
→ COMPLETED (funds released)
→ DISPUTED
→ CANCELLED
→ REFUNDED
```

Each status should have a distinct visual treatment (color, icon, badge) so users can immediately understand the state of their agreement.

---

## HOW ESCROW WORKS (UI Context Only — Do NOT Implement Backend Logic)

This describes the user journey so you understand what each screen should show. **Do not implement any actual business logic, API calls, or backend integration.** Use hardcoded dummy/mock data to represent these states visually.

1. Anyone can initiate an Escrow agreement
2. The other party accepts → work begins
3. Funds are deposited by the Depositor
4. Agreement is marked as ACTIVE
5. Conditions are created for the agreement
6. Conditions are marked as MET only after the other party reviews and approves
7. A condition can have multiple assets (proof of work)
8. Assets can be individually approved or rejected
9. If all conditions are met → funds are released to the Beneficiary

---

## TIER SYSTEM

- **Free Tier**: Users can have only ONE active agreement at a time
- **Premium Tier**: Users can have multiple active agreements simultaneously

Surface this naturally in the UX:
- When a free user tries to create a second agreement, show an upgrade prompt/paywall
- Include a subscription/upgrade screen accessible from settings or the blocked action

---

---

## EXECUTION PLAN — TWO PHASES

This project is built in **two strict phases**. Complete Phase 1 fully before starting Phase 2. Do NOT mix them.

---

### 🔴 PHASE 1: UI SCREENS (THE MOST IMPORTANT PHASE)

**This is the priority. The entire focus of this phase is building beautiful, pixel-perfect, polished UI screens.** Every screen must look incredible and match the design concepts. No shortcuts on design quality.

**Rules for Phase 1:**
- **NO backend logic, NO API calls, NO authentication SDKs**
- **NO state management setup** (no Riverpod, no providers — just simple `StatefulWidget` + `setState` for UI interactions)
- **Use hardcoded mock/dummy data** everywhere (fake names, fake balances, fake agreements, fake transactions)
- **Use `go_router`** for navigation between screens
- Focus 100% on making every screen look **stunning**
- Visually reference the design files in `designs/` before building each screen
- Use illustrations from `assets/illustrations/` generously

**Phase 1 Checklist — Complete every screen below:**

#### Onboarding & Authentication
- [ ] **Splash Screen** — App logo/branding, Adehun identity, smooth transition
- [ ] **Onboarding Screen 1** — What is Adehun? Explain escrow simply. Use illustration. Follow `onboarding concept 1.png` flow with `concept 3.png` colors
- [ ] **Onboarding Screen 2** — How it protects both parties. Use illustration. Same style direction
- [ ] **Onboarding Screen 3** — Ready to get started. Use illustration. CTA to sign in
- [ ] **Auth/Welcome Screen** — Clean screen with Adehun branding, illustration, and a single Google Sign-In button. No email/password fields. Beautiful and inviting
- [ ] **Profile Completion Screen** — First-time user only. Collect display name and phone number. Minimal, clean, friendly

#### Main App (Bottom Navigation: Home, Wallet, Agreements, Profile)
- [ ] **Home Screen** — Main dashboard. Wallet balance summary card, active agreement(s) preview, quick action buttons (create agreement, fund wallet). Borrow structure from `concept 1.png`, style from other concepts. Card-based layout
- [ ] **Wallet Screen** — Wallet balance card (reference `concept 2.png` card style), fund wallet button/flow, transaction history list. Clean and financial
- [ ] **Fund Wallet Screen/Modal** — Input amount, select payment method (UI only, mock). Confirmation step
- [ ] **Agreements List Screen** — List of all agreements with status badges (color-coded per escrow state). Empty state with illustration if no agreements exist
- [ ] **Create Agreement Screen** — Step-by-step form: title, description, amount, invite other party (by email/phone), define conditions. Multi-step or single scrollable form — whichever looks cleaner
- [ ] **Agreement Detail Screen** — Full agreement info: parties involved, amount, current status (prominent visual badge), list of conditions with their statuses, action buttons (approve, reject, dispute, etc. depending on state). This screen must handle ALL escrow states visually — show different UI states for DRAFT, PENDING_ACCEPTANCE, ACTIVE, CONDITIONS_IN_PROGRESS, CONDITIONS_MET, COMPLETED, DISPUTED, CANCELLED, REFUNDED
- [ ] **Condition Detail View** — Expanded view of a single condition: status, description, list of uploaded assets with thumbnails, approve/reject buttons for each asset
- [ ] **Upload Assets Screen** — Upload proof (images, documents) for a specific condition. File picker UI, preview of selected files, submit button
- [ ] **Notifications Screen** — List of notifications: agreement invitations, condition updates, approval/rejection alerts, payment confirmations, reminders. Each notification type should have a distinct icon/style
- [ ] **Profile/Settings Screen** — User info (name, email, avatar), subscription tier display (Free/Premium), upgrade to premium button, app preferences, sign out button

#### Secondary/Modal Screens
- [ ] **Agreement Invitation Screen** — Received an escrow invite. Show agreement summary, accept/decline buttons. Clean and clear
- [ ] **Upgrade/Paywall Screen** — Shown when free user tries to create a second agreement. Explain premium benefits, pricing, CTA to upgrade. Use illustration
- [ ] **Success Screen — Agreement Created** — Celebratory screen with illustration, confirmation message, next steps
- [ ] **Success Screen — Funds Deposited** — Confirmation with animation/illustration
- [ ] **Success Screen — Conditions Met** — All conditions approved, funds ready to release
- [ ] **Success Screen — Funds Released** — Final completion. Celebration. Use illustration
- [ ] **Dispute Screen** — Raise a dispute on an agreement. Reason input, supporting evidence upload
- [ ] **Empty States** — For agreements list (no agreements yet), notifications (no notifications), transaction history (no transactions). Each with an illustration and a helpful message/CTA

**Phase 1 is COMPLETE only when every checkbox above has a corresponding polished, beautiful screen that runs without errors.**

---

### 🟡 PHASE 2: ARCHITECTURE & STATE MANAGEMENT SKELETON

**Only begin this phase after Phase 1 is 100% complete and all screens are verified.**

This phase restructures the codebase into **Flutter Clean Architecture** and sets up **Riverpod** state management as a skeleton — no actual backend integration, just the structural foundation.

#### Clean Architecture Restructure
- [ ] Reorganize `lib/` into clean architecture layers:
  ```
  lib/
  ├── core/
  │   ├── theme/          (app theme, colors, text styles — already created in Phase 1)
  │   ├── constants/      (app-wide constants, dummy data)
  │   ├── router/         (go_router configuration)
  │   └── utils/          (helpers, extensions)
  ├── features/
  │   ├── auth/
  │   │   ├── data/
  │   │   │   ├── datasources/    (empty — for future API integration)
  │   │   │   ├── models/         (data models with fromJson/toJson)
  │   │   │   └── repositories/   (repository implementations — return mock data for now)
  │   │   ├── domain/
  │   │   │   ├── entities/       (core business entities)
  │   │   │   ├── repositories/   (abstract repository contracts)
  │   │   │   └── usecases/       (use case classes — skeleton only)
  │   │   └── presentation/
  │   │       ├── screens/        (screens from Phase 1)
  │   │       ├── widgets/        (reusable widgets from Phase 1)
  │   │       └── providers/      (Riverpod providers — skeleton)
  │   ├── escrow/           (same structure as auth)
  │   ├── wallet/           (same structure as auth)
  │   ├── notifications/    (same structure as auth)
  │   └── profile/          (same structure as auth)
  └── main.dart
  ```
- [ ] Move all Phase 1 screens and widgets into their correct `features/*/presentation/` directories
- [ ] Ensure the app still runs perfectly after restructuring — no broken imports, no missing files

#### Riverpod Skeleton Setup
- [ ] Add `flutter_riverpod` to `pubspec.yaml`
- [ ] Wrap app in `ProviderScope` in `main.dart`
- [ ] Create **empty/skeleton providers** for each feature:
  - `authProvider` — skeleton, returns mock user data
  - `escrowProvider` — skeleton, returns mock agreements list
  - `walletProvider` — skeleton, returns mock balance and transactions
  - `notificationsProvider` — skeleton, returns mock notifications
- [ ] Create **entity classes** for core business objects:
  - `User` (name, email, avatar, tier)
  - `Agreement` (id, title, amount, status, depositor, beneficiary, conditions)
  - `Condition` (id, description, status, assets)
  - `Asset` (id, type, url, approval status)
  - `Transaction` (id, amount, type, date, status)
  - `Notification` (id, type, title, message, timestamp, read status)
- [ ] Create **abstract repository contracts** in domain layer (empty method signatures)
- [ ] Create **mock repository implementations** in data layer (return hardcoded data matching what Phase 1 screens already display)
- [ ] Create **use case skeletons** (classes with call methods that delegate to repositories)
- [ ] **Do NOT wire providers to screens yet** — screens continue using their hardcoded data from Phase 1. The providers and architecture exist as a ready-to-connect skeleton

**Phase 2 is COMPLETE when the app is fully restructured into clean architecture, Riverpod providers exist as skeletons, and the app runs exactly as it did at the end of Phase 1 — same beautiful UI, same mock data, zero regressions.**

---

## TECHNICAL GUIDELINES

### Flutter Specifics
- Use **Material 3** design system as the base
- Use **go_router** for navigation
- Use **Riverpod** for state management (Phase 2 only)
- Follow **Flutter Clean Architecture** (Phase 2 only — Phase 1 can use a flat `lib/screens/` + `lib/widgets/` structure)
- Use `assets/illustrations/` for all illustration images — reference them by proper asset path
- Register all asset directories in `pubspec.yaml`
- Use clean, well-structured Dart code with proper widget extraction (no mega-widgets)
- Name files using snake_case convention
- Bottom navigation bar for main sections (Home, Wallet, Agreements, Profile)

### Colors & Theming
- Define a custom `ThemeData` that reflects the vibrant color palette from the design concepts
- Use the theme consistently across all screens
- Light mode only for now

### Packages Allowed
- `go_router` — navigation (Phase 1)
- `flutter_riverpod` — state management (Phase 2 only)
- `google_fonts` — if needed for typography
- `flutter_svg` — if SVG illustrations are used
- UI-related packages only. **No backend packages** (no dio, http, firebase, etc.)

---

## IMPORTANT NOTES

- **Phase 1 is king.** The UI must be beautiful, polished, and complete before any architecture work begins. Do not rush screens to get to Phase 2.
- **Always visually reference the design files** in `designs/` before generating any screen. The designs are the source of truth for visual direction.
- **Use illustrations** from `assets/illustrations/` generously — onboarding, empty states, success moments, and decorative elements.
- **Screen by screen**: Build one screen at a time. Get each one right before moving to the next.
- **Mobile-first**: This is a mobile app. Every screen should be designed for phone-sized viewports.
- **Escrow status should be visually obvious**: Use colors, icons, and badges so users always know where their agreement stands at a glance.
- **Keep forms minimal**: Only ask for what's truly needed. This app should feel fast and frictionless.
- **The app name is Adehun**: Use this in branding, splash screens, and app bar where appropriate. "Adehun" means "agreement/covenant" — it carries weight and trust.
- **No backend packages**: Do not add packages for API calls, authentication SDKs, databases, or any backend integration. This is UI + architecture skeleton only.
- **Zero regressions between phases**: After Phase 2 restructuring, the app must look and run identically to Phase 1. If anything breaks, fix it before proceeding.