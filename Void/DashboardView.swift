import SwiftUI

struct DashboardView: View {
    let store: NothingStore

    @AppStorage("void.soundEnabled") private var soundEnabled: Bool = true
    @State private var toast: ToastMessage?

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
                VStack(alignment: .leading, spacing: Metrics.spacingXS) {
                    Text(greeting)
                        .font(.system(size: 26, weight: .bold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Your dashboard for accomplishing exactly nothing.")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                NothingButton(action: logNothing)
                    .padding(.vertical, Metrics.spacingMD)

                statGrid
            }
            .padding(Metrics.spacingXL)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(Color.appBackground)
        .toast($toast)
    }

    private var statGrid: some View {
        HStack(spacing: Metrics.spacingMD) {
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
        }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: return "Good morning. Ready to accomplish nothing?"
        case 12..<18: return "Good afternoon. Still nothing on the agenda?"
        default: return "Good evening. Perfect time for nothing."
        }
    }

    private func logNothing() {
        store.logNothing()
        Haptics.tap()
        if soundEnabled { SoundPlayer.playClick() }
        toast = ToastMessage(text: confirmations.randomElement() ?? "Nothing happened.", symbolName: "checkmark.circle")
    }
}
