import SwiftUI

struct RatingView: View {
    let rating: Double
    let maxRating: Int
    let size: CGFloat

    init(rating: Double, maxRating: Int = 5, size: CGFloat = 14) {
        self.rating = rating
        self.maxRating = maxRating
        self.size = size
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: starName(for: index))
                    .font(.system(size: size))
                    .foregroundStyle(.orange)
            }
        }
    }

    private func starName(for index: Int) -> String {
        let value = Double(index)
        if rating >= value {
            return AppIcons.star
        } else if rating >= value - 0.5 {
            return AppIcons.starHalf
        } else {
            return AppIcons.starEmpty
        }
    }
}
