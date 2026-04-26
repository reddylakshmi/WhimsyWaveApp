# WhimsyWave

An iOS e-commerce app for home decor and furniture, built with SwiftUI and the Observation framework. Features an offline-first SQLite architecture, multi-region internationalization, and a clean feature-based design.

## Requirements

| Tool | Version |
|------|---------|
| Xcode | 16.0+ |
| iOS Deployment Target | 17.0+ |
| Swift | 5.9+ |

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/reddylakshmi/WhimsyWaveApp.git
cd WhimsyWaveApp
```

### 2. Open in Xcode

```bash
open WhimsyWaveApp.xcodeproj
```

There are no third-party dependencies or Swift packages — the project is self-contained.

### 3. Select a Scheme and Run

- Choose the **WhimsyWaveApp** scheme
- Select a simulator or physical device (iOS 17.0+)
- Press `Cmd + R` to build and run

The app runs with **bundled mock data by default**. On first launch, the data ingestion pipeline loads regionalized JSON into a local SQLite database — no backend or network needed.

## Project Structure

```
WhimsyWaveApp/
├── App/                        # App entry point, root view, AppReducer
├── Core/
│   ├── Configuration/          # Environment configs (xcconfig), constants
│   ├── Infrastructure/
│   │   ├── Analytics/          # Analytics client (mock + live)
│   │   ├── Cache/              # NSCache-backed image cache
│   │   ├── DeepLinks/          # URL scheme handling
│   │   ├── DI/                 # ServiceContainer (dependency injection)
│   │   ├── FeatureFlags/       # Local + remote feature flags
│   │   ├── Formatting/         # PriceFormatter (region-aware)
│   │   ├── Haptics/            # HapticFeedback utility
│   │   ├── Logging/            # Structured logging (os.Logger)
│   │   ├── Networking/         # NetworkManager, API endpoints
│   │   ├── PushNotifications/  # Push notification types
│   │   ├── Region/             # RegionManager (region switching)
│   │   ├── Validation/         # SHA-256 checksum validation
│   │   └── Workers/            # DataIngestionWorker, StorageCleanupWorker
│   └── Persistence/
│       ├── SQLite/             # SQLiteConnection, SQLiteStore, Schema, Mapper
│       ├── KeychainStore.swift
│       ├── PreferencesStore.swift
│       └── SwiftDataStore.swift
├── Data/
│   ├── Cloud/                  # CloudDataRepository (stub for future S3/CDN)
│   ├── DTOs/                   # Network response models
│   ├── Live/                   # Live repository implementations (API)
│   ├── Local/                  # BundledDataRepository (reads bundled JSON)
│   ├── Mappers/                # DTO-to-Domain model mappers
│   └── Mock/                   # Mock repositories and fixture data
├── DesignSystem/               # Colors, typography, spacing, reusable components
├── Domain/
│   ├── Models/                 # Core business models (Product, User, Cart, Region, etc.)
│   ├── Repositories/           # Repository protocols (interfaces)
│   └── UseCases/               # Business logic use cases
├── Features/                   # Feature modules
│   ├── AR/                     # AR product visualization
│   ├── Browse/                 # Category browsing and filtering
│   ├── Cart/                   # Shopping cart
│   ├── Checkout/               # Multi-step checkout (shipping, payment, review)
│   ├── Home/                   # Home feed with banners and product sections
│   ├── Notifications/          # Notification list
│   ├── Orders/                 # Order history and detail
│   ├── ProductDetail/          # Product detail with reviews
│   ├── Profile/                # User profile, addresses, payment methods, settings
│   ├── Search/                 # Product search with suggestions
│   └── Wishlist/               # Saved items
└── Resources/
    └── Assortments/            # Bundled JSON per region (US_EN, UK_EN, CA_EN, etc.)
```

## Architecture

### Pattern

Feature-based architecture with `@Observable` classes — no third-party state management (not TCA, not Redux). Each feature owns its state and business logic.

### Data Flow

```
Bundled JSON (or Cloud API)
        ↓
  DataRepository (resolves source)
        ↓
  DataIngestionWorker (actor, off-main-thread)
        ↓
  SQLiteStore (actor, WAL mode)
        ↓
  Mock/Live Repositories (read from SQLite)
        ↓
  Features / UI
