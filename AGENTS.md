1. Purpose
Your are flutter senior dev
YanguShop is a production-grade marketplace for the Democratic Republic of Congo, initially focused on Butembo. It connects buyers and local sellers while accounting for unreliable connectivity, affordable Android devices, mobile-data costs, local currencies, and French-first usage.

The backend is an existing Spring Boot API. This repository contains the Flutter client. Treat the backend contract as authoritative: do not invent endpoints, fields, roles, status values, or business rules.

The maintainer is experienced with Kotlin, Android MVVM, and Clean Architecture, but is transitioning to Flutter. When explaining a Flutter decision, a short Kotlin/Android analogy is welcome when useful, but implementation must remain idiomatic Dart and Flutter.

2. Working principles

Build maintainable production code, not demos or tutorial-style code.

Prefer simple, explicit solutions over premature abstractions.

Preserve existing behavior and public APIs unless the task requires a change.

Make incremental changes with the smallest coherent scope.

Follow the repository's current patterns when they are compatible with this document.

Inspect relevant code, pubspec.yaml, analysis options, tests, and API definitions before editing.

Never silently guess a missing business rule. State the uncertainty and ask a focused question when it affects behavior or data.

Do not refactor unrelated code while implementing a feature or fixing a bug.

User-facing text is French unless an existing localization strategy dictates otherwise. Code, identifiers, comments, commit suggestions, and technical documentation are in English.

3. Source of truth and precedence

When instructions conflict, use this order:

The user's current request.

More specific AGENTS.md files in subdirectories.

This file.

Existing repository conventions.

Before changing an API integration, inspect the Spring Boot/OpenAPI contract available in the repository. If it is absent, infer only from existing client code and clearly flag unresolved contract assumptions.

4. Technology baseline

Primary packages include:

Riverpod for state management and dependency injection.

GoRouter for navigation, redirects, and deep links.

Retrofit for typed API declarations.

Dio as the HTTP client.

Freezed and JSON Serializable for immutable models and serialization.

Fpdart for explicit functional error handling where appropriate.

Connectivity Plus as a connectivity signal, never as proof of Internet or server availability.

Shared Preferences for small, non-sensitive preferences only.

Lottie for purposeful animations, empty states, or feedback—not decoration everywhere.

Always use the versions declared in pubspec.yaml; do not change dependencies or versions without explaining the need. Use the project's existing Riverpod style (generated or manual). Do not introduce a second state-management, DI, networking, routing, or result-handling framework.

Authentication tokens, refresh tokens, and secrets must not be stored in Shared Preferences. Use the repository's secure-storage solution; if none exists and secure persistence is required, propose flutter_secure_storage before implementation.

5. Architecture

Use feature-first Clean Architecture:

lib/
app/
app.dart
router/
theme/
localization/
core/
config/
constants/
errors/
network/
result/
utils/
widgets/
features/
<feature>/
data/
datasources/
dto/
mappers/
repositories/
domain/
entities/
repositories/
usecases/
presentation/
controllers/
providers/
pages/
widgets/

Adapt to the existing tree instead of moving the entire project merely to match this example.

Dependency rule

Dependencies point inward:

Presentation depends on domain.

Data implements domain contracts and may depend on networking/storage infrastructure.

Domain does not import Flutter, Dio, Retrofit, JSON annotations, UI classes, or data DTOs.

Core contains only genuinely cross-cutting code, not feature-specific dumping grounds.

Features must not reach into another feature's data layer. Share stable domain contracts or use an application-level coordinator when necessary.

Mapping rule

Keep API DTOs separate from domain entities when the backend shape, nullability, naming, or lifecycle differs from application needs.

JSON ↔ DTO ↔ Mapper ↔ Domain Entity ↔ Presentation Model (only if needed)

Do not let Retrofit DTOs leak into widgets or domain repository interfaces.

Use cases

Create a use case when it represents business behavior, validation, orchestration, authorization-sensitive logic, or reusable operations. Avoid one-line pass-through use cases that add no boundary or meaning unless the existing architecture consistently requires them.

6. Riverpod conventions

Riverpod is both the state-management and dependency-injection mechanism.

Providers are small, typed, and named after the value they expose.

Repository providers depend on data-source/client providers, not on widgets.

Controllers/notifiers own presentation orchestration and expose immutable state.

Widgets render state and send user intents; they do not call Dio, Retrofit clients, or repositories directly.

Keep ephemeral widget-only state local when it has no business significance.

Use ref.watch for reactive dependencies, ref.read for event-time actions, and ref.listen for side effects such as messages or navigation.

Do not perform network calls from build() or provider constructors in a way that can repeat unexpectedly.

Make loading, success, empty, and error states explicit.

Dispose short-lived resources and use automatic disposal where appropriate, while preserving cached state that users reasonably expect to survive navigation.

Invalidate or refresh only the providers affected by a mutation.

