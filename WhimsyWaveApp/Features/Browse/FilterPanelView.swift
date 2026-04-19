import SwiftUI

struct FilterPanelView: View {
    @Binding var filter: ProductFilter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Sort By") {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button {
                            filter.sortBy = option
                        } label: {
                            HStack {
                                Text(option.displayName)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if filter.sortBy == option {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }

                Section("Availability") {
                    Toggle("In Stock Only", isOn: $filter.inStockOnly)
                }

                Section("Rating") {
                    ForEach([4, 3, 2, 1], id: \.self) { rating in
                        Button {
                            filter.rating = filter.rating == rating ? nil : rating
                        } label: {
                            HStack {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .foregroundStyle(star <= rating ? .orange : .gray)
                                        .font(.caption)
                                }
                                Text("& Up").font(.subheadline).foregroundStyle(.primary)
                                Spacer()
                                if filter.rating == rating {
                                    Image(systemName: "checkmark").foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") { filter = .default }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") { dismiss() }
                        .bold()
                }
            }
        }
    }
}
