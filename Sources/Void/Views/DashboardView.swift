import SwiftUI
import VoidCore
import ConfettiSwiftUI

struct DashboardView: View {
    var store: NothingStore

    @AppStorage("void.soundEnabled") private var soundEnabled: Bool = true
    @State private var toast: ToastMessage?
    @State private var confettiTrigger = 0
    @State private var bounceTrigger = 0

    private let confirmations = [
        "Nothing happened.",
        "Still nothing.",
        "As expected: nothing.",
        "Confirmed: nothing.",
        "Nothing, again.",
        "Zero side effects.",
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: Metrics.spacingXL) {
                header

                NothingButton(bounceTrigger: bounceTrigger, action: logNothing)
                    .padding(.vertical, Metrics.spacingMD)

                statGrid
                quoteCard
            }
            .padding(Metrics.spacingXL)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(Color.appBackground)
        .toast($toast)
        .confettiCannon(counter: $confettiTrigger, num: 60, radius: 320)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Metrics.spacingXS) {
            Text(greeting)
                .font(.system(size: 26, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
            Text("Your dashboard for accomplishing exactly nothing.")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: Metrics.spacingMD)], spacing: Metrics.spacingMD) {
            StatTile(
                label: "Total nothing",
                value: CompactNumber.format(store.stats.totalClicks),
                symbolName: "circle.dashed"
            )
            StatTile(
                label: "Current streak",
                value: "\(store.stats.currentStreak)d",
                caption: store.stats.currentStreak == 0 ? "Start one today." : nil,
                symbolName: "flame"
            )
            StatTile(
                label: "Longest streak",
                value: "\(store.stats.longestStreak)d",
                symbolName: "trophy"
            )
            StatTile(
                label: "Global rank",
                value: "#1 of 1",
                caption: "You're the only one being measured.",
                symbolName: "person"
            )
        }
    }

    private var quoteCard: some View {
        let quote = QuoteBook.quoteOfTheDay(for: .now)
        return VStack(alignment: .leading, spacing: Metrics.spacingSM) {
            Label("Thought for the day", systemImage: "quote.opening")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextSecondary)
            Text(quote.text)
                .font(.system(size: 17, weight: .medium))
                .fixedSize(horizontal: false, vertical: true)
            Text("— \(quote.attribution)")
                .font(.caption)
                .foregroundStyle(Color.appTextMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: return "Good morning. Ready to accomplish nothing?"
        case 12..<18: return "Good afternoon. Still nothing on the agenda?"
        default: return "Good evening. Perfect time for nothing."
        }
    }

    private func logNothing() {
        let unlocked = store.logNothing()
        bounceTrigger += 1
        Haptics.tap()
        if soundEnabled { SoundPlayer.playClick() }

        if let achievement = unlocked.first {
            confettiTrigger += 1
            Haptics.success()
            toast = ToastMessage(text: "Achievement unlocked: \(achievement.title)", symbolName: achievement.symbolName)
        } else {
            toast = ToastMessage(text: confirmations.randomElement() ?? "Nothing happened.", symbolName: "checkmark.circle")
        }
    }
}
