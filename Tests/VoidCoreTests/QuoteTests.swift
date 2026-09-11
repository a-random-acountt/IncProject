import Testing
import Foundation
@testable import VoidCore

@Suite("QuoteBook")
struct QuoteTests {
    @Test("Quote of the day is stable for the same calendar day")
    func quoteIsStableWithinADay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let morning = calendar.date(from: DateComponents(year: 2026, month: 9, day: 11, hour: 6))!
        let night = calendar.date(from: DateComponents(year: 2026, month: 9, day: 11, hour: 23))!

        let quoteMorning = QuoteBook.quoteOfTheDay(for: morning, calendar: calendar)
        let quoteNight = QuoteBook.quoteOfTheDay(for: night, calendar: calendar)
        #expect(quoteMorning == quoteNight)
    }

    @Test("Every quote has non-empty text and attribution")
    func catalogIsWellFormed() {
        #expect(!QuoteBook.all.isEmpty)
        for quote in QuoteBook.all {
            #expect(!quote.text.isEmpty)
            #expect(!quote.attribution.isEmpty)
        }
    }
}

@Suite("Changelog")
struct ChangelogTests {
    @Test("Entries are non-empty and each carries real copy")
    func catalogIsWellFormed() {
        #expect(!Changelog.entries.isEmpty)
        for entry in Changelog.entries {
            #expect(!entry.version.isEmpty)
            #expect(!entry.summary.isEmpty)
        }
    }
}
