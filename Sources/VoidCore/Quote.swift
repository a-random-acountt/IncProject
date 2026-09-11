import Foundation

public struct Quote: Identifiable, Equatable, Sendable {
    public var id: String { text }
    public let text: String
    public let attribution: String

    public init(_ text: String, attribution: String) {
        self.text = text
        self.attribution = attribution
    }
}

public enum QuoteBook {
    public static let all: [Quote] = [
        Quote("The master of nothing is the master of everything.", attribution: "Unknown, probably napping"),
        Quote("Somewhere, someone is doing something. Not you. Not right now.", attribution: "Void"),
        Quote("Productivity is a rumor. You've chosen peace.", attribution: "Void"),
        Quote("An empty inbox is nice. An empty agenda is better.", attribution: "Void"),
        Quote("You miss 100% of the tasks you don't start.", attribution: "Wayne Gretzky's less ambitious cousin"),
        Quote("Rest is not the reward for the work. Here, there is no work.", attribution: "Void"),
        Quote("Every great empire eventually did nothing. You're just getting there faster.", attribution: "Void"),
        Quote("The button does not judge you.", attribution: "Void"),
        Quote("Nothing is happening, and that is exactly on schedule.", attribution: "Void"),
        Quote("Diligence is overrated. Consistency, on the other hand, is everything.", attribution: "Void"),
        Quote("You have achieved a flow state. The flow is nothing.", attribution: "Void"),
        Quote("Somewhere a to-do list grows. Yours remains empty by design.", attribution: "Void"),
        Quote("This is the one meeting that could have been an email, and it wasn't even that.", attribution: "Void"),
        Quote("A journey of a thousand miles begins with a single step you are not taking.", attribution: "Lao Tzu, loosely"),
        Quote("Silence is golden. So is this button.", attribution: "Void"),
        Quote("You are not procrastinating. You are practicing.", attribution: "Void"),
        Quote("There are no bugs in nothing. There is also no software.", attribution: "Void"),
        Quote("The void stares back, mostly out of boredom.", attribution: "Void"),
        Quote("Somewhere, a KPI dashboard is red. Yours is beautifully, perpetually flat.", attribution: "Void"),
        Quote("Enlightenment is just very well-organized nothing.", attribution: "Void"),
    ]

    /// A deterministic quote for a given date, so it stays stable across
    /// renders within the same day instead of flickering on every relaunch.
    public static func quoteOfTheDay(for date: Date, calendar: Calendar = .current) -> Quote {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = dayOfYear % all.count
        return all[index]
    }
}
