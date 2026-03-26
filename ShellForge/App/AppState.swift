import SwiftUI
import Combine

final class AppState: ObservableObject {
    // MARK: - Navigation
    @Published var selectedHost: Host?
    @Published var showNewHost = false
    @Published var showSearch = false

    // MARK: - Tabs
    @Published var tabs: [TerminalTab] = []
    @Published var activeTabId: UUID?

    // MARK: - Services
    let hostStore: HostStore
    let sshConfigParser: SSHConfigParser

    init() {
        self.hostStore = HostStore()
        self.sshConfigParser = SSHConfigParser()
    }

    // MARK: - Tab Management

    func addTab(for host: Host? = nil) {
        let tab = TerminalTab(host: host)
        tabs.append(tab)
        activeTabId = tab.id
    }

    func closeTab(_ id: UUID) {
        tabs.removeAll { $0.id == id }
        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
    }

    func connectToHost(_ host: Host) {
        selectedHost = host
        let existing = tabs.first { $0.host?.id == host.id && $0.isConnected }
        if let existing {
            activeTabId = existing.id
        } else {
            addTab(for: host)
        }
    }

    // MARK: - SSH Config Import

    func importSSHConfig() {
        let hosts = sshConfigParser.parse()
        for host in hosts {
            if !hostStore.hosts.contains(where: { $0.hostname == host.hostname && $0.username == host.username }) {
                hostStore.add(host)
            }
        }
    }
}
