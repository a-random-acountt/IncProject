import SwiftUI

struct StatTile: View {
    let label: String
    let value: String
    var caption: String? = nil
    var symbolName: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingSM) {
            HStack(spacing: Metrics.spacingXS) {
                if let symbolName {
                    Image(systemName: symbolName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Text(value)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.primary)
            if let caption {
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(Color.appTextMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }
}
