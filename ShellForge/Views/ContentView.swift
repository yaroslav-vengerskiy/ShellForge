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

            Text("welcome.title")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("welcome.subtitle")
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Button(String(localized: "welcome.newHost")) {
                    appState.showNewHost = true
                }

                Button(String(localized: "welcome.localTerminal")) {
                    appState.addTab()
                }

                Button(String(localized: "welcome.importSSH")) {
                    appState.importSSHConfig()
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
