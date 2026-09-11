import SwiftUI
import Shimmer

/// A brief, entirely unnecessary loading state shown on cold launch, because
/// a real product would have one and Void insists on behaving like one.
struct LaunchSplashView: View {
    var body: some View {
        VStack(spacing: Metrics.spacingLG) {
            VStack(spacing: Metrics.spacingSM) {
                Circle()
                    .fill(Color.appTextMuted.opacity(0.18))
                    .frame(width: 56, height: 56)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.appTextMuted.opacity(0.18))
                    .frame(width: 160, height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.appTextMuted.opacity(0.14))
                    .frame(width: 110, height: 12)
            }
            .shimmering()

            Text("Loading nothing…")
                .font(.footnote)
                .foregroundStyle(Color.appTextMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}
