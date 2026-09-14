import Testing
import Foundation
@testable import Void

@Suite("NothingStats")
struct NothingStatsTests {
    @Test("Empty snapshot is zeroed")
    func emptySnapshotIsZeroed() {
        let stats = NothingStats.empty(calendar: utcCalendar())
        #expect(stats.totalClicks == 0)
        #expect(stats.todayClicks == 0)
        #expect(stats.currentStreak == 0)
        #expect(stats.longestStreak == 0)
    }

    @Test("Today's click count only counts today's events")
    func todayCountIsScoped() {
        let calendar = utcCalendar()
        let today = date(2026, 9, 11, hour: 12, calendar: calendar)
        let events = [
            NothingEvent(date: date(2026, 9, 11, hour: 1, calendar: calendar)),
            NothingEvent(date: date(2026, 9, 11, hour: 20, calendar: calendar)),
            NothingEvent(date: date(2026, 9, 10, hour: 20, calendar: calendar)),
        ]
        let stats = NothingStats.compute(from: events, asOf: today, calendar: calendar)
        #expect(stats.todayClicks == 2)
        #expect(stats.totalClicks == 3)
    }
}

@Suite("CompactNumber")
struct CompactNumberTests {
    @Test("Small numbers are grouped with commas, not abbreviated")
    func smallNumbersUseGrouping() {
        #expect(CompactNumber.format(0) == "0")
        #expect(CompactNumber.format(284) == "284")
        #expect(CompactNumber.format(1_284) == "1,284")
    }

    @Test("Thousands abbreviate to one decimal place")
    func thousandsAbbreviate() {
        #expect(CompactNumber.format(12_900) == "12.9K")
        #expect(CompactNumber.format(10_000) == "10K")
    }

    @Test("Millions abbreviate to one decimal place")
    func millionsAbbreviate() {
        #expect(CompactNumber.format(1_200_000) == "1.2M")
    }
}
