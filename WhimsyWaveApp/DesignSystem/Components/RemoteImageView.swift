import SwiftUI

struct RemoteImageView: View {
    let url: String
    var cornerRadius: CGFloat = AppConstants.Layout.cornerRadius

    @State private var image: UIImage?
    @State private var isFailed = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isFailed {
                placeholder
            } else {
                loadingView
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .task(id: url) {
            await loadImage()
        }
    }

    private func loadImage() async {
        isFailed = false
        image = nil
        guard let imageURL = URL(string: url) else {
            isFailed = true
            return
        }
        if let loaded = await ImageCache.shared.image(for: imageURL) {
            image = loaded
        } else {
            isFailed = true
        }
    }

    private var loadingView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.08))
            .overlay {
                ProgressView()
            }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .overlay {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.quaternary)
            }
    }
}
