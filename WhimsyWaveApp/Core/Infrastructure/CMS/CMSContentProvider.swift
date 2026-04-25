import Foundation

// MARK: - CMS Content Provider

/// Simulates a headless CMS (Contentful/Strapi) that serves region-specific dynamic content.
/// In production, this would fetch from a remote API. For now, it serves mock data per region.
@MainActor
enum CMSContentProvider {

    // MARK: - Banners

    /// Returns localized promotional banners for the given region.
    /// In production, these would be fetched from a CMS with region-targeted campaigns.
    static func banners(for region: Region) -> [Banner] {
        let threshold = PriceFormatter.format(region.freeShippingThreshold, region: region)
        switch region {
        case .us:
            return [
                Banner(id: "BNR-001", title: "Spring Sale", subtitle: "Up to 40% off furniture & decor", imageURL: "https://picsum.photos/seed/springsale/800/400", backgroundColor: "#E8F5E9", deepLink: "whimsywave://promotion/spring-sale"),
                Banner(id: "BNR-002", title: "New Arrivals", subtitle: "Fresh finds for every room", imageURL: "https://picsum.photos/seed/newarrivals/800/400", backgroundColor: "#E3F2FD", deepLink: "whimsywave://category/CAT-004"),
                Banner(id: "BNR-003", title: "Free Shipping", subtitle: "On orders over \(threshold)", imageURL: "https://picsum.photos/seed/freeshipping/800/400", backgroundColor: "#FFF3E0", deepLink: nil),
                Banner(id: "BNR-004", title: "Smart Home Starter Kit", subtitle: "Save 25% on smart home bundles", imageURL: "https://picsum.photos/seed/smarthome/800/400", backgroundColor: "#F3E5F5", deepLink: "whimsywave://category/CAT-009"),
                Banner(id: "BNR-005", title: "Kitchen Refresh", subtitle: "Top-rated appliances & tools", imageURL: "https://picsum.photos/seed/kitchenrefresh/800/400", backgroundColor: "#FBE9E7", deepLink: "whimsywave://category/CAT-008")
            ]
        case .uk:
            return [
                Banner(id: "BNR-UK-001", title: "Bank Holiday Sale", subtitle: "Up to 50% off selected furniture", imageURL: "https://picsum.photos/seed/uksale/800/400", backgroundColor: "#E8F5E9", deepLink: "whimsywave://promotion/bank-holiday"),
                Banner(id: "BNR-UK-002", title: "New Season Collection", subtitle: "Refresh your home for spring", imageURL: "https://picsum.photos/seed/ukspring/800/400", backgroundColor: "#E3F2FD", deepLink: "whimsywave://category/CAT-004"),
                Banner(id: "BNR-UK-003", title: "Free Delivery", subtitle: "On orders over \(threshold)", imageURL: "https://picsum.photos/seed/ukdelivery/800/400", backgroundColor: "#FFF3E0", deepLink: nil),
                Banner(id: "BNR-UK-004", title: "British Made", subtitle: "Shop handcrafted British designs", imageURL: "https://picsum.photos/seed/britishmade/800/400", backgroundColor: "#F3E5F5", deepLink: nil)
            ]
        case .ca:
            return [
                Banner(id: "BNR-CA-001", title: "Victoria Day Sale", subtitle: "Up to 40% off across the store", imageURL: "https://picsum.photos/seed/casale/800/400", backgroundColor: "#E8F5E9", deepLink: "whimsywave://promotion/victoria-day"),
                Banner(id: "BNR-CA-002", title: "New Arrivals", subtitle: "Discover fresh Canadian designs", imageURL: "https://picsum.photos/seed/canew/800/400", backgroundColor: "#E3F2FD", deepLink: "whimsywave://category/CAT-004"),
                Banner(id: "BNR-CA-003", title: "Free Shipping", subtitle: "On orders over \(threshold)", imageURL: "https://picsum.photos/seed/cashipping/800/400", backgroundColor: "#FFF3E0", deepLink: nil),
                Banner(id: "BNR-CA-004", title: "Proudly Canadian", subtitle: "Shop local artisan collections", imageURL: "https://picsum.photos/seed/canadian/800/400", backgroundColor: "#FCE4EC", deepLink: nil)
            ]
        case .caFR:
            return [
                Banner(id: "BNR-CAFR-001", title: "Soldes de la fête de la Reine", subtitle: "Jusqu'à 40 % de rabais en magasin", imageURL: "https://picsum.photos/seed/casale/800/400", backgroundColor: "#E8F5E9", deepLink: "whimsywave://promotion/victoria-day"),
                Banner(id: "BNR-CAFR-002", title: "Nouveautés", subtitle: "Découvrez les designs canadiens", imageURL: "https://picsum.photos/seed/canew/800/400", backgroundColor: "#E3F2FD", deepLink: "whimsywave://category/CAT-004"),
                Banner(id: "BNR-CAFR-003", title: "Livraison gratuite", subtitle: "Pour les commandes de plus de \(threshold)", imageURL: "https://picsum.photos/seed/cashipping/800/400", backgroundColor: "#FFF3E0", deepLink: nil),
                Banner(id: "BNR-CAFR-004", title: "Fièrement canadien", subtitle: "Magasinez les collections artisanales locales", imageURL: "https://picsum.photos/seed/canadian/800/400", backgroundColor: "#FCE4EC", deepLink: nil)
            ]
        case .in:
            return [
                Banner(id: "BNR-IN-001", title: "Mega Home Festival", subtitle: "Up to 60% off on furniture & decor", imageURL: "https://picsum.photos/seed/insale/800/400", backgroundColor: "#E8F5E9", deepLink: "whimsywave://promotion/mega-home"),
                Banner(id: "BNR-IN-002", title: "New Arrivals", subtitle: "Trending home styles for you", imageURL: "https://picsum.photos/seed/innew/800/400", backgroundColor: "#E3F2FD", deepLink: "whimsywave://category/CAT-004"),
                Banner(id: "BNR-IN-003", title: "Free Delivery", subtitle: "On orders over \(threshold)", imageURL: "https://picsum.photos/seed/indelivery/800/400", backgroundColor: "#FFF3E0", deepLink: nil),
                Banner(id: "BNR-IN-004", title: "Made in India", subtitle: "Celebrate Indian craftsmanship", imageURL: "https://picsum.photos/seed/madeinindia/800/400", backgroundColor: "#FFF9C4", deepLink: nil)
            ]
        }
    }

