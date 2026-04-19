import SwiftUI

struct OrdersListView: View {
    @Bindable var feature: OrdersFeature

    var body: some View {
        NavigationStack {
            Group {
                if feature.isLoading && feature.orders.isEmpty {
                    ProgressView()
                } else if feature.orders.isEmpty {
                    ContentUnavailableView("No orders yet", systemImage: "bag", description: Text("Your orders will appear here"))
                } else {
                    List(feature.orders) { order in
                        NavigationLink {
                            OrderDetailView(order: order, onCancel: { Task { await feature.cancelOrder(order) } })
                        } label: {
                            orderRow(order)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Orders")
            .refreshable { await feature.loadOrders() }
            .task { await feature.loadOrders() }
        }
    }

    private func orderRow(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text(order.orderNumber).font(.headline)
                Spacer()
                Text(order.status.displayName)
                    .font(.caption.bold())
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xxs)
                    .background(Capsule().fill(statusColor(order.status).opacity(0.1)))
                    .foregroundStyle(statusColor(order.status))
            }
            Text(order.createdAt.formatted(.dateTime.month().day().year()))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack {
                Text("\(order.items.count) item(s)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(order.displayTotal).font(.subheadline.bold())
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .delivered: return .green
        case .shipped, .outForDelivery: return .blue
        case .cancelled, .returned: return .red
        default: return .orange
        }
    }
}
