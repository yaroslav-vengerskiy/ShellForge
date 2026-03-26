import Foundation

struct TerminalTab: Identifiable, Equatable {
    let id: UUID
    var host: Host?
    var title: String
    var isConnected: Bool

    init(id: UUID = UUID(), host: Host? = nil) {
        self.id = id
        self.host = host
        self.title = host?.displayName ?? "Local"
        self.isConnected = false
    }

    static func == (lhs: TerminalTab, rhs: TerminalTab) -> Bool {
        lhs.id == rhs.id
    }
}
