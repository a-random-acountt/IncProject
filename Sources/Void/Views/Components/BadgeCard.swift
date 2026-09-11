import SwiftUI
import VoidCore

struct BadgeCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingMD) {
            HStack {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? Color.accentColor.opacity(0.15) : Color.appTextMuted.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: achievement.symbolName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isUnlocked ? Color.accentColor : Color.appTextMuted)
                }
                Spacer()
                if isUnlocked {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.appSuccess)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(Color.appTextMuted)
                }
            }

            VStack(alignment: .leading, spacing: Metrics.spacingXS) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(isUnlocked ? .primary : Color.appTextSecondary)
                Text(achievement.subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.appTextMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !isUnlocked {
                VStack(alignment: .leading, spacing: Metrics.spacingXS) {
                    ProgressView(value: progress)
                        .tint(Color.accentColor)
                    Text(achievement.requirement.goalDescription)
                        .monospacedLabel(11, weight: .regular)
                        .foregroundStyle(Color.appTextMuted)
                }
            }
        }
        .padding(Metrics.spacingLG)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.radiusMD, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.radiusMD, style: .continuous)
                .strokeBorder(isUnlocked ? Color.accentColor.opacity(0.35) : Color.appBorder, lineWidth: Metrics.hairline)
        )
        .opacity(isUnlocked ? 1 : 0.85)
    }
}
