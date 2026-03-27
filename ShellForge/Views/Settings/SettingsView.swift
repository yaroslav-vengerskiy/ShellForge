import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    @AppStorage("terminalFontSize") private var fontSize: Double = 14
    @AppStorage("terminalFontName") private var fontName: String = "SF Mono"
    @AppStorage("terminalTheme") private var theme: String = "Default"

    var body: some View {
        TabView {
            Form {
                Section("settings.font") {
                    Picker(String(localized: "settings.font"), selection: $fontName) {
                        Text("SF Mono").tag("SF Mono")
                        Text("Menlo").tag("Menlo")
                        Text("JetBrains Mono").tag("JetBrains Mono")
                        Text("Fira Code").tag("Fira Code")
                    }

                    Slider(value: $fontSize, in: 10...24, step: 1) {
                        Text("settings.fontSize \(Int(fontSize))")
                    }
                }

                Section("settings.theme") {
                    Picker(String(localized: "settings.theme"), selection: $theme) {
                        Text("Default").tag("Default")
                        Text("Dracula").tag("Dracula")
                        Text("Solarized Dark").tag("Solarized Dark")
                        Text("Nord").tag("Nord")
                        Text("One Dark").tag("One Dark")
                    }
                }
            }
            .formStyle(.grouped)
            .tabItem { Label("settings.terminal", systemImage: "terminal") }

            Form {
                Section("settings.ssh") {
                    Toggle(String(localized: "settings.autoReconnect"), isOn: .constant(true))
                    Toggle(String(localized: "settings.keepAlive"), isOn: .constant(true))
                }
            }
            .formStyle(.grouped)
            .tabItem { Label("settings.general", systemImage: "gear") }
        }
        .frame(width: 450, height: 350)
    }
}
