import SwiftUI

struct NotificationsView: View {
    @Bindable var feature: NotificationsFeature

    var body: some View {
        NavigationStack {
            Group {
                if feature.notifications.isEmpty {
                    ContentUnavailableView("No notifications", systemImage: "bell.slash", description: Text("You're all caught up!"))
                } else {
                    List(feature.notifications) { notification in
                        notificationRow(notification)
                            .onTapGesture { feature.markAsRead(notification) }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                if feature.unreadCount > 0 {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Mark All Read") { feature.markAllAsRead() }
                            .font(.subheadline)
                    }
                }
            }
            .task { await feature.loadNotifications() }
        }
    }

    private func notificationRow(_ notification: AppNotification) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Image(systemName: iconForType(notification.type))
                .font(.title3)
                .foregroundStyle(colorForType(notification.type))
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(notification.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(notification.isRead ? .secondary : .primary)
                Text(notification.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text(notification.createdAt.formatted(.relative(presentation: .named)))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if !notification.isRead {
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(notification.isRead ? "" : "Unread. ")\(notification.title). \(notification.body)")
        .accessibilityHint(notification.isRead ? "" : "Double tap to mark as read")
    }

    private func iconForType(_ type: AppNotificationType) -> String {
        switch type {
        case .orderUpdate: return "shippingbox.fill"
        case .promotion: return "tag.fill"
        case .priceAlert: return "arrow.down.circle.fill"
        case .deliveryUpdate: return "truck.box.fill"
        case .general: return "bell.fill"
        }
    }

    private func colorForType(_ type: AppNotificationType) -> Color {
        switch type {
        case .orderUpdate: return .blue
        case .promotion: return .purple
        case .priceAlert: return .green
        case .deliveryUpdate: return .orange
        case .general: return .gray
        }
    }
}
