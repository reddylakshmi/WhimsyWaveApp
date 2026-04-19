import SwiftUI

struct ARTryOnView: View {
    @Bindable var feature: ARFeature

    var body: some View {
        if feature.isEnabled {
            ContentUnavailableView(
                "AR View Coming Soon",
                systemImage: "arkit",
                description: Text("Place furniture in your room using augmented reality")
            )
        } else {
            ContentUnavailableView(
                "AR Not Available",
                systemImage: "eye.slash",
                description: Text("This feature is currently disabled")
            )
        }
    }
}
