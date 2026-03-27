import SwiftUI

struct HostEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State var host: Host
    var onSave: (Host) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("hostEditor.connection") {
                    TextField("hostEditor.alias", text: $host.alias, prompt: Text("hostEditor.aliasPrompt"))
                    TextField("hostEditor.hostname", text: $host.hostname, prompt: Text("hostEditor.hostnamePrompt"))
                    HStack {
                        TextField("hostEditor.username", text: $host.username)
                        TextField("hostEditor.port", value: $host.port, format: .number)
                            .frame(width: 80)
                    }
                }

                Section("hostEditor.auth") {
                    Picker("hostEditor.method", selection: $host.authMethod) {
                        Text("hostEditor.publicKey").tag(AuthMethod.publicKey)
                        Text("hostEditor.password").tag(AuthMethod.password)
                        Text("hostEditor.keyboardInteractive").tag(AuthMethod.keyboardInteractive)
                    }

                    if host.authMethod == .password {
                        SecureField("hostEditor.password", text: Binding(
                            get: { host.password ?? "" },
                            set: { host.password = $0.isEmpty ? nil : $0 }
                        ))
                    }

                    if host.authMethod == .publicKey {
                        HStack {
                            TextField("hostEditor.keyPath", text: Binding(
                                get: { host.keyPath ?? "" },
                                set: { host.keyPath = $0.isEmpty ? nil : $0 }
                            ), prompt: Text("hostEditor.keyPathPrompt"))

                            Button("hostEditor.browse") {
                                browseKey()
                            }
                        }
                    }
                }

                Section("hostEditor.organization") {
                    TextField("hostEditor.tags", text: Binding(
                        get: { host.tags.joined(separator: ", ") },
                        set: { host.tags = $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                    ))

                    TextField("hostEditor.notes", text: Binding(
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
                Button("hostEditor.cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("hostEditor.save") {
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
