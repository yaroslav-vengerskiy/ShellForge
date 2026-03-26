import SwiftUI

struct HostEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State var host: Host
    var onSave: (Host) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("Connection") {
                    TextField("Alias", text: $host.alias, prompt: Text("my-server"))
                    TextField("Hostname", text: $host.hostname, prompt: Text("192.168.1.1 or example.com"))
                    HStack {
                        TextField("Username", text: $host.username)
                        TextField("Port", value: $host.port, format: .number)
                            .frame(width: 80)
                    }
                }

                Section("Authentication") {
                    Picker("Method", selection: $host.authMethod) {
                        Text("Public Key").tag(AuthMethod.publicKey)
                        Text("Password").tag(AuthMethod.password)
                        Text("Keyboard Interactive").tag(AuthMethod.keyboardInteractive)
                    }

                    if host.authMethod == .publicKey {
                        HStack {
                            TextField("Key Path", text: Binding(
                                get: { host.keyPath ?? "" },
                                set: { host.keyPath = $0.isEmpty ? nil : $0 }
                            ), prompt: Text("~/.ssh/id_ed25519"))

                            Button("Browse") {
                                browseKey()
                            }
                        }
                    }
                }

                Section("Organization") {
                    TextField("Tags (comma separated)", text: Binding(
                        get: { host.tags.joined(separator: ", ") },
                        set: { host.tags = $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                    ))

                    TextField("Notes", text: Binding(
                        get: { host.notes ?? "" },
                        set: { host.notes = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(3...6)
                }
            }
            .formStyle(.grouped)
            .padding()

            Divider()

            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Save") {
                    onSave(host)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(host.hostname.isEmpty)
            }
            .padding()
        }
        .frame(width: 480, height: 520)
    }

    private func browseKey() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.directoryURL = URL(fileURLWithPath: NSString(string: "~/.ssh").expandingTildeInPath)
        if panel.runModal() == .OK, let url = panel.url {
            host.keyPath = url.path
        }
    }
}
