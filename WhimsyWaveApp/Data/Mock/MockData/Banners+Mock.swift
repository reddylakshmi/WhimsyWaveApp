import Foundation

extension Banner {
    static let mockBanners: [Banner] = [
        Banner(
            id: "BNR-001",
            title: "Spring Sale",
            subtitle: "Up to 40% off furniture & decor",
            imageURL: "https://picsum.photos/seed/springsale/800/400",
            backgroundColor: "#E8F5E9",
            deepLink: "whimsywave://promotion/spring-sale"
        ),
        Banner(
            id: "BNR-002",
            title: "New Arrivals",
            subtitle: "Fresh finds for every room",
            imageURL: "https://picsum.photos/seed/newarrivals/800/400",
            backgroundColor: "#E3F2FD",
            deepLink: "whimsywave://category/CAT-004"
        ),
        Banner(
            id: "BNR-003",
            title: "Free Shipping",
            subtitle: "On orders over $49",
            imageURL: "https://picsum.photos/seed/freeshipping/800/400",
            backgroundColor: "#FFF3E0",
            deepLink: nil
        ),
        Banner(
            id: "BNR-004",
            title: "Smart Home Starter Kit",
            subtitle: "Save 25% on smart home bundles",
            imageURL: "https://picsum.photos/seed/smarthome/800/400",
            backgroundColor: "#F3E5F5",
            deepLink: "whimsywave://category/CAT-009"
        ),
        Banner(
            id: "BNR-005",
            title: "Kitchen Refresh",
            subtitle: "Top-rated appliances & tools",
            imageURL: "https://picsum.photos/seed/kitchenrefresh/800/400",
            backgroundColor: "#FBE9E7",
            deepLink: "whimsywave://category/CAT-008"
        )
    ]
}