    // MARK: - Categories

    /// Returns localized category names for the given region.
    /// Category structure is the same globally, but names are translated.
    static func categories(for region: Region) -> [Category] {
        switch region {
        case .caFR:
            return [
                Category(id: "CAT-001", name: "Mobilier", image: "sofa.fill", productCount: 2450, subcategories: [
                    Category(id: "CAT-001-1", name: "Salon", image: "sofa.fill", productCount: 850, parentId: "CAT-001"),
                    Category(id: "CAT-001-2", name: "Chambre", image: "bed.double.fill", productCount: 620, parentId: "CAT-001"),
                    Category(id: "CAT-001-3", name: "Salle à manger", image: "fork.knife", productCount: 430, parentId: "CAT-001"),
                    Category(id: "CAT-001-4", name: "Bureau", image: "desktopcomputer", productCount: 350, parentId: "CAT-001"),
                    Category(id: "CAT-001-5", name: "Cuisine", image: "refrigerator.fill", productCount: 200, parentId: "CAT-001")
                ]),
                Category(id: "CAT-002", name: "Éclairage", image: "lamp.desk.fill", productCount: 1230),
                Category(id: "CAT-003", name: "Salle de bain", image: "bathtub.fill", productCount: 890),
                Category(id: "CAT-004", name: "Décoration", image: "photo.artframe", productCount: 3200),
                Category(id: "CAT-005", name: "Extérieur", image: "leaf.fill", productCount: 1560),
                Category(id: "CAT-006", name: "Literie", image: "bed.double.fill", productCount: 980),
                Category(id: "CAT-007", name: "Tapis", image: "square.grid.3x3.fill", productCount: 720),
                Category(id: "CAT-008", name: "Cuisine", image: "fork.knife", productCount: 1450),
                Category(id: "CAT-009", name: "Maison intelligente", image: "homekit", productCount: 340),
                Category(id: "CAT-010", name: "Rangement", image: "archivebox.fill", productCount: 670)
            ]
        default:
            // English categories for US, UK, CA, IN
            return Category.mockCategories
        }
    }

    // MARK: - Home Section Titles

