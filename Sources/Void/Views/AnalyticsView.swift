import SwiftUI
import Charts
import VoidCore

struct AnalyticsView: View {
    var store: NothingStore

    @State private var selectedDay: Date?

    private var dailyCounts: [(day: Date, count: Int)] { store.stats.dailyCounts }

    private var flatProductivity: [(day: Date, value: Int)] {
        dailyCounts.map { (day: $0.day, value: 0) }
    }

    private var flavorBreakdown: [(flavor: NothingFlavor, count: Int)] {
        NothingFlavor.allCases.map { flavor in
            (flavor: flavor, count: store.stats.flavorCounts[flavor] ?? 0)
        }
    }

    private var selectedDailyCount: (day: Date, count: Int)? {
        guard let selectedDay else { return nil }
        return dailyCounts.first { Calendar.current.isDate($0.day, inSameDayAs: selectedDay) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacingXL) {
                header
                timeSavedTile
                productivityCard
                dailyCountCard
                breakdownCard
            }
            .padding(Metrics.spacingXL)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(Color.appBackground)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingXS) {
            Text("Analytics")
                .font(.system(size: 26, weight: .bold))
            Text("Rigorous, data-driven proof that nothing is happening.")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var timeSavedTile: some View {
        StatTile(
            label: "Time not wasted",
            value: formattedDuration(store.stats.totalClicks * 4),
            caption: "Estimated time you did not spend being productive.",
            symbolName: "hourglass"
        )
    }

    private var productivityCard: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingMD) {
            Text("Productivity over time")
                .font(.headline)

            Chart(flatProductivity, id: \.day) { point in
                LineMark(x: .value("Day", point.day, unit: .day), y: .value("Productivity", point.value))
                    .interpolationMethod(.monotone)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(Color.accentColor)
            }
            .chartYScale(domain: -1...1)
            .chartYAxis {
                AxisMarks(values: [0]) {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 3)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .frame(height: 140)

            Text("Flat. As intended.")
                .font(.caption)
                .foregroundStyle(Color.appTextMuted)
        }
        .cardBackground()
    }

    private var dailyCountCard: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingMD) {
            Text("Nothing logged per day")
                .font(.headline)

            Chart(dailyCounts, id: \.day) { point in
                BarMark(
                    x: .value("Day", point.day, unit: .day),
                    y: .value("Clicks", point.count),
                    width: .fixed(18)
                )
                .cornerRadius(4)
                .foregroundStyle(Color.accentColor.opacity(barOpacity(for: point.day)))
            }
            .chartXSelection(value: $selectedDay)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 3)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .frame(height: 140)

            if let selectedDailyCount {
                HStack {
                    Text(selectedDailyCount.day, format: .dateTime.month(.abbreviated).day().year())
                        .font(.caption.weight(.semibold))
                    Spacer()
                    Text(selectedDailyCount.count == 1 ? "1 click" : "\(selectedDailyCount.count) clicks")
                        .monospacedLabel(13, weight: .semibold)
                }
                .padding(.horizontal, Metrics.spacingMD)
                .padding(.vertical, Metrics.spacingSM)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous))
            } else {
                Text("Tap or drag across the chart to inspect a day.")
                    .font(.caption)
                    .foregroundStyle(Color.appTextMuted)
            }
        }
        .cardBackground()
    }

    private var breakdownCard: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingMD) {
            Text("Where your nothing went")
                .font(.headline)

            HStack(alignment: .top, spacing: Metrics.spacingXL) {
                Chart(flavorBreakdown, id: \.flavor) { item in
                    SectorMark(
                        angle: .value("Count", item.count),
                        innerRadius: .ratio(0.62),
                        angularInset: 2
                    )
                    .cornerRadius(3)
                    .foregroundStyle(by: .value("Flavor", item.flavor.rawValue))
                }
                .chartForegroundStyleScale(
                    domain: NothingFlavor.allCases.map(\.rawValue),
                    range: [Color.appSeries1, Color.appSeries2, Color.appSeries3]
                )
                .chartLegend(.hidden)
                .frame(width: 160, height: 160)

                VStack(alignment: .leading, spacing: Metrics.spacingSM) {
                    ForEach(flavorBreakdown, id: \.flavor) { item in
                        HStack(spacing: Metrics.spacingSM) {
                            Circle()
                                .fill(seriesColor(for: item.flavor))
                                .frame(width: 8, height: 8)
                            Text(item.flavor.rawValue)
                                .font(.caption)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("\(item.count)")
                                .monospacedLabel(12, weight: .semibold)
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if flavorBreakdown.allSatisfy({ $0.count == 0 }) {
                Text("No nothing logged yet. Head to Home and get started.")
                    .font(.caption)
                    .foregroundStyle(Color.appTextMuted)
            }
        }
        .cardBackground()
    }

    private func barOpacity(for day: Date) -> Double {
        guard let selectedDay else { return 1 }
        return Calendar.current.isDate(day, inSameDayAs: selectedDay) ? 1 : 0.35
    }

    private func seriesColor(for flavor: NothingFlavor) -> Color {
        switch flavor {
        case .morning: return .appSeries1
        case .afternoon: return .appSeries2
        case .evening: return .appSeries3
        }
    }

    private func formattedDuration(_ seconds: Int) -> String {
        guard seconds > 0 else { return "0s" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = seconds < 3600 ? [.minute, .second] : [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter.string(from: TimeInterval(seconds)) ?? "0s"
    }
}