```

### Navigation

Tab-based navigation (Home, Browse, Cart, Wishlist, Account) with sheet-based modals for product detail, checkout, search, notifications, orders, and login.

### Dependency Injection

`ServiceContainer` holds all service instances. Swap between mock and live at app launch:

```swift
// Default (mock with bundled data → SQLite)
ServiceContainer.current = .mock

// Live (cloud API → SQLite)
ServiceContainer.current = .live
```

`MockServiceProvider` delegates to `ServiceContainer.current`, so features reference a stable interface regardless of the active implementation.

## Offline-First Data Layer

The app uses a **local SQLite database** as the single source of truth for product catalog data. This enables instant reads, offline capability, and clean separation between data ingestion and UI consumption.

### How It Works

1. **On first launch**, `AppEntry` initializes the SQLite database and triggers data ingestion
2. **`DataIngestionWorker`** fetches an `AssortmentPayload` (products, categories, banners, home sections) from the `DataRepository`
3. The payload is atomically ingested into 5 SQLite tables via `INSERT OR REPLACE` in a transaction
4. **All repository reads** go through `SQLiteStore` — no in-memory mock arrays at runtime
5. **On region switch**, the database is wiped and re-ingested with the new region's data

### SQLite Details

| Aspect | Implementation |
|--------|---------------|
| API | Apple's built-in `sqlite3` C API (no third-party ORM) |
| Concurrency | Swift `actor` (`SQLiteStore`) serializes all DB access |
| Journal mode | WAL (Write-Ahead Logging) for concurrent reads |
| Tables | `products`, `categories`, `banners`, `home_sections`, `metadata` |
| Complex fields | JSON-serialized (images, specs, variants, category path) |

### Bundled Assortment Files

The `Resources/Assortments/` directory contains one JSON file per region-locale:

| File | Region |
|------|--------|
| `US_EN.json` | United States (English) |
| `UK_EN.json` | United Kingdom (English) |
| `CA_EN.json` | Canada (English) |
| `CA_FR.json` | Canada (French) |
| `IN_EN.json` | India (English) |

Each file contains 30 products, 10 categories, 5 banners, and 6 home sections with region-appropriate pricing and currency.

## Internationalization (i18n)

### Supported Regions

| Region | Currency | Locale | Language |
|--------|----------|--------|----------|
| United States | USD | `en_US` | English |
| United Kingdom | GBP | `en_GB` | English |
| Canada (English) | CAD | `en_CA` | English |
| Canada (French) | CAD | `fr_CA` | French |
| India | INR | `en_IN` | English |

### How It Works

- **Static UI strings**: Localized via `Localizable.xcstrings` String Catalog (English + French)
- **Dynamic content** (product names, descriptions): Served from region-specific bundled JSON via SQLite
- **Locale override**: `AppEntry` applies `.environment(\.locale, region.locale)` to drive SwiftUI formatters
- **Region switching**: Settings screen → RegionManager → triggers DB wipe + re-ingestion → UI refresh

### Region-Specific Features

- Currency formatting via `PriceFormatter` (respects region currency code and symbol)
- Tax rates per region (US: 8.25%, UK: 20%, CA: 13%, IN: 18%)
- Free shipping thresholds per region
- Metric/imperial measurement display
- French translations for CA-FR region

## Features

| Feature | Description |
|---------|-------------|
| **Home** | Hero banners, featured products, deals, new arrivals, trending |
| **Browse** | Category grid with product listings per category |
| **Search** | Debounced search with suggestions and recent searches |
| **Product Detail** | Image gallery, specs, variants, reviews, add to cart/wishlist |
| **Cart** | Item management, quantity updates, price summary |
| **Checkout** | Multi-step flow: shipping address → payment → delivery options → order review |
| **Orders** | Order history with status tracking and detail view |
| **Wishlist** | Save products for later (requires auth) |
| **Profile** | Account info, addresses, payment methods, region settings |
| **Notifications** | In-app notification list |
| **AR** | AR product visualization (placeholder) |

## UI & Accessibility

- **Dark mode**: Fully supported with semantic colors
- **Dynamic Type**: All text scales with system font size preferences
- **iPad adaptive**: 3-column grid layouts on wider screens
- **Accessibility labels/hints**: Applied to all interactive elements
- **Haptic feedback**: On cart add, wishlist toggle, and checkout actions
- **Skeleton screens**: Loading placeholders while data fetches
- **Pull-to-refresh**: Browse, Cart, and Wishlist screens
- **Error alerts**: Consistent `.errorAlert()` modifier across all features
- **Confirmation dialogs**: Before destructive actions (cancel order, remove cart item)

## Environment Configuration

The app uses **xcconfig files** for per-environment settings:

| File | Purpose |
|------|---------|
| `Config-Debug.xcconfig` | Local development |
| `Config-Staging.xcconfig` | Staging/QA environment |
| `Config-Production.xcconfig` | Production release |

### Configurable Values

| Key | Description |
|-----|-------------|
| `PRODUCT_SERVICE_URL` | Product catalog microservice URL |
| `CART_SERVICE_URL` | Cart microservice URL |
| `ORDER_SERVICE_URL` | Order microservice URL |
| `USER_SERVICE_URL` | User/profile microservice URL |
| `AUTH_SERVICE_URL` | Authentication microservice URL |
| `SEARCH_SERVICE_URL` | Search microservice URL |
| `IMAGE_BASE_URL` | Image CDN base URL |
| `FEATURE_FLAG_URL` | Feature flag service URL |
| `ANALYTICS_KEY` | Analytics API key |
| `REQUEST_TIMEOUT` | Network request timeout (seconds) |
| `DEFAULT_PAGE_SIZE` | Pagination page size |
| `MAX_CART_ITEMS` | Maximum items allowed in cart |
| `SESSION_TIMEOUT_MINUTES` | Auth session timeout |

## Connecting to a Real Backend

### Step 1: Update Service URLs

Edit the xcconfig file for your target environment (e.g., `Config-Debug.xcconfig`):

```
PRODUCT_SERVICE_URL = https:/$()/your-product-service.com/v1
CART_SERVICE_URL = https:/$()/your-cart-service.com/v1
ORDER_SERVICE_URL = https:/$()/your-order-service.com/v1
USER_SERVICE_URL = https:/$()/your-user-service.com/v1
AUTH_SERVICE_URL = https:/$()/your-auth-service.com/v1
SEARCH_SERVICE_URL = https:/$()/your-search-service.com/v1
```

> **Note:** The `/$()` after `https:` is required xcconfig syntax for escaping `://`.

