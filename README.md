# Coffee Shop

Coffee Shop is a Flutter application that showcases a polished mobile ordering experience for a boutique café. It demonstrates how to combine Supabase for remote persistence with Hive for offline caching, while keeping UI state lean with GetX controllers.

## Features

- Home tab with hero banner and curated drink grid sourced from Unsplash-ready sample data
- Menu browser and product detail flow with add-to-cart interactions
- Local cart storage powered by Hive boxes, synced to Supabase on checkout
- Search tab with live filtering and deep links into the detail screen
- Theme toggle persisted with `shared_preferences` for light and dark experiences
- Modular routing, bindings, and controllers built on GetX for maintainable navigation

## Tech Stack

- Flutter 3.10+
- GetX for routing, dependency injection, and reactivity
- Hive and `hive_flutter` for on-device cart persistence
- Supabase (Postgres + storage) for backend-as-a-service data sync
- `google_fonts` and custom theme palette for consistent branding
- `flutter_dotenv` for environment-aware configuration

## Project Structure

- `lib/app/data` – sample product catalog definitions
- `lib/app/models` – domain models (`Product`, `CartItem`) with Hive adapters
- `lib/app/modules` – feature folders (home, menu, search, cart, account, detail)
- `lib/app/routes` – centralized route table and path constants
- `lib/app/theme` – light/dark theme definitions and GetX theme controller
- `lib/app/widgets` – reusable UI components such as the product card and bottom nav

## Prerequisites

- Flutter SDK 3.10 or newer (`flutter --version`)
- Dart SDK bundled with Flutter
- A Supabase project with a `cart` table containing columns:
  - `title` (text)
  - `price` (numeric)
  - `image_url` (text)
  - `quantity` (int4)

## Environment Setup

Create a `.env` file at the project root (the repository already whitelists it as an asset) with your Supabase credentials:

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=public-anon-key
```


## Running Locally

1. Install dependencies:
	```powershell
	flutter pub get
	```
2. Generate Hive adapters if you update model annotations:
	```powershell
	flutter pub run build_runner build --delete-conflicting-outputs
	```
3. Launch the app on a connected device or emulator:
	```powershell
	flutter run
	```

## Testing

Run the default widget tests or add your own scenarios under `test/`:

```powershell
flutter test
```

## Troubleshooting

- Verify the Supabase URL/key when checkout sync fails; console logs surface HTTP errors from `supabase_flutter`.
- Hive boxes require initialization before use; ensure `main.dart` runs `Hive.initFlutter()` and registers adapters prior to opening boxes.
- For hot reload theme inconsistencies, clear the stored preference via the device settings or remove the app to reset `shared_preferences`.

## Roadmap Ideas

- Replace sample catalog data with a Supabase-backed product list
- Implement quantity adjustments and price totals in the cart footer
- Add authentication to tie carts to individual Supabase users
- Capture order history and status updates via real-time Supabase channels
