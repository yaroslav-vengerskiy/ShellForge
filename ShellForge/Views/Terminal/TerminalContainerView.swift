import SwiftUI

struct TerminalContainerView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Tab bar
            TabBarView()

            Divider()

            // Active terminal
            if let activeId = appState.activeTabId,
               let tab = appState.tabs.first(where: { $0.id == activeId }) {
                TerminalView(tab: tab)
                    .id(tab.id)
            } else {
                Text("No active terminal")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct TabBarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(appState.tabs) { tab in
                    TabItemView(tab: tab, isActive: tab.id == appState.activeTabId)
                        .onTapGesture {
                            appState.activeTabId = tab.id
                        }
                }
            }
        }
        .frame(height: 36)
        .background(.bar)
    }
}

struct TabItemView: View {
    let tab: TerminalTab
    let isActive: Bool
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(tab.isConnected ? .green : .secondary)
                .frame(width: 8, height: 8)

            Text(tab.title)
                .font(.callout)
                .lineLimit(1)

            Button {
                appState.closeTab(tab.id)
            } label: {
                Image(systemName: "xmark")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isActive ? Color.accentColor.opacity(0.15) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.horizontal, 2)
    }
}
