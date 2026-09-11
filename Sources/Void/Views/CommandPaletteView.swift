import SwiftUI
import VoidCore

private struct PaletteCommand: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let symbolName: String
    let action: () -> Void
}

struct CommandPaletteView: View {
    var store: NothingStore
    @Binding var selection: AppSection

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: Metrics.spacingSM) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.appTextMuted)
                    TextField("Type a command…", text: $query)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                }
                .padding(Metrics.spacingMD)

                Divider()

                List(filteredCommands) { command in
                    Button {
                        command.action()
                        dismiss()
                    } label: {
                        HStack(spacing: Metrics.spacingMD) {
                            Image(systemName: command.symbolName)
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 20)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(command.title)
                                if let subtitle = command.subtitle {
                                    Text(subtitle)
                                        .font(.caption)
                                        .foregroundStyle(Color.appTextMuted)
                                }
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Commands")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var commands: [PaletteCommand] {
        var items: [PaletteCommand] = [
            PaletteCommand(title: "Do Nothing", subtitle: "Log one instance of nothing", symbolName: "circle.dashed") {
                store.logNothing()
            }
        ]
        items.append(contentsOf: AppSection.allCases.map { section in
            PaletteCommand(title: "Go to \(section.title)", subtitle: nil, symbolName: section.symbolName) {
                selection = section
            }
        })
        items.append(
            PaletteCommand(title: "Reset progress", subtitle: "Deletes your entire history", symbolName: "trash") {
                store.reset()
            }
        )
        return items
    }

    private var filteredCommands: [PaletteCommand] {
        guard !query.isEmpty else { return commands }
        return commands.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
