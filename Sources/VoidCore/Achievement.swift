import Foundation

public enum AchievementRequirement: Equatable, Sendable {
    case totalClicks(Int)
    case streak(Int)

    /// A short, human-readable description of the goal, e.g. "50 clicks" or "7-day streak".
    public var goalDescription: String {
        switch self {
        case .totalClicks(let count):
            return "\(count) click".pluralized(count)
        case .streak(let days):
            return "\(days)-day streak"
        }
    }

    /// Progress toward this requirement, clamped to 0...1.
    public func progress(totalClicks: Int, currentStreak: Int, longestStreak: Int) -> Double {
        switch self {
        case .totalClicks(let goal):
            guard goal > 0 else { return 1 }
            return min(1, Double(totalClicks) / Double(goal))
        case .streak(let goal):
            guard goal > 0 else { return 1 }
            return min(1, Double(max(currentStreak, longestStreak)) / Double(goal))
        }
    }

    fileprivate func isMet(totalClicks: Int, longestStreak: Int) -> Bool {
        switch self {
        case .totalClicks(let goal):
            return totalClicks >= goal
        case .streak(let goal):
            return longestStreak >= goal
        }
    }
}

public struct Achievement: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let symbolName: String
    public let requirement: AchievementRequirement

    public init(id: String, title: String, subtitle: String, symbolName: String, requirement: AchievementRequirement) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.requirement = requirement
    }
}

public enum AchievementCatalog {
    /// Every achievement Void has to offer, in display order. Order is also
    /// unlock order for anything at the same tier (clicks before streaks).
    public static let all: [Achievement] = [
        Achievement(
            id: "first-contact",
            title: "First Contact",
            subtitle: "You did nothing, on purpose, for the first time.",
            symbolName: "circle",
            requirement: .totalClicks(1)
        ),
        Achievement(
            id: "getting-comfortable",
            title: "Getting Comfortable",
            subtitle: "Ten instances of deliberate inactivity, logged and verified.",
            symbolName: "circle.lefthalf.filled",
            requirement: .totalClicks(10)
        ),
        Achievement(
            id: "void-apprentice",
            title: "Void Apprentice",
            subtitle: "Fifty clicks. Zero outcomes. Flawless technique.",
            symbolName: "moon.stars",
            requirement: .totalClicks(50)
        ),
        Achievement(
            id: "creature-of-habit",
            title: "Creature of Habit",
            subtitle: "Did nothing three days in a row. A pattern is emerging.",
            symbolName: "flame",
            requirement: .streak(3)
        ),
        Achievement(
            id: "nothing-enthusiast",
            title: "Nothing Enthusiast",
            subtitle: "One hundred clicks deep into the void.",
            symbolName: "sparkles",
            requirement: .totalClicks(100)
        ),
        Achievement(
            id: "touch-grass-reminder",
            title: "Touch Grass Reminder",
            subtitle: "Seven-day streak of doing nothing. Please consider doing something.",
            symbolName: "leaf",
            requirement: .streak(7)
        ),
        Achievement(
            id: "master-of-the-void",
            title: "Master of the Void",
            subtitle: "Five hundred clicks. You have transcended productivity.",
            symbolName: "infinity",
            requirement: .totalClicks(500)
        ),
        Achievement(
            id: "the-long-game",
            title: "The Long Game",
            subtitle: "Thirty consecutive days of unwavering commitment to nothing.",
            symbolName: "calendar",
            requirement: .streak(30)
        ),
        Achievement(
            id: "enlightened",
            title: "Enlightened",
            subtitle: "One thousand clicks. There is nothing left to achieve, which was always the point.",
            symbolName: "eye",
            requirement: .totalClicks(1000)
        ),
    ]

    /// Achievements whose requirement is currently met.
    public static func unlocked(totalClicks: Int, longestStreak: Int) -> [Achievement] {
        all.filter { $0.requirement.isMet(totalClicks: totalClicks, longestStreak: longestStreak) }
    }

    /// Given a previous and a new stat snapshot, the achievements that were
    /// newly unlocked by the transition (used to trigger celebratory UI).
    public static func newlyUnlocked(
        previousTotalClicks: Int,
        previousLongestStreak: Int,
        newTotalClicks: Int,
        newLongestStreak: Int
    ) -> [Achievement] {
        let before = Set(unlocked(totalClicks: previousTotalClicks, longestStreak: previousLongestStreak).map(\.id))
        return unlocked(totalClicks: newTotalClicks, longestStreak: newLongestStreak)
            .filter { !before.contains($0.id) }
    }
}

extension String {
    /// Minimal pluralizer for the small vocabulary this app needs ("1 click" / "10 clicks").
    fileprivate func pluralized(_ count: Int) -> String {
        count == 1 ? self : self + "s"
    }
}
