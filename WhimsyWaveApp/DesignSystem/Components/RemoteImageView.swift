import SwiftUI

struct RemoteImageView: View {
    let url: String
    var cornerRadius: CGFloat = AppConstants.Layout.cornerRadius

    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                placeholder
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
            @unknown default:
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
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
