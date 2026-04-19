import Foundation
import Observation

@Observable @MainActor
final class HomeFeature {
    var sections: [HomeSection] = []
    var banners: [Banner] = []
    var isLoading = false
    var error: String?

    private let fetchHomeUseCase: FetchHomeUseCase
    private let analytics: AnalyticsClient

    init(
        productRepository: IProductRepository = MockServiceProvider.productRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.fetchHomeUseCase = FetchHomeUseCase(productRepository: productRepository)
        self.analytics = analytics
    }

    func onAppear() async {
        guard sections.isEmpty else { return }
        await loadContent()
    }

    func refresh() async {
        await loadContent()
    }

    private func loadContent() async {
        isLoading = true
        error = nil
        do {
            let loaded = try await fetchHomeUseCase.execute()
            sections = loaded
            banners = loaded.first(where: { $0.type == .heroBanner })?.banners ?? []
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
            AppLogger.error("Home load failed: \(error)", category: .networking)
        }
        isLoading = false
    }
}
