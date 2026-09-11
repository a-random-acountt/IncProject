import SwiftUI
import VoidCore

struct AchievementsView: View {
    var store: NothingStore

    private let columns = [GridItem(.adaptive(minimum: 260), spacing: Metrics.spacingMD)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacingXL) {
                header
                LazyVGrid(columns: columns, spacing: Metrics.spacingMD) {
                    ForEach(AchievementCatalog.all) { achievement in
                        BadgeCard(
                            achievement: achievement,
                            isUnlocked: unlockedIds.contains(achievement.id),
                            progress: achievement.requirement.progress(
                                totalClicks: store.stats.totalClicks,
                                currentStreak: store.stats.currentStreak,
                                longestStreak: store.stats.longestStreak
                            )
                        )
                    }
                }
            }
            .padding(Metrics.spacingXL)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .background(Color.appBackground)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingXS) {
            Text("Achievements")
                .font(.system(size: 26, weight: .bold))
            Text("\(unlockedIds.count) of \(AchievementCatalog.all.count) unlocked. All for nothing.")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var unlockedIds: Set<String> {
        Set(
            AchievementCatalog.unlocked(
                totalClicks: store.stats.totalClicks,
                longestStreak: store.stats.longestStreak
            ).map(\.id)
        )
    }
}
