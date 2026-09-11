import SwiftUI

struct SidebarView: View {
    @Binding var selection: AppSection?
    var onOpenCommandPalette: () -> Void

    var body: some View {
        List(selection: $selection) {
            Section("Void") {
                ForEach(AppSection.primary) { section in
                    Label(section.title, systemImage: section.symbolName)
                        .tag(section)
                }
            }
            Section("More") {
                ForEach(AppSection.secondary) { section in
                    Label(section.title, systemImage: section.symbolName)
                        .tag(section)
                }
            }
        }
        #if os(macOS)
        .listStyle(.sidebar)
        #endif
        .navigationTitle("Void")
        .safeAreaInset(edge: .bottom) {
            Button(action: onOpenCommandPalette) {
                HStack(spacing: Metrics.spacingSM) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.appTextMuted)
                    Text("Search commands")
                        .foregroundStyle(Color.appTextSecondary)
                    Spacer()
                    Text("⌘K")
                        .monospacedLabel(11, weight: .medium)
                        .foregroundStyle(Color.appTextMuted)
                }
                .padding(.horizontal, Metrics.spacingMD)
                .padding(.vertical, Metrics.spacingSM)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous)
                        .strokeBorder(Color.appBorder, lineWidth: Metrics.hairline)
                )
            }
            .buttonStyle(.plain)
            .padding(Metrics.spacingSM)
        }
    }
}