    /// Returns localized section titles for the home screen.
    /// These simulate CMS-delivered section headers that can be updated without an app release.
    static func homeSectionTitles(for region: Region) -> HomeSectionTitles {
        switch region {
        case .caFR:
            return HomeSectionTitles(
                featured: "En vedette",
                shopByCategory: "Magasiner par catégorie",
                topPicks: "Nos coups de cœur",
                topPicksSubtitle: "Sélectionnés pour vous",
                dealsOfTheDay: "Offres du jour",
                dealsSubtitle: "Offres à durée limitée",
                justArrived: "Nouveautés",
                trendingNow: "Tendances actuelles"
            )
        case .uk:
            return HomeSectionTitles(
                featured: "Featured",
                shopByCategory: "Shop by Category",
                topPicks: "Top Picks For You",
                topPicksSubtitle: "Curated just for you",
                dealsOfTheDay: "Deals of the Day",
                dealsSubtitle: "Limited time offers",
                justArrived: "Just Arrived",
                trendingNow: "Trending Now"
            )
        case .in:
            return HomeSectionTitles(
                featured: "Featured",
                shopByCategory: "Shop by Category",
                topPicks: "Top Picks For You",
                topPicksSubtitle: "Curated just for you",
                dealsOfTheDay: "Deals of the Day",
                dealsSubtitle: "Limited time offers",
                justArrived: "Just Arrived",
                trendingNow: "Trending Now"
            )
        default:
            return HomeSectionTitles(
                featured: "Featured",
                shopByCategory: "Shop by Category",
                topPicks: "Top Picks For You",
                topPicksSubtitle: "Curated just for you",
                dealsOfTheDay: "Deals of the Day",
                dealsSubtitle: "Limited time offers",
                justArrived: "Just Arrived",
                trendingNow: "Trending Now"
            )
        }
    }

    // MARK: - Product Localization

    /// Returns a localized copy of a product for the given region.
    /// In production, product names and descriptions would come from the CMS per locale.
    static func localizedProduct(_ product: Product, for region: Region) -> Product {
        let regionalized = product.regionalized(for: region)
        guard region == .caFR else { return regionalized }

        // For Canada French, translate product names and descriptions
        let translation = frenchProductTranslations[product.id]
        return Product(
            id: regionalized.id,
            name: translation?.name ?? regionalized.name,
            brand: regionalized.brand,
            description: translation?.description ?? regionalized.description,
            price: regionalized.price,
            salePrice: regionalized.salePrice,
            currency: regionalized.currency,
            images: regionalized.images,
            category: localizedCategoryPath(regionalized.category, for: region),
            rating: regionalized.rating,
            reviewCount: regionalized.reviewCount,
            specs: translation?.specs ?? regionalized.specs,
            variants: regionalized.variants,
            tags: regionalized.tags,
            isInStock: regionalized.isInStock,
            stockCount: regionalized.stockCount,
            estimatedDelivery: regionalized.estimatedDelivery,
            isFeatured: regionalized.isFeatured,
            isNew: regionalized.isNew,
            createdAt: regionalized.createdAt
        )
    }

    /// Translates a category path for the given region
    static func localizedCategoryPath(_ categoryPath: CategoryPath, for region: Region) -> CategoryPath {
        guard region == .caFR else { return categoryPath }
        let translated = categoryPath.path.map { frenchCategoryNames[$0] ?? $0 }
        return CategoryPath(path: translated)
    }

    /// Returns all products localized for the given region
    static func products(for region: Region) -> [Product] {
        Product.mockProducts.map { localizedProduct($0, for: region) }
    }
}

// MARK: - Supporting Types

struct HomeSectionTitles {
    let featured: String
    let shopByCategory: String
    let topPicks: String
    let topPicksSubtitle: String
    let dealsOfTheDay: String
    let dealsSubtitle: String
    let justArrived: String
    let trendingNow: String
}

// MARK: - French Translations (CMS Mock Data)

struct ProductTranslation {
    let name: String
    let description: String
    let specs: [ProductSpec]?

    init(name: String, description: String, specs: [ProductSpec]? = nil) {
        self.name = name
        self.description = description
        self.specs = specs
    }
}

extension CMSContentProvider {

