import Foundation

extension Banner {
    static let mockBanners: [Banner] = [
        Banner(
            id: "BNR-001",
            title: "Spring Sale",
            subtitle: "Up to 40% off furniture & decor",
            imageURL: "banner-spring-sale",
            backgroundColor: "#E8F5E9",
            deepLink: "whimsywave://promotion/spring-sale"
        ),
        Banner(
            id: "BNR-002",
            title: "New Arrivals",
            subtitle: "Fresh finds for every room",
            imageURL: "banner-new-arrivals",
            backgroundColor: "#E3F2FD",
            deepLink: "whimsywave://category/CAT-004"
        ),
        Banner(
            id: "BNR-003",
            title: "Free Shipping",
            subtitle: "On orders over $49",
            imageURL: "banner-free-shipping",
            backgroundColor: "#FFF3E0",
            deepLink: nil
        ),
        Banner(
            id: "BNR-004",
            title: "Smart Home Starter Kit",
            subtitle: "Save 25% on smart home bundles",
            imageURL: "banner-smart-home",
            backgroundColor: "#F3E5F5",
            deepLink: "whimsywave://category/CAT-009"
        ),
        Banner(
            id: "BNR-005",
            title: "Kitchen Refresh",
            subtitle: "Top-rated appliances & tools",
            imageURL: "banner-kitchen",
            backgroundColor: "#FBE9E7",
            deepLink: "whimsywave://category/CAT-008"
        )
    ]
}
