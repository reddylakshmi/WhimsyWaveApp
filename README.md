# WhimsyWave

An iOS e-commerce app for home decor and furniture, built with SwiftUI and the Observation framework.

## Requirements

| Tool | Version |
|------|---------|
| Xcode | 26.4+ |
| iOS Deployment Target | 26.4+ |
| Swift | 5.0+ |

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/WhimsyWaveApp.git
cd WhimsyWaveApp
```

### 2. Open in Xcode

```bash
open WhimsyWaveApp.xcodeproj
```

There are no third-party dependencies or Swift packages — the project is self-contained.

### 3. Select a Scheme and Run

- Choose the **WhimsyWaveApp** scheme
- Select a simulator or physical device (iOS 26.4+)
- Press `Cmd + R` to build and run

The app runs with **mock data by default**, so no backend setup is needed for local development.

## Project Structure

```
WhimsyWaveApp/
├── App/                        # App entry point, root view, AppReducer
├── Core/
│   ├── Configuration/          # Environment configs (xcconfig), constants
│   ├── Infrastructure/         # Analytics, DeepLinks, FeatureFlags, Logging,
│   │                             Networking, PushNotifications
│   └── Persistence/            # Keychain, Preferences, SwiftData
├── Data/
│   ├── DTOs/                   # Network response models
│   ├── Live/                   # Live repository implementations (API)
│   ├── Mappers/                # DTO-to-Domain model mappers
│   └── Mock/                   # Mock repositories and sample data
├── DesignSystem/               # Colors, typography, spacing, reusable components
├── Domain/
│   ├── Models/                 # Core business models (Product, User, Cart, Order, etc.)
│   ├── Repositories/           # Repository protocols (interfaces)
│   └── UseCases/               # Business logic use cases
└── Features/                   # Feature modules
    ├── AR/                     # AR try-on
    ├── Browse/                 # Category browsing and filtering
    ├── Cart/                   # Shopping cart
    ├── Checkout/               # Checkout flow (shipping, payment, review)
    ├── Home/                   # Home feed with banners and product sections
    ├── Notifications/          # Push notification list
    ├── Orders/                 # Order history and detail
    ├── ProductDetail/          # Product detail and reviews
    ├── Profile/                # User profile, addresses, payment methods, settings
    ├── Search/                 # Product search with suggestions
    └── Wishlist/               # Saved items
```

## Architecture

- **Pattern**: Feature-based with `@Observable` classes (no third-party state management)
- **Navigation**: Tab-based (Home, Browse, Cart, Wishlist, Profile) with sheet-based modals
- **Data Flow**: `AppReducer` holds all feature instances and coordinates navigation; each feature owns its own state and business logic
- **Dependency Injection**: Repository protocols in `Domain/Repositories/` with mock and live implementations swapped via `MockServiceProvider`

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

The app is designed to swap between mock and live data with minimal changes:

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

### Step 2: Switch to Live Repositories

In `Data/Mock/MockServiceProvider.swift`, replace mock implementations with live ones:

```swift
enum MockServiceProvider {
    static let productRepository: IProductRepository = LiveProductRepository()
    static let cartRepository: ICartRepository = LiveCartRepository()
    static let orderRepository: IOrderRepository = LiveOrderRepository()
    static let userRepository: IUserRepository = LiveUserRepository()
    // ... etc.
}
```

### Step 3: Verify API Response Format

The live repositories expect JSON responses matching the DTOs in `Data/DTOs/`. The API client uses:
- **Snake case** key decoding (`convertFromSnakeCase`)
- **ISO 8601** date decoding
- **Bearer token** auth via Keychain for protected endpoints

## API Endpoints

All endpoints are defined in `Core/Infrastructure/Networking/NetworkManager.swift` under the `APIEndpoint` enum. Each endpoint is mapped to a microservice via the `ServiceType` enum:

| Service | Endpoints |
|---------|-----------|
| **Product** | Home content, categories, product detail, reviews |
| **Search** | Product search with filters |
| **Cart** | Get/add/update/remove cart items, checkout |
| **Order** | Order list, order detail |
| **User** | Profile, wishlist, addresses, payment methods |
| **Auth** | Login, register, token refresh |

## Deep Linking

The app supports deep links with the following routes:

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

- **No third-party dependencies** — The project uses only Apple frameworks (SwiftUI, Foundation, Observation)
- **Mock-first development** — All features work with mock data out of the box, making it easy to develop UI without a running backend
- **Protocol-based repositories** — Clean separation between domain logic and data sources enables easy testing and backend swapping
- **Microservice-ready networking** — Each API endpoint routes to its own service URL, supporting independent microservice deployment
