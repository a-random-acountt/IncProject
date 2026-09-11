import SwiftUI
import VoidCore

struct HistoryView: View {
    var store: NothingStore

    var body: some View {
        Group {
            if store.events.isEmpty {
                ContentUnavailableView(
                    "No history yet",
                    systemImage: "clock",
                    description: Text("Go do some nothing on the Home tab, and it'll show up here.")
                )
            } else {
                List {
                    ForEach(groupedEvents, id: \.label) { group in
                        Section(group.label) {
                            ForEach(group.events) { event in
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundStyle(Color.appTextMuted)
                                    Text("Did nothing.")
                                    Spacer()
                                    Text(event.date, format: .dateTime.hour().minute())
                                        .monospacedLabel(13, weight: .regular)
                                        .foregroundStyle(Color.appTextMuted)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Color.appBackground)
    }

    private var groupedEvents: [(label: String, events: [NothingEvent])] {
        let calendar = Calendar.current
        let sorted = store.events.sorted { $0.date > $1.date }
        let grouped = Dictionary(grouping: sorted) { event in
            calendar.startOfDay(for: event.date)
        }
        return grouped.keys.sorted(by: >).map { day in
            (label: dayLabel(for: day, calendar: calendar), events: grouped[day] ?? [])
        }
    }

    private func dayLabel(for day: Date, calendar: Calendar) -> String {
        if calendar.isDateInToday(day) { return "Today" }
        if calendar.isDateInYesterday(day) { return "Yesterday" }
        return day.formatted(.dateTime.month(.wide).day().year())
    }
}
