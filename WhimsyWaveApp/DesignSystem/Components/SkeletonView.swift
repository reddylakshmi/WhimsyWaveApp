import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [.clear, .white.opacity(0.4), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .onAppear {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        phase = 400
                    }
                }
            }
            .clipped()
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Skeleton Shapes

struct SkeletonBox: View {
    var width: CGFloat? = nil
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 6

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.15))
            .frame(width: width, height: height)
            .shimmer()
    }
}

// MARK: - Product Grid Skeleton

struct ProductGridSkeleton: View {
    var itemCount: Int = 6

    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] {
        let count = sizeClass == .regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: AppSpacing.md), count: count)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            ForEach(0..<itemCount, id: \.self) { _ in
                productCardSkeleton
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }

    private var productCardSkeleton: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SkeletonBox(height: 180, cornerRadius: AppConstants.Layout.cornerRadius)
            SkeletonBox(width: 100, height: 12)
            SkeletonBox(height: 14)
            SkeletonBox(width: 60, height: 14)
        }
    }
}

// MARK: - Cart Skeleton

struct CartSkeleton: View {
    var itemCount: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(0..<itemCount, id: \.self) { _ in
                    cartItemSkeleton
                }
            }
            .listStyle(.plain)
        }
    }

    private var cartItemSkeleton: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            SkeletonBox(width: 70, height: 70, cornerRadius: AppConstants.Layout.cornerRadius)
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                SkeletonBox(height: 14)
                SkeletonBox(width: 80, height: 12)
                HStack {
                    SkeletonBox(width: 90, height: 28, cornerRadius: 6)
                    Spacer()
                    SkeletonBox(width: 60, height: 14)
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

// MARK: - Search Results Skeleton

struct SearchResultsSkeleton: View {
    var itemCount: Int = 5

    var body: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(0..<itemCount, id: \.self) { _ in
                searchRowSkeleton
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }

    private var searchRowSkeleton: some View {
        HStack(spacing: AppSpacing.md) {
            SkeletonBox(
                width: AppConstants.Image.thumbnailSize,
                height: AppConstants.Image.thumbnailSize,
                cornerRadius: AppConstants.Layout.cornerRadius
            )
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                SkeletonBox(height: 14)
                SkeletonBox(width: 80, height: 12)
                SkeletonBox(width: 60, height: 14)
            }
            Spacer()
            SkeletonBox(width: 44, height: 44, cornerRadius: 22)
        }
        .padding(.vertical, AppSpacing.xs)
    }
}
