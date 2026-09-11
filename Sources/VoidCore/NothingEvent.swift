import Foundation

/// A single instance of deliberate inactivity. This is the only kind of
/// event Void ever records.
public struct NothingEvent: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let date: Date

    public init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }
}

/// The three flavors of nothing, assigned by the hour at which the click
/// happened. There is no meaningful difference between them. That is the point.
public enum NothingFlavor: String, CaseIterable, Codable, Sendable {
    case morning = "Morning Nothing"
    case afternoon = "Afternoon Nothing"
    case evening = "Evening Nothing"

    /// Buckets an hour-of-day (0...23) into a flavor.
    /// 5am-noon is morning, noon-6pm is afternoon, everything else is evening.
    public static func forHour(_ hour: Int) -> NothingFlavor {
        switch hour {
        case 5..<12: return .morning
        case 12..<18: return .afternoon
        default: return .evening
        }
    }
}

extension NothingEvent {
    /// The flavor of nothing this event represents, derived from its timestamp.
    public func flavor(calendar: Calendar = .current) -> NothingFlavor {
        let hour = calendar.component(.hour, from: date)
        return NothingFlavor.forHour(hour)
    }
}