    /// French category name translations (simulates CMS translation table)
    static let frenchCategoryNames: [String: String] = [
        "Furniture": "Mobilier",
        "Living Room": "Salon",
        "Bedroom": "Chambre",
        "Dining Room": "Salle à manger",
        "Office": "Bureau",
        "Kitchen": "Cuisine",
        "Lighting": "Éclairage",
        "Floor Lamps": "Lampadaires",
        "Pendant Lights": "Suspensions",
        "Table Lamps": "Lampes de table",
        "Bath": "Salle de bain",
        "Shower Heads": "Pommes de douche",
        "Vanities": "Meubles-lavabos",
        "Towels": "Serviettes",
        "Decor": "Décoration",
        "Window Treatments": "Habillage de fenêtres",
        "Curtains": "Rideaux",
        "Wall Art": "Art mural",
        "Mirrors": "Miroirs",
        "Pillows & Throws": "Coussins et jetés",
        "Outdoor": "Extérieur",
        "Planters": "Jardinières",
        "Patio Furniture": "Mobilier de patio",
        "Outdoor Lighting": "Éclairage extérieur",
        "Bedding": "Literie",
        "Throws & Blankets": "Jetés et couvertures",
        "Sheet Sets": "Ensembles de draps",
        "Rugs": "Tapis",
        "Area Rugs": "Tapis de salon",
        "Runner Rugs": "Tapis de passage",
        "Faucets": "Robinets",
        "Cutlery": "Coutellerie",
        "Appliances": "Électroménagers",
        "Smart Home": "Maison intelligente",
        "Plugs & Outlets": "Prises intelligentes",
        "Thermostats": "Thermostats",
        "Storage": "Rangement",
        "Closet Organization": "Organisation de placard",
        "Sofas": "Canapés",
        "Tables": "Tables",
        "Beds": "Lits",
        "Bar Stools": "Tabourets de bar",
        "Chairs": "Chaises",
        "Shelving": "Étagères",
        "Side Tables": "Tables d'appoint"
    ]

