import Foundation

enum FeatureFlag: String, CaseIterable, Sendable {
    case arViewEnabled = "ar_view_enabled"
    case newCheckoutFlow = "new_checkout_flow"
    case voiceSearch = "voice_search_enabled"
    case recommendationsV2 = "recommendations_v2"
    case inAppChat = "in_app_chat_enabled"
    case expressDeliveryBadge = "express_delivery_badge"
    case socialSharing = "social_sharing_enabled"
    case priceAlerts = "price_alerts_enabled"
    case onePageCheckout = "one_page_checkout"
    case debugMenu = "debug_menu_enabled"
}
