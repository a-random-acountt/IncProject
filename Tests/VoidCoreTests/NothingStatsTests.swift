import Testing
import Foundation
@testable import VoidCore

private func utcCalendar() -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    return calendar
}

private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int, calendar: Calendar) -> Date {
    calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
}

@Suite("NothingStats")
struct NothingStatsTests {
    @Test("Flavor counts bucket events by hour of day")
    func flavorCountsBucketByHour() {
        let calendar = utcCalendar()
        let events = [
            NothingEvent(date: date(2026, 9, 11, hour: 8, calendar: calendar)),   // morning
            NothingEvent(date: date(2026, 9, 11, hour: 14, calendar: calendar)),  // afternoon
            NothingEvent(date: date(2026, 9, 11, hour: 22, calendar: calendar)),  // evening
            NothingEvent(date: date(2026, 9, 11, hour: 1, calendar: calendar)),   // evening (post-midnight)
        ]
        let stats = NothingStats.compute(from: events, asOf: date(2026, 9, 11, hour: 23, calendar: calendar), calendar: calendar)
        #expect(stats.flavorCounts[.morning] == 1)
        #expect(stats.flavorCounts[.afternoon] == 1)
        #expect(stats.flavorCounts[.evening] == 2)
    }

    @Test("Empty snapshot has every flavor present at zero")
    func emptySnapshotHasAllFlavorsZeroed() {
        let stats = NothingStats.empty(calendar: utcCalendar())
        #expect(stats.totalClicks == 0)
        for flavor in NothingFlavor.allCases {
            #expect(stats.flavorCounts[flavor] == 0)
        }
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
