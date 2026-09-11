import Foundation

enum AppSection: String, CaseIterable, Identifiable, Hashable {
    case home
    case analytics
    case achievements
    case history
    case changelog
    case settings

    var id: String { rawValue }

    static let primary: [AppSection] = [.home, .analytics, .achievements, .history]
    static let secondary: [AppSection] = [.changelog, .settings]

    var title: String {
        switch self {
        case .home: return "Home"
        case .analytics: return "Analytics"
        case .achievements: return "Achievements"
        case .history: return "History"
        case .changelog: return "Changelog"
        case .settings: return "Settings"
        }
    }

    var symbolName: String {
        switch self {
        case .home: return "circle.hexagongrid.circle"
        case .analytics: return "chart.xyaxis.line"
        case .achievements: return "rosette"
        case .history: return "clock.arrow.circlepath"
        case .changelog: return "doc.text"
        case .settings: return "gearshape"
        }
    }

    /// The digit key that jumps here from the command palette / keyboard shortcuts.
    var shortcutKey: Character? {
        switch self {
        case .home: return "1"
        case .analytics: return "2"
        case .achievements: return "3"
        case .history: return "4"
        case .changelog: return "5"
        case .settings: return "6"
        }
    }
}
