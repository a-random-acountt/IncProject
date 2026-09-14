import Foundation

struct NothingEvent: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let date: Date

    init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }
}
