import Foundation

enum Streaks {

    static func current(
        for dates: [Date],
        asOf referenceDate: Date,
        calendar: Calendar = .current
    ) -> Int {
        let days = Set(dates.map { calendar.startOfDay(for: $0) })
        var streak = 0
        var cursor = calendar.startOfDay(for: referenceDate)
        while days.contains(cursor) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previousDay
        }
        return streak
    }

    static func longest(for dates: [Date], calendar: Calendar = .current) -> Int {
        guard !dates.isEmpty else { return 0 }
        let days = Set(dates.map { calendar.startOfDay(for: $0) }).sorted()

        var longest = 1
        var running = 1
        for index in 1..<days.count {
            let previous = days[index - 1]
            let day = days[index]
            if let expected = calendar.date(byAdding: .day, value: 1, to: previous),
               calendar.isDate(expected, inSameDayAs: day) {
                running += 1
            } else {
                running = 1
            }
            longest = max(longest, running)
        }
        return longest
    }
}
