import Testing
@testable import VoidCore

@Suite("Achievements")
struct AchievementTests {
    @Test("No unlocks at zero clicks and zero streak")
    func nothingUnlockedAtZero() {
        #expect(AchievementCatalog.unlocked(totalClicks: 0, longestStreak: 0).isEmpty)
    }

    @Test("Click-based achievements unlock at their exact threshold")
    func clickThresholds() {
        let unlockedIds = Set(AchievementCatalog.unlocked(totalClicks: 100, longestStreak: 0).map(\.id))
        #expect(unlockedIds.contains("first-contact"))
        #expect(unlockedIds.contains("getting-comfortable"))
        #expect(unlockedIds.contains("void-apprentice"))
        #expect(unlockedIds.contains("nothing-enthusiast"))
        #expect(!unlockedIds.contains("master-of-the-void"))
    }

    @Test("Streak-based achievements unlock independently of click count")
    func streakThresholds() {
        let unlockedIds = Set(AchievementCatalog.unlocked(totalClicks: 0, longestStreak: 7).map(\.id))
        #expect(unlockedIds.contains("creature-of-habit"))
        #expect(unlockedIds.contains("touch-grass-reminder"))
        #expect(!unlockedIds.contains("the-long-game"))
    }

    @Test("Newly unlocked reports only what crossed the line this time")
    func newlyUnlockedIsADiff() {
        let newlyUnlocked = AchievementCatalog.newlyUnlocked(
            previousTotalClicks: 9,
            previousLongestStreak: 0,
            newTotalClicks: 10,
            newLongestStreak: 0
        )
        #expect(newlyUnlocked.map(\.id) == ["getting-comfortable"])
    }

    @Test("Crossing no threshold unlocks nothing new")
    func noThresholdCrossedMeansNoNewUnlocks() {
        let newlyUnlocked = AchievementCatalog.newlyUnlocked(
            previousTotalClicks: 11,
            previousLongestStreak: 0,
            newTotalClicks: 12,
            newLongestStreak: 0
        )
        #expect(newlyUnlocked.isEmpty)
    }

    @Test("Progress is clamped to 1 past the goal and reads 0 at the start")
    func progressIsClamped() {
        let requirement = AchievementRequirement.totalClicks(50)
        #expect(requirement.progress(totalClicks: 0, currentStreak: 0, longestStreak: 0) == 0)
        #expect(requirement.progress(totalClicks: 25, currentStreak: 0, longestStreak: 0) == 0.5)
        #expect(requirement.progress(totalClicks: 999, currentStreak: 0, longestStreak: 0) == 1)
    }

    @Test("Every achievement has unique id, non-empty copy, and a real SF Symbol name")
    func catalogIsWellFormed() {
        let ids = AchievementCatalog.all.map(\.id)
        #expect(Set(ids).count == ids.count)
        for achievement in AchievementCatalog.all {
            #expect(!achievement.title.isEmpty)
            #expect(!achievement.subtitle.isEmpty)
            #expect(!achievement.symbolName.isEmpty)
        }
    }
}
