import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            if appState.tabs.isEmpty {
                WelcomeView()
            } else {
                TerminalContainerView()
            }
        }
        .sheet(isPresented: $appState.showNewHost) {
            HostEditorView(host: Host()) { newHost in
                appState.hostStore.add(newHost)
            }
        }
    }
}

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "terminal")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("ShellForge")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Press \(Text("Cmd+N").bold()) to add a host or \(Text("Cmd+T").bold()) for a local terminal")
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Button("New Host") {
                    appState.showNewHost = true
                }

                Button("Local Terminal") {
                    appState.addTab()
                }

                Button("Import ~/.ssh/config") {
                    appState.importSSHConfig()
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
