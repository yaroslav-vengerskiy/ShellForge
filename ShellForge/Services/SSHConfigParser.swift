import Foundation

struct SSHConfigParser {
    func parse(at path: String = "~/.ssh/config") -> [Host] {
        let expandedPath = NSString(string: path).expandingTildeInPath
        guard let content = try? String(contentsOfFile: expandedPath, encoding: .utf8) else {
            return []
        }

        var hosts: [Host] = []
        var current: [String: String] = [:]
        var currentAlias: String?

        for line in content.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty || trimmed.hasPrefix("#") { continue }

            let parts = trimmed.split(separator: " ", maxSplits: 1).map { String($0) }
            guard parts.count == 2 else { continue }

            let key = parts[0].lowercased()
            let value = parts[1].trimmingCharacters(in: .whitespaces)

            if key == "host" {
                // Save previous host
                if let alias = currentAlias {
                    if let host = buildHost(alias: alias, config: current) {
                        hosts.append(host)
                    }
                }
                currentAlias = value
                current = [:]
            } else {
                current[key] = value
            }
        }

        // Last host
        if let alias = currentAlias, let host = buildHost(alias: alias, config: current) {
            hosts.append(host)
        }

        return hosts.filter { $0.alias != "*" }
    }

    private func buildHost(alias: String, config: [String: String]) -> Host? {
        let hostname = config["hostname"] ?? alias
        guard hostname != "*" else { return nil }

        return Host(
            alias: alias,
            hostname: hostname,
            port: Int(config["port"] ?? "22") ?? 22,
            username: config["user"] ?? "root",
            authMethod: config["identityfile"] != nil ? .publicKey : .password,
            keyPath: config["identityfile"].map { NSString(string: $0).expandingTildeInPath }
        )
    }
}