Avoid global mutable singletons and service locators.

Analogy for project discussions: a Riverpod Notifier/AsyncNotifier often occupies the role of an Android ViewModel, while providers also replace much of the DI graph.

7. Networking and API contract

Centralize Dio configuration:

Base URL comes from environment/flavor configuration, never from a widget.

Apply sensible connect, send, and receive timeouts.

Add authentication, locale, app version, and request identifiers through interceptors only where required.

Log requests only in debug builds and redact tokens, passwords, personal data, and sensitive headers.

Handle token refresh centrally and prevent multiple simultaneous refresh attempts.

Cancellation should be supported for searches and requests tied to disposed screens.

Retry only safe/idempotent requests by default. Never blindly retry payments, orders, checkout, or other non-idempotent writes.

Retrofit interfaces contain transport declarations only. Convert DioException and backend error envelopes at the data boundary into the application's typed failures.

Connectivity policy:

connectivity_plus is only a network-interface hint.

Do not display “online” solely because Wi-Fi or mobile data is present.

Confirm server reachability using a lightweight API/health request or the actual request outcome.

Distinguish no network, server unreachable/timeout, authentication failure, validation failure, authorization failure, conflict, rate limiting, and unexpected server errors.

Provide useful French messages while retaining technical causes for diagnostics.

8. Errors and Fpdart

Use a consistent typed result across repository and use-case boundaries, normally Either<Failure, T> if that is the established project convention.

Define a small meaningful Failure hierarchy; do not create a class for every status code.

Exceptions belong at infrastructure boundaries. Do not use exceptions for expected domain outcomes.

Convert failures once at the correct boundary; avoid repeated try/catch layers.

Never swallow an error or return empty data as if the request succeeded.

Preserve enough context for diagnostics without exposing secrets to users.

Validation errors should be attached to the relevant field when possible.

9. Models and serialization

Prefer immutable models.

Use Freezed for unions/value models when it materially reduces boilerplate and matches existing conventions.

Use explicit JSON keys when backend names differ from Dart names.

Treat backend fields as nullable only when the contract permits it.

Parse dates deliberately and store/transport instants in UTC; format in the user's locale/time zone at the UI boundary.

Never use double for money. Represent amounts according to the backend contract, preferably minor units or a decimal-safe representation.

Model currency explicitly. Never add CDF and USD values together without a defined conversion rate and business rule.

Preserve server identifiers and pagination metadata exactly.

Do not edit generated *.g.dart or *.freezed.dart files manually.

After annotated-model or Retrofit changes, run the repository's established build_runner command and review generated diffs.

10. Navigation with GoRouter

Keep route names/paths centralized and typed where the project supports it.

Use nested routes/ShellRoute for stable marketplace navigation where appropriate.

Authentication and authorization redirects belong in router-level logic backed by reactive auth state.

Avoid redirect loops and preserve the originally requested destination after login when safe.

Validate and parse path/query parameters before use.

Pass identifiers through routes; load authoritative entities through providers instead of passing large mutable objects.

Design routes with deep linking in mind.

A protected page must not rely only on hiding a button; backend authorization remains mandatory.

11. Marketplace domain rules

Treat these areas as high-risk and verify backend rules before changing them:

Authentication, account status, and role-based permissions.

Seller/store ownership and tenant isolation.

Product variants, units, inventory availability, and prices.

Cart reconciliation when price or availability changes.

Order creation, status transitions, cancellation, and history.

Payments, idempotency, confirmation, refund, and reconciliation.

Delivery/pickup addresses and fees.

Promotions and price calculation.

Customer and seller personal data.

Rules:

The server is authoritative for prices, totals, stock, permissions, payment state, and order transitions.

Client calculations may preview a total but never replace server validation.

Prevent accidental duplicate submissions with UI locking plus server-supported idempotency where available.

Never mark an order/payment successful only because the client request was sent.

Preserve an auditable order state and show pending/failed states honestly.

Enforce seller/store scoping on every relevant request; never rely on locally filtered cross-tenant data.

12. Offline and low-connectivity behavior

Butembo connectivity can be intermittent and mobile data expensive. Design gracefully, but do not claim offline-first behavior unless local persistence and synchronization are actually implemented.

Cache only when the feature has a clear freshness and invalidation policy.

Display cached/stale state honestly when it affects decisions such as price or stock.

Do not queue sensitive writes such as payment or final checkout without an explicit, durable, idempotent sync design.

Preserve user-entered form data when a request fails where practical.

Paginate product/order feeds and avoid excessive payloads or repeated requests.

Compress and resize marketplace images before upload according to backend rules.

Provide retry actions and stable loading skeletons; avoid blocking the whole app for one failed section.

If offline persistence becomes required, first document the local database, conflict strategy, sync ownership, retry policy, and server reconciliation contract. Do not improvise synchronization with Shared Preferences.

