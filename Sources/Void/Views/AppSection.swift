import Foundation

/// One case per bottom tab. Changelog lives inside Settings instead of
/// getting its own tab slot - five is the most a bottom tab bar should hold
/// before iOS folds the rest into an overflow "More" tab.
enum AppSection: String, CaseIterable, Identifiable, Hashable {
    case home
    case analytics
    case achievements
    case history
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .analytics: return "Analytics"
        case .achievements: return "Achievements"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }

    var symbolName: String {
        switch self {
        case .home: return "circle.hexagongrid.circle"
        case .analytics: return "chart.xyaxis.line"
        case .achievements: return "rosette"
        case .history: return "clock.arrow.circlepath"
        case .settings: return "gearshape"
        }
    }
}