### Step 2: Switch to Live

```swift
// In AppDelegate or app launch:
ServiceContainer.current = .live
```

The `.live` container uses `CloudDataRepository` (fetches aggregated JSON from your backend) and live repository implementations for cart, orders, and user operations.

### Step 3: Implement Cloud Data Repository

Update `Data/Cloud/CloudDataRepository.swift` to fetch your backend's aggregated assortment JSON. The expected format matches `AssortmentPayload`:

```json
{
  "products": [...],
  "categories": [...],
  "banners": [...],
  "homeSections": [...],
  "version": "1.0.0",
  "checksum": "sha256-hash"
}
```

### Step 4: Verify API Response Format

The live repositories expect JSON responses matching the DTOs in `Data/DTOs/`. The API client uses:
- **Snake case** key decoding (`convertFromSnakeCase`)
- **ISO 8601** date decoding
- **Bearer token** auth via Keychain for protected endpoints

## Deep Linking

| Route | Description |
|-------|-------------|
| `whimsywave://home` | Navigate to home tab |
| `whimsywave://product/{id}` | Open product detail |
| `whimsywave://category/{id}` | Browse category |
| `whimsywave://search?q={query}` | Search products |
| `whimsywave://cart` | Open cart |
| `whimsywave://order/{id}` | View order detail |
| `whimsywave://wishlist` | Open wishlist |
| `whimsywave://profile` | Open profile |

## Key Design Decisions

- **No third-party dependencies** — Only Apple frameworks (SwiftUI, Foundation, Observation, SQLite3, CryptoKit)
- **Offline-first with SQLite** — Local database as single source of truth; bundled JSON for zero-network startup
- **Swift actors for concurrency** — `SQLiteStore` and `DataIngestionWorker` are actors, eliminating manual lock management
- **Direct sqlite3 C API** — No ORM overhead; full control over queries, transactions, and WAL mode
- **Protocol-based repositories** — Clean separation between domain logic and data sources
- **Region-aware data pipeline** — Each region has its own aggregated JSON payload; region switch triggers full DB wipe and re-ingestion
- **Microservice-ready networking** — Each API endpoint routes to its own service URL via `ServiceType` enum
