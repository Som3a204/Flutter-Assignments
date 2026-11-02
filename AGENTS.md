# AGENTS.md

Flutter e-commerce app (Flutter 3.47 / Dart SDK `^3.13`). Feature-first MVVM:
`data/{models,datasources,repositories}` → `presentation/{view_models,views,widgets}`.
State: `flutter_bloc` Cubit. DI: `get_it`. No codegen / `build_runner`.

## Commands
- `flutter pub get` — after any `pubspec.yaml` change.
- `flutter analyze` — target 0 errors. ~20 pre-existing **info** lints
  (`prefer_initializing_formals`) in `core/responsive/*` are expected; do not treat as regressions.
- `flutter test` — full suite.
- Single file: `flutter test test/core/network/dio_client_test.dart`
- Single test: `flutter test --plain-name "part of test name"`

## Architecture rules (verified — follow these)
- All HTTP goes through `DioClient` (`lib/core/network/dio_client.dart`). Datasources must not
  use raw `Dio`. `DioClient` converts every `DioException` into `ApiException` — catch
  `ApiException` (from `core/network/api_exceptions.dart`), never `DioException`.
- Per-feature flow: `XApiDatasource` → `XRepository` (abstract) + `XRepositoryImpl` →
  `XCubit` + sealed `XState` → view via `BlocProvider`/`BlocBuilder`. Auth uses
  `LoginService`/`AuthRepository`; products use `ProductsApiDatasource`/`ProductsRepository`.
- Endpoints live in `lib/core/network/api_endpoints.dart` (baseUrl `dummyjson.com`).
  `lib/core/constant/endpoind.dart` is a stale duplicate — edit `api_endpoints.dart`.
- DI: `configureDependencies()` in `lib/core/services/service_locator.dart`. `main()` must
  `await` it after `WidgetsFlutterBinding.ensureInitialized()`. Resolve with `getIt<X>()`.
  Repositories/datasources are `lazySingleton`; Cubits are `factory` (fresh state per view).
- `lib/app_steps.dart` is scratch planning notes, not runtime code.

## UI conventions
- Use responsive helpers from `core/responsive/responsive_context.dart`, not raw
  `MediaQuery`/`LayoutBuilder`: `context.responsive(mobile:…, tablet:…, desktop:…)`,
  `context.spacing.*`, `context.textStyles.*`.
- Theme tokens are in `core/theme/` (`app_colors.dart`, `app_spacing.dart` incl. `AppRadius`,
  `app_text_styles.dart`). Reuse shared `core/widgets/` (`AppButton`, `AppTextField`).
- `AppColors` has no `error` token — use `AppColors.discount` for negative/out-of-stock text.

## Navigation (go_router)
- Routes live in `lib/core/router/app_router.dart`; paths in `app_routes.dart`. Never use
  `Navigator.push(MaterialPageRoute(...))` for screens: `context.push(AppRoutes.xPath(id))`
  to drill in, `context.go(...)` to switch tabs / reset the stack, `context.pop()` to go back
  (`context.popOrGoHome()` when the screen may be opened directly). Dialogs and bottom sheets
  still use `Navigator.of(ctx).pop`.
- Auth is routing state: `AuthNotifier` (registered in `getIt`) -> `markLoggedIn()` after login,
  `markLoggedOut()` on logout / `DioClient.onUnauthorized`. The router `redirect` does the rest;
  views never navigate to/from login themselves.
- Bottom tabs (Home, Explore, Cart, Offer, Account) are a `StatefulShellRoute`; the branch order
  must match `AppBottomNavBar`. Screens that must hide the bar set `parentNavigatorKey`.
- `extra` is memory-only (lost on web refresh): pass ids in the path and guard routes that need
  `extra` with a `redirect`.

## Auth / tokens
- Tokens are cached in `shared_preferences` via `SharedPrefsTokenStorage` (the registered
  `TokenStorage`). `AuthInterceptor` injects `Bearer` from the cache, refreshes on `401`, and
  writes new tokens back to the cache.
- `requiresAuth` defaults to `true` per request; pass `requiresAuth: false` for public
  endpoints (e.g. login).

## Tests
- `test/core/network/dio_client_test.dart` covers `TokenStorage`, `AuthInterceptor`,
  `DioClient`, and `ApiException`. `MyApp` requires a `GoRouter`: build one with
  `createRouter(AuthNotifier())` (a fresh `AuthNotifier` is logged out).
- Widget tests build `MyApp` directly and do **not** call `configureDependencies()`. Any widget
  that resolves a `getIt` service (e.g. `LoginView`) needs a configured locator or an injected
  fake, or the test will throw on first use.

## Ratings & reviews
- The Ratings screen merges two sources: customer reviews that ship with the product
  (`ProductsRepository.getProductById(...).reviews`, read-only, fetched once per screen by
  `RatingsCubit`) and the user's own reviews (local SQLite, editable). API reviews are listed
  first; the average and count cover both. A failed API fetch still shows the local reviews.
