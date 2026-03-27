import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedFilter: SidebarFilter = .all

    enum SidebarFilter: String, CaseIterable {
        case all
        case recent
        case tags

        var title: LocalizedStringKey {
            switch self {
            case .all: return "sidebar.filter.all"
            case .recent: return "sidebar.filter.recent"
            case .tags: return "sidebar.filter.tags"
            }
        }
    }

    var filteredHosts: [Host] {
        let hosts = appState.hostStore.search(searchText)
        switch selectedFilter {
        case .all:
            return hosts
        case .recent:
            return hosts
                .filter { $0.lastConnected != nil }
                .sorted { ($0.lastConnected ?? .distantPast) > ($1.lastConnected ?? .distantPast) }
        case .tags:
            return hosts
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedFilter) {
                ForEach(SidebarFilter.allCases, id: \.self) { filter in
                    Text(filter.title).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(8)

            List(selection: $appState.selectedHost) {
                if selectedFilter == .tags {
                    ForEach(appState.hostStore.allTags, id: \.self) { tag in
                        Section(tag) {
                            ForEach(appState.hostStore.hosts(withTag: tag)) { host in
                                HostRowView(host: host)
                                    .tag(host)
                            }
                        }
                    }
                } else {
                    ForEach(filteredHosts) { host in
                        HostRowView(host: host)
                            .tag(host)
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $searchText, prompt: Text("sidebar.search"))
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    appState.showNewHost = true
                } label: {
                    Label("sidebar.addHost", systemImage: "plus")
                }
                .buttonStyle(.borderless)

                Spacer()

                Text("\(appState.hostStore.hosts.count) hosts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
        }
        .onChange(of: appState.selectedHost) { _, host in
            if let host {
                appState.connectToHost(host)
            }
        }
        .frame(minWidth: 220)
    }
}

struct HostRowView: View {
    let host: Host

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: host.icon ?? "server.rack")
                .foregroundStyle(hostColor)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(host.displayName)
                    .fontWeight(.medium)

                Text("\(host.username)@\(host.hostname):\(host.port)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private var hostColor: Color {
        if let hex = host.color {
            return Color(hex: hex)
        }
        return .accentColor
    }
}