    /// French product translations (simulates CMS product content per locale)
    static let frenchProductTranslations: [String: ProductTranslation] = [
        "PRD-001": ProductTranslation(
            name: "Canapé convertible Serta",
            description: "Transformez votre espace de vie avec ce canapé convertible polyvalent. Coussins en mousse à mémoire de forme, mécanisme de conversion facile et tissu haute performance résistant aux taches.",
            specs: [
                .init(label: "Dimensions", value: "213 cm L x 91 cm P x 86 cm H"),
                .init(label: "Matériau", value: "Tissu haute performance"),
                .init(label: "Capacité", value: "272 kg"),
                .init(label: "Assemblage", value: "Requis")
            ]
        ),
        "PRD-002": ProductTranslation(
            name: "Table de salle à manger rustique Walker Edison",
            description: "Apportez chaleur et caractère à votre salle à manger avec cette table en bois massif de style fermier. Finition vieillie à la main pour un look unique.",
            specs: [
                .init(label: "Dimensions", value: "183 cm L x 91 cm P x 76 cm H"),
                .init(label: "Matériau", value: "Pin massif"),
                .init(label: "Places", value: "6 à 8 personnes")
            ]
        ),
        "PRD-003": ProductTranslation(
            name: "Lampadaire LED Brightech Sky",
            description: "Illuminez n'importe quelle pièce avec ce lampadaire moderne et élégant. LED à intensité variable avec trois températures de couleur et un profil mince.",
            specs: [
                .init(label: "Hauteur", value: "183 cm"),
                .init(label: "Puissance", value: "30 W LED"),
                .init(label: "Températures", value: "3000K/4000K/5000K")
            ]
        ),
        "PRD-004": ProductTranslation(
            name: "Cadre de lit plateforme Zinus",
            description: "Dormez avec style avec ce cadre de lit plateforme capitonné. Pas de sommier nécessaire. Assemblage sans outil en moins d'une heure.",
            specs: [
                .init(label: "Taille", value: "Grand (Queen)"),
                .init(label: "Matériau", value: "Tissu capitonné"),
                .init(label: "Capacité", value: "318 kg")
            ]
        ),
        "PRD-005": ProductTranslation(
            name: "Tapis marocain nuLOOM Blythe",
            description: "Ajoutez texture et chaleur à n'importe quelle pièce avec ce tapis d'inspiration marocaine. Fabrication mécanique pour la durabilité avec une pile douce en polypropylène.",
            specs: [
                .init(label: "Taille", value: "244 cm x 305 cm"),
                .init(label: "Matériau", value: "Polypropylène"),
                .init(label: "Hauteur de pile", value: "0,9 cm")
            ]
        ),
        "PRD-006": ProductTranslation(
            name: "Tabourets de comptoir Christopher Knight (lot de 2)",
            description: "Rehaussez votre îlot de cuisine avec ces tabourets élégants en cuir reconstitué. Pieds en fer robustes avec embouts protecteurs.",
            specs: [
                .init(label: "Hauteur", value: "66 cm (hauteur comptoir)"),
                .init(label: "Matériau", value: "Cuir reconstitué et fer"),
                .init(label: "Quantité", value: "Lot de 2")
            ]
        ),
        "PRD-007": ProductTranslation(
            name: "Pomme de douche Moen Magnetix effet pluie",
            description: "Transformez votre douche quotidienne avec cette pomme de douche effet pluie dotée d'un système d'arrimage magnétique. Six réglages de jet.",
            specs: [
                .init(label: "Diamètre", value: "20 cm"),
                .init(label: "Réglages", value: "6"),
                .init(label: "Fini", value: "Chrome")
            ]
        ),
        "PRD-008": ProductTranslation(
            name: "Rideaux occultants thermiques NICETOWN",
            description: "Bloquez la lumière et réduisez le bruit avec ces rideaux occultants à isolation thermique. Technologie triple tissage pour une efficacité énergétique maximale.",
            specs: [
                .init(label: "Taille", value: "132 cm L x 213 cm H (paire)"),
                .init(label: "Matériau", value: "Polyester triple tissage"),
                .init(label: "Accroche", value: "Œillets")
            ]
        ),
        "PRD-009": ProductTranslation(
            name: "Meuble-lavabo Glacier Bay 91 cm",
            description: "Ensemble complet de meuble-lavabo avec dessus en marbre synthétique et lavabo pré-installé. Portes à fermeture douce et tiroirs à extension complète.",
            specs: [
                .init(label: "Largeur", value: "91 cm"),
                .init(label: "Matériau", value: "Bois d'ingénierie"),
                .init(label: "Dessus", value: "Marbre synthétique")
            ]
        ),
        "PRD-010": ProductTranslation(
            name: "Art mural abstrait sur toile Pyradecor",
            description: "Impressions d'art abstrait sur toile, tendues et encadrées, prêtes à accrocher. Impression giclée haute définition sur toile de qualité supérieure.",
            specs: [
                .init(label: "Taille", value: "152 cm L x 76 cm H (total)"),
                .init(label: "Panneaux", value: "5 pièces"),
                .init(label: "Matériau", value: "Toile sur cadre en bois")
            ]
        ),
        "PRD-011": ProductTranslation(
            name: "Chaise de bureau ergonomique HON Ignition 2.0",
            description: "Conçue pour le confort toute la journée avec inclinaison synchro avancée et support lombaire réglable. Certifiée BIFMA pour la durabilité.",
            specs: [
                .init(label: "Capacité", value: "136 kg"),
                .init(label: "Accoudoirs", value: "4D réglables"),
                .init(label: "Garantie", value: "12 ans")
            ]
        ),
        "PRD-012": ProductTranslation(
            name: "Pots en céramique Mkono (lot de 3)",
            description: "Jardinières minimalistes modernes en céramique avec soucoupes en bambou. Trou de drainage inclus. Trois tailles pour un affichage polyvalent.",
            specs: [
                .init(label: "Tailles", value: "10, 13, 15 cm de diamètre"),
                .init(label: "Matériau", value: "Céramique avec soucoupe en bambou"),
                .init(label: "Drainage", value: "Oui")
            ]
        ),
        "PRD-013": ProductTranslation(
            name: "Robinet de cuisine Delta Trinsic",
            description: "Robinet de cuisine professionnel avec technologie Touch2O. Touchez n'importe où sur le robinet pour démarrer et arrêter le débit d'eau.",
            specs: [
                .init(label: "Fini", value: "Inox arctique"),
                .init(label: "Technologie", value: "Touch2O"),
                .init(label: "Longueur du tuyau", value: "150 cm")
            ]
        ),
        "PRD-014": ProductTranslation(
            name: "Jeté Barefoot Dreams CozyChic",
            description: "Jeté ultra-doux en microfibre qui devient plus doux à chaque lavage. Lavable en machine pour un luxe quotidien.",
            specs: [
                .init(label: "Taille", value: "137 cm x 183 cm"),
                .init(label: "Matériau", value: "Microfibre polyester"),
                .init(label: "Entretien", value: "Lavable en machine")
            ]
        ),
        "PRD-015": ProductTranslation(
            name: "Prise intelligente Kasa (lot de 4)",
            description: "Contrôlez vos appareils de n'importe où avec ces prises intelligentes WiFi. Compatible avec Alexa, Google Home et Apple HomeKit.",
            specs: [
                .init(label: "Quantité", value: "Lot de 4"),
                .init(label: "Connectivité", value: "WiFi 2,4 GHz"),
                .init(label: "Compatibilité", value: "Alexa, Google, HomeKit")
            ]
        ),
        "PRD-016": ProductTranslation(
            name: "Étagère industrielle VASAGLE 5 niveaux",
            description: "Étagère industrielle à concept ouvert avec tablettes brun rustique et cadre en métal noir mat. Parfaite pour le salon, le bureau ou la chambre.",
            specs: [
                .init(label: "Dimensions", value: "80 cm L x 30 cm P x 168 cm H"),
                .init(label: "Matériau", value: "Panneau de particules et acier"),
                .init(label: "Capacité", value: "15 kg par tablette")
            ]
        ),
        "PRD-017": ProductTranslation(
            name: "Table d'appoint ronde en marbre",
            description: "Table d'appoint élégante avec un véritable dessus en marbre et une base en métal doré. Une pièce d'accent magnifique pour toute pièce.",
            specs: [
                .init(label: "Diamètre du dessus", value: "38 cm"),
                .init(label: "Hauteur", value: "61 cm"),
                .init(label: "Matériau", value: "Marbre et métal doré")
            ]
        ),
        "PRD-018": ProductTranslation(
            name: "Suspension Globe Electric Harrow",
            description: "Suspension moderne en noir mat avec design à ampoule apparente. Parfaite au-dessus de l'îlot de cuisine, de la table à manger ou de l'entrée.",
            specs: [
                .init(label: "Diamètre", value: "25 cm"),
                .init(label: "Longueur du câble", value: "152 cm (réglable)"),
                .init(label: "Type d'ampoule", value: "E26 (non incluse)")
            ]
        ),
        "PRD-019": ProductTranslation(
            name: "Lampe de table sculptée Lalia Home",
            description: "Lampe de table élégante en céramique avec abat-jour tambour en lin. Ajoute une lumière ambiante chaude et un style sophistiqué.",
            specs: [
                .init(label: "Hauteur", value: "47 cm"),
                .init(label: "Abat-jour", value: "25 cm en lin"),
                .init(label: "Matériau", value: "Céramique et lin")
            ]
        ),
        "PRD-020": ProductTranslation(
            name: "Ensemble de serviettes Chakir Turkish Linens",
            description: "Serviettes de luxe en coton turc 700 g/m². L'ensemble de 6 comprend 2 serviettes de bain, 2 serviettes à mains et 2 débarbouillettes. Ultra-absorbantes et à séchage rapide.",
            specs: [
                .init(label: "GSM", value: "700"),
                .init(label: "Matériau", value: "100 % coton turc"),
                .init(label: "L'ensemble comprend", value: "6 pièces")
            ]
        ),
        "PRD-021": ProductTranslation(
            name: "Miroir pleine longueur arqué BEAUTYPEAK",
            description: "Miroir pleine longueur élégant à arche avec cadre en alliage d'aluminium. À appuyer contre le mur ou à accrocher. Verre incassable pour la sécurité.",
            specs: [
                .init(label: "Taille", value: "165 cm x 56 cm"),
                .init(label: "Cadre", value: "Alliage d'aluminium"),
                .init(label: "Verre", value: "HD incassable")
            ]
        ),
        "PRD-022": ProductTranslation(
            name: "Housses de coussins en velours MIULEE (lot de 4)",
            description: "Housses de coussin en velours luxueusement douces dans des combinaisons de couleurs assorties. Fermeture à glissière cachée. Lavable en machine.",
            specs: [
                .init(label: "Taille", value: "46 cm x 46 cm"),
                .init(label: "Matériau", value: "Velours"),
                .init(label: "Quantité", value: "Lot de 4 housses")
            ]
        ),
        "PRD-023": ProductTranslation(
            name: "Ensemble de patio UDPATIO 4 pièces",
            description: "Ensemble de mobilier de patio résistant aux intempéries comprenant causeuse, 2 fauteuils et table basse avec dessus en verre trempé. Coussins à séchage rapide inclus.",
            specs: [
                .init(label: "Matériau", value: "Rotin PE"),
                .init(label: "Coussin", value: "Tissu oléfine (amovible)"),
                .init(label: "Structure", value: "Acier enduit de poudre")
            ]
        ),
        "PRD-024": ProductTranslation(
            name: "Guirlandes LED étanches Brightown 30 m",
            description: "Créez une ambiance magique en extérieur avec ces guirlandes LED blanc chaud. Ampoules incassables, étanches pour une utilisation toute l'année.",
            specs: [
                .init(label: "Longueur", value: "30 mètres"),
                .init(label: "Ampoules", value: "50 LED (incassables)"),
                .init(label: "Indice", value: "IP65 étanche")
            ]
        ),
        "PRD-025": ProductTranslation(
            name: "Ensemble de draps CGK Unlimited",
            description: "Draps en microfibre brossée avec poches profondes. Infroissables, résistants à la décoloration et hypoallergéniques. Comprend drap plat, drap-housse et 2 taies d'oreiller.",
            specs: [
                .init(label: "Nombre de fils", value: "1800"),
                .init(label: "Matériau", value: "Microfibre brossée"),
                .init(label: "Poches profondes", value: "Jusqu'à 41 cm")
            ]
        ),
        "PRD-026": ProductTranslation(
            name: "Tapis de passage lavable ReaLife",
            description: "Tapis de passage résistant aux taches et lavable en machine pour couloirs, cuisines et entrées. Fabriqué à partir de 100 % coton recyclé.",
            specs: [
                .init(label: "Taille", value: "61 cm x 213 cm"),
                .init(label: "Matériau", value: "100 % coton recyclé"),
                .init(label: "Entretien", value: "Lavable en machine")
            ]
        ),
        "PRD-027": ProductTranslation(
            name: "Bloc de couteaux Henckels Modernist 14 pièces",
            description: "Couteaux professionnels en acier inoxydable allemand. Bloc auto-affûtant pour maintenir le tranchant. Comprend couteaux de chef, à pain, utilitaire, à éplucher, à steak et plus.",
            specs: [
                .init(label: "Pièces", value: "14"),
                .init(label: "Matériau", value: "Acier inoxydable allemand"),
                .init(label: "Bloc", value: "Auto-affûtant")
            ]
        ),
        "PRD-028": ProductTranslation(
            name: "Batteur sur socle KitchenAid Artisan 4,7 L",
            description: "Batteur sur socle emblématique à tête inclinable avec 10 vitesses. Comprend batteur plat, crochet pétrisseur et fouet. Plus de 15 accessoires optionnels.",
            specs: [
                .init(label: "Capacité", value: "4,7 litres"),
                .init(label: "Moteur", value: "325 watts"),
                .init(label: "Vitesses", value: "10")
            ]
        ),
        "PRD-029": ProductTranslation(
            name: "Thermostat intelligent ecobee Premium",
            description: "Économisez jusqu'à 26 % sur vos coûts d'énergie avec des capteurs intelligents, Alexa intégré et surveillance de la qualité de l'air. Compatible Apple HomeKit.",
            specs: [
                .init(label: "Écran", value: "Tactile 8,9 cm"),
                .init(label: "Capteurs", value: "SmartSensor inclus"),
                .init(label: "Compatibilité", value: "HomeKit, Alexa intégré")
            ]
        ),
        "PRD-030": ProductTranslation(
            name: "Bacs de rangement mDesign empilables (lot de 6)",
            description: "Bacs de rangement en tissu avec fenêtres transparentes et poignées renforcées. Empilez et organisez placards, étagères et armoires.",
            specs: [
                .init(label: "Taille", value: "28 cm x 28 cm x 28 cm chacun"),
                .init(label: "Matériau", value: "Tissu polyester"),
                .init(label: "Quantité", value: "Lot de 6")
            ]
        )
    ]
}
