import Foundation

enum AuthMethod: String, Codable, CaseIterable {
    case password
    case publicKey
    case keyboardInteractive
}

struct Host: Identifiable, Codable, Hashable {
    var id: UUID
    var alias: String
    var hostname: String
    var port: Int
    var username: String
    var authMethod: AuthMethod
    var password: String?
    var keyPath: String?
    var groupId: UUID?
    var tags: [String]
    var color: String?
    var icon: String?
    var notes: String?
    var proxyJumpId: UUID?
    var preferMosh: Bool
    var lastConnected: Date?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        alias: String = "",
        hostname: String = "",
        port: Int = 22,
        username: String = "root",
        authMethod: AuthMethod = .publicKey,
        password: String? = nil,
        keyPath: String? = nil,
        groupId: UUID? = nil,
        tags: [String] = [],
        color: String? = nil,
        icon: String? = nil,
        notes: String? = nil,
        proxyJumpId: UUID? = nil,
        preferMosh: Bool = false,
        lastConnected: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.alias = alias
        self.hostname = hostname
        self.port = port
        self.username = username
        self.authMethod = authMethod
        self.password = password
        self.keyPath = keyPath
        self.groupId = groupId
        self.tags = tags
        self.color = color
        self.icon = icon
        self.notes = notes
        self.proxyJumpId = proxyJumpId
        self.preferMosh = preferMosh
        self.lastConnected = lastConnected
        self.createdAt = createdAt
    }

    var displayName: String {
        alias.isEmpty ? "\(username)@\(hostname)" : alias
    }
}

struct HostGroup: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var parentId: UUID?
    var icon: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String = "",
        parentId: UUID? = nil,
        icon: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.parentId = parentId
        self.icon = icon
        self.createdAt = createdAt
    }
}
