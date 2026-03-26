import SwiftUI

@main
struct ShellForgeApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Connection") {
                    appState.showNewHost = true
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("New Tab") {
                    appState.addTab()
                }
                .keyboardShortcut("t", modifiers: .command)

                Divider()

                Button("Import from ~/.ssh/config") {
                    appState.importSSHConfig()
                }
                .keyboardShortcut("i", modifiers: [.command, .shift])
            }

            CommandGroup(after: .textEditing) {
                Button("Find in Terminal") {
                    appState.showSearch = true
                }
                .keyboardShortcut("f", modifiers: .command)
            }
        }

        Settings {
            SettingsView()
                .environmentObject(appState)
        }
    }
}
