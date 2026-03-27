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
                Button(String(localized: "menu.newConnection")) {
                    appState.showNewHost = true
                }
                .keyboardShortcut("n", modifiers: .command)

                Button(String(localized: "menu.newTab")) {
                    appState.addTab()
                }
                .keyboardShortcut("t", modifiers: .command)

                Divider()

                Button(String(localized: "menu.importSSH")) {
                    appState.importSSHConfig()
                }
                .keyboardShortcut("i", modifiers: [.command, .shift])
            }

            CommandGroup(after: .textEditing) {
                Button(String(localized: "menu.findInTerminal")) {
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