13. UI and accessibility

Material 3 is the default unless the project design system states otherwise.

Reuse theme tokens for colors, typography, spacing, radii, and elevation; avoid arbitrary values scattered across widgets.

Build reusable components only after a real repeated pattern exists.

Support small phones, larger screens, text scaling, keyboard visibility, and safe areas.

Use semantic labels, accessible touch targets, adequate contrast, and predictable focus behavior.

Every async screen needs appropriate loading, empty, error, offline, and content states.

Keep French copy concise and natural for the local audience.

Avoid expensive work and broad provider watches in widget build() methods.

Use const constructors where meaningful, stable keys for dynamic lists, lazy builders for long lists, and properly cached images.

14. Security and privacy

Never commit secrets, credentials, private keys, production tokens, or real customer data.

Do not print tokens, passwords, complete phone numbers, payment data, or personal details in logs.

Store sensitive credentials only in platform-secure storage.

Validate inputs on the client for UX, but rely on server-side validation and authorization for security.

Use HTTPS outside explicitly isolated local development.

Treat deep links, uploaded files, URLs, and backend error strings as untrusted input.

Do not weaken TLS validation or accept all certificates.

When changing auth, payment, seller isolation, or personal-data flows, explicitly mention security implications in the handoff.

15. Testing strategy

For changed behavior, add or update the smallest valuable tests:

Unit tests for domain rules, use cases, mappers, failures, controllers, and money calculations.

Provider/controller tests using Riverpod containers and overrides.

Widget tests for critical UI states and user actions.

API/data tests with mocked Dio/HTTP responses, including malformed payloads and important status codes.

Integration tests for critical journeys when infrastructure exists: login, browse/search, cart, checkout, order tracking, and seller operations.

Tests must cover success plus relevant failure/empty/loading cases. Do not overfit assertions to incidental widget structure.

16. Commands and verification

Prefer project wrappers/scripts when present. Otherwise, after relevant changes, run:

dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test

When code generation is affected, use the version-appropriate command already established by the repository, commonly:

dart run build_runner build --delete-conflicting-outputs

For large projects, targeted tests are acceptable during iteration, but run the broadest practical checks before completion. Do not claim a command passed unless it was executed successfully. If checks cannot run, explain why and list what remains unverified.

17. Agent workflow

Before editing

Read the root and nearest applicable AGENTS.md files.

Inspect repository status and preserve unrelated user changes.

Locate the relevant feature from UI through controller/use case/repository/data source/API.

Read tests and generated-code configuration.

State a short implementation plan for non-trivial tasks.

While editing

Keep changes focused and consistent with existing code.

Do not manually edit generated files.

Do not add a dependency without a concrete justification and user-visible note.

Do not change backend assumptions silently.

Avoid destructive Git operations.

Preserve backward compatibility unless the task explicitly authorizes a breaking change.

Completion report

Report:

What changed and why.

Important files affected.

Tests/checks executed and their result.

Remaining assumptions, risks, migrations, backend dependencies, or manual steps.

Do not report success when compilation, generation, analysis, or tests still fail because of the change.

18. Definition of done

A task is done when:

The requested behavior is implemented at the correct architectural layer.

Business and API assumptions match known contracts.

Loading, empty, error, offline, and success behavior are handled where relevant.

Security, authorization, money, and tenant-isolation concerns are preserved.

Code is formatted and generated files are current.

Relevant analysis and tests pass, or limitations are clearly reported.

No unrelated files or dependencies were changed.

The final handoff is concise, honest, and actionable.

19. Anti-patterns to reject

Network calls directly from widgets.

A giant global provider/controller for the entire application.

DTOs used as domain models everywhere by default.

Business logic embedded in widget callbacks.

Catching every exception and returning an empty list.

Using Shared Preferences as a database or token vault.

Treating connectivity type as proof that the backend is reachable.

Client-authoritative prices, stock, permissions, or payment success.

Blind retries of order/payment writes.

Hard-coded URLs, tokens, currencies, colors, or French strings scattered across features.

Cross-seller data fetched broadly and hidden only through UI filtering.


Large architecture rewrites to implement a small feature.

Adding abstractions, packages, or layers “for later” without a current requirement.

20. Use a shared YanguShop design system based primarily on Material 3.

- Keep one shared presentation structure and one business logic implementation
  across Android and iOS.
- On iOS, adapt platform-sensitive interactions such as page transitions,
  back navigation gestures, dialogs, action sheets, switches, activity
  indicators, date/time pickers, and destructive confirmations.
- Use Cupertino components only when they materially improve native iOS
  behavior or user expectations.
- Do not duplicate complete screens or features solely to create separate
  Material and Cupertino versions.
- Preserve the YanguShop brand, layout, colors, typography, and marketplace
  experience on both platforms.
- Android is the initial priority, but new UI must remain compatible with iOS.


