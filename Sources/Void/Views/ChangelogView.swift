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
                ShadcnBadge(text: entry.tag.rawValue, tone: tone(for: entry.tag))
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

    private func tone(for tag: ChangelogTag) -> ShadcnBadge.Tone {
        switch tag {
        case .feature: return .accent
        case .improvement: return .success
        case .fix: return .warning
        case .removed: return .danger
        }
    }
}
