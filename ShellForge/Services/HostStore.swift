import Foundation
import Combine

final class HostStore: ObservableObject {
    @Published var hosts: [Host] = []
    @Published var groups: [HostGroup] = []

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("ShellForge", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("hosts.json")
        load()
    }

    // MARK: - CRUD

    func add(_ host: Host) {
        hosts.append(host)
        save()
    }

    func update(_ host: Host) {
        if let idx = hosts.firstIndex(where: { $0.id == host.id }) {
            hosts[idx] = host
            save()
        }
    }

    func delete(_ host: Host) {
        hosts.removeAll { $0.id == host.id }
        save()
    }

    func addGroup(_ group: HostGroup) {
        groups.append(group)
        save()
    }

    // MARK: - Queries

    func hosts(in groupId: UUID?) -> [Host] {
        hosts.filter { $0.groupId == groupId }
    }

    func hosts(withTag tag: String) -> [Host] {
        hosts.filter { $0.tags.contains(tag) }
    }

    func search(_ query: String) -> [Host] {
        guard !query.isEmpty else { return hosts }
        let q = query.lowercased()
        return hosts.filter {
            $0.alias.lowercased().contains(q) ||
            $0.hostname.lowercased().contains(q) ||
            $0.username.lowercased().contains(q) ||
            $0.tags.contains(where: { $0.lowercased().contains(q) })
        }
    }

    var allTags: [String] {
        Array(Set(hosts.flatMap(\.tags))).sorted()
    }

    // MARK: - Persistence (JSON file, will migrate to GRDB later)

    private func save() {
        let data = HostData(hosts: hosts, groups: groups)
        if let encoded = try? JSONEncoder().encode(data) {
            try? encoded.write(to: fileURL, options: .atomic)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode(HostData.self, from: data) else { return }
        self.hosts = decoded.hosts
        self.groups = decoded.groups
    }
}

private struct HostData: Codable {
    var hosts: [Host]
    var groups: [HostGroup]
}
