import SwiftUI
import VoidCore

struct ChangelogView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacingLG) {
                header
                ForEach(Changelog.entries) { entry in
                    entryRow(entry)
                }
            }
            .padding(Metrics.spacingXL)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(Color.appBackground)
        .navigationTitle("Changelog")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingXS) {
            Text("Changelog")
                .font(.system(size: 26, weight: .bold))
            Text("A complete, meticulously maintained record of nothing changing much.")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func entryRow(_ entry: ChangelogEntry) -> some View {
        VStack(alignment: .leading, spacing: Metrics.spacingSM) {
            HStack(spacing: Metrics.spacingSM) {
                Text("v\(entry.version)")
                    .monospacedLabel(13, weight: .semibold)
                tagPill(entry.tag)
                Spacer()
                Text(entry.date)
                    .font(.caption)
                    .foregroundStyle(Color.appTextMuted)
            }
            Text(entry.summary)
                .font(.callout)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .cardBackground()
    }

    private func tagPill(_ tag: ChangelogTag) -> some View {
        Text(tag.rawValue)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, Metrics.spacingSM)
            .padding(.vertical, 2)
            .background(tagColor(tag).opacity(0.15))
            .foregroundStyle(tagColor(tag))
            .clipShape(Capsule())
    }

    private func tagColor(_ tag: ChangelogTag) -> Color {
        switch tag {
        case .feature: return .accentColor
        case .improvement: return .appSuccess
        case .fix: return .appWarning
        case .removed: return .appDanger
        }
    }
}
