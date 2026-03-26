import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    @AppStorage("terminalFontSize") private var fontSize: Double = 14
    @AppStorage("terminalFontName") private var fontName: String = "SF Mono"
    @AppStorage("terminalTheme") private var theme: String = "Default"

    var body: some View {
        TabView {
            // Terminal settings
            Form {
                Section("Font") {
                    Picker("Font", selection: $fontName) {
                        Text("SF Mono").tag("SF Mono")
                        Text("Menlo").tag("Menlo")
                        Text("JetBrains Mono").tag("JetBrains Mono")
                        Text("Fira Code").tag("Fira Code")
                    }

                    Slider(value: $fontSize, in: 10...24, step: 1) {
                        Text("Size: \(Int(fontSize))pt")
                    }
                }

                Section("Theme") {
                    Picker("Theme", selection: $theme) {
                        Text("Default").tag("Default")
                        Text("Dracula").tag("Dracula")
                        Text("Solarized Dark").tag("Solarized Dark")
                        Text("Nord").tag("Nord")
                        Text("One Dark").tag("One Dark")
                    }
                }
            }
            .formStyle(.grouped)
            .tabItem { Label("Terminal", systemImage: "terminal") }

            // General settings
            Form {
                Section("SSH") {
                    Toggle("Auto-reconnect on disconnect", isOn: .constant(true))
                    Toggle("Send keep-alive packets", isOn: .constant(true))
                }
            }
            .formStyle(.grouped)
            .tabItem { Label("General", systemImage: "gear") }
        }
        .frame(width: 450, height: 350)
    }
}
