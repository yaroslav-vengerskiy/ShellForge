import XCTest
@testable import ShellForge

final class HostStoreTests: XCTestCase {
    func testSSHConfigParser() {
        let parser = SSHConfigParser()
        // Parser should not crash on missing file
        let hosts = parser.parse(at: "/nonexistent/path")
        XCTAssertTrue(hosts.isEmpty)
    }

    func testHostDisplayName() {
        let host1 = Host(alias: "prod-server", hostname: "10.0.0.1", username: "deploy")
        XCTAssertEqual(host1.displayName, "prod-server")

        let host2 = Host(hostname: "10.0.0.2", username: "root")
        XCTAssertEqual(host2.displayName, "root@10.0.0.2")
    }

    func testHostSearch() {
        let store = HostStore()
        store.hosts = [
            Host(alias: "web-prod", hostname: "10.0.0.1", username: "deploy", tags: ["production"]),
            Host(alias: "db-staging", hostname: "10.0.0.2", username: "admin", tags: ["staging"]),
        ]

        XCTAssertEqual(store.search("prod").count, 1)
        XCTAssertEqual(store.search("10.0.0").count, 2)
        XCTAssertEqual(store.search("staging").count, 1)
        XCTAssertEqual(store.search("").count, 2)
    }
}
