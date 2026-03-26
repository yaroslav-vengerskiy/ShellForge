import SwiftUI
import SwiftTerm

struct TerminalView: NSViewRepresentable {
    let tab: TerminalTab

    func makeNSView(context: Context) -> LocalProcessTerminalView {
        let terminal = LocalProcessTerminalView(frame: .zero)
        terminal.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)

        // Configure terminal
        let env = ProcessInfo.processInfo.environment
        var shellEnv = env.map { "\($0.key)=\($0.value)" }
        shellEnv.append("TERM=xterm-256color")

        // Determine shell
        let shell = env["SHELL"] ?? "/bin/zsh"

        // Start local process (for now; SSH will be added via SSHService)
        terminal.startProcess(
            executable: shell,
            args: [],
            environment: shellEnv,
            execName: shell
        )

        return terminal
    }

    func updateNSView(_ nsView: LocalProcessTerminalView, context: Context) {
        // No dynamic updates needed for now
    }
}
