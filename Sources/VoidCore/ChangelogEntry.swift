import Foundation

public enum ChangelogTag: String, Sendable {
    case feature = "Feature"
    case improvement = "Improvement"
    case fix = "Fix"
    case removed = "Removed"
}

public struct ChangelogEntry: Identifiable, Sendable {
    public var id: String { version }
    public let version: String
    public let date: String
    public let tag: ChangelogTag
    public let summary: String

    public init(version: String, date: String, tag: ChangelogTag, summary: String) {
        self.version = version
        self.date = date
        self.tag = tag
        self.summary = summary
    }
}

public enum Changelog {
    /// Newest first.
    public static let entries: [ChangelogEntry] = [
        ChangelogEntry(version: "1.6.0", date: "Aug 2, 2026", tag: .removed,
            summary: "Removed the progress bar that implied you were progressing toward something."),
        ChangelogEntry(version: "1.5.2", date: "Jun 14, 2026", tag: .fix,
            summary: "Fixed a bug where the Nothing Button occasionally did something on double-tap. It now reliably does nothing, every time."),
        ChangelogEntry(version: "1.5.0", date: "May 1, 2026", tag: .feature,
            summary: "Added streaks. Nothing, now with consequences for stopping."),
        ChangelogEntry(version: "1.4.0", date: "Mar 19, 2026", tag: .feature,
            summary: "Introduced Achievements. You can now be rewarded for nothing."),
        ChangelogEntry(version: "1.3.0", date: "Feb 8, 2026", tag: .improvement,
            summary: "Analytics redesigned. Now with charts proving, conclusively, that nothing is happening."),
        ChangelogEntry(version: "1.2.1", date: "Jan 15, 2026", tag: .fix,
            summary: "Fixed a rare crash that occurred when users tried to do something."),
        ChangelogEntry(version: "1.2.0", date: "Dec 1, 2025", tag: .feature,
            summary: "Dark mode. Now you can do nothing in the dark."),
        ChangelogEntry(version: "1.1.0", date: "Oct 20, 2025", tag: .feature,
            summary: "Added the Command Palette (⌘K). Search for nothing faster than ever."),
        ChangelogEntry(version: "1.0.0", date: "Sep 9, 2025", tag: .feature,
            summary: "Initial release. One button. No purpose. Total clarity."),
    ]
}
