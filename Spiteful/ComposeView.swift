import SwiftUI

struct ComposeView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    let rival: Rival
    @State private var task = ""
    @State private var intensity: Intensity = .theatrical
    @State private var roast = ""
    @State private var followUpHours = 24.0

    private var safe: Bool { RibGenerator.isSafe(task) && RibGenerator.isSafe(roast) }

    var body: some View {
        NavigationStack {
            Form {
                Section("What are they supposed to do?") {
                    TextField("e.g. finish the painting", text: $task)
                }
                Section("How dramatic?") {
                    Picker("Intensity", selection: $intensity) {
                        ForEach(Intensity.allCases) { Text("\($0.flames) \($0.rawValue)").tag($0) }
                    }.pickerStyle(.segmented)
                }
                Section("The ribbing") {
                    TextEditor(text: $roast).frame(minHeight: 120)
                    Button("Generate one 🎲") {
                        roast = RibGenerator.roast(for: rival, task: task, intensity: intensity)
                    }
                    if !safe {
                        Label("Keep it about the work, not the person. Rewrite that one.", systemImage: "heart.slash")
                            .foregroundStyle(.red).font(.footnote)
                    }
                }
                Section("Follow up in") {
                    Picker("Follow up", selection: $followUpHours) {
                        Text("1 hour").tag(1.0)
                        Text("Tonight").tag(8.0)
                        Text("Tomorrow").tag(24.0)
                        Text("3 days").tag(72.0)
                    }
                }
                Section("Tiny steps for you, too") {
                    ForEach(RibGenerator.nudges(for: task), id: \.self) { Text("• \($0)").font(.footnote) }
                }
            }
            .navigationTitle("Spite \(rival.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send 🔥") {
                        store.spite(rival, task: task, roast: roast, intensity: intensity, followUpIn: followUpHours)
                        dismiss()
                    }
                    .disabled(roast.isEmpty || !safe)
                }
            }
            .onAppear {
                if roast.isEmpty { roast = RibGenerator.roast(for: rival, task: "", intensity: intensity) }
            }
        }
    }
}
