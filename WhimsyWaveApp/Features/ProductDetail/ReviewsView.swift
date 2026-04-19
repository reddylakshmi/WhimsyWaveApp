import SwiftUI

struct ReviewsView: View {
    let reviews: [Review]
    let productRating: Double
    let reviewCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Reviews").font(.headline)
                Spacer()
                Text("\(reviewCount) reviews").font(.subheadline).foregroundStyle(.secondary)
            }

            HStack(spacing: AppSpacing.sm) {
                Text(String(format: "%.1f", productRating))
                    .font(.system(size: 48, weight: .bold))
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: Double(star) <= productRating ? "star.fill" : "star")
                                .foregroundStyle(.orange)
                                .font(.caption)
                        }
                    }
                    Text("\(reviewCount) ratings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ForEach(reviews) { review in
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    HStack {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= review.rating ? "star.fill" : "star")
                                    .foregroundStyle(.orange)
                                    .font(.caption2)
                            }
                        }
                        Text(review.title).font(.subheadline.bold())
                    }
                    Text(review.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack {
                        Text(review.username)
                            .font(.caption)
                        if review.isVerifiedPurchase {
                            Text("Verified Purchase")
                                .font(.caption2)
                                .foregroundStyle(.green)
                        }
                        Spacer()
                        Text(review.createdAt.formatted(.dateTime.month().day().year()))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Divider()
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}
