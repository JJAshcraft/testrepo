import SwiftUI

struct RivalsView: View {
    @EnvironmentObject var store: Store
    @State private var adding = false
    @State private var name = ""
    @State private var emoji = "😈"
    @State private var project = ""
    @State private var consent = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.rivals) { rival in
                    HStack {
                        Text(rival.emoji).font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(rival.name).font(.headline)
                            Text(rival.project).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { store.rivals.remove(atOffsets: $0) }
            }
            .navigationTitle("Rivals")
            .toolbar { Button { adding = true } label: { Image(systemName: "plus") } }
            .sheet(isPresented: $adding) {
                NavigationStack {
                    Form {
                        TextField("Name", text: $name)
                        TextField("Emoji", text: $emoji)
                        TextField("What are they working on?", text: $project)
                        Toggle("They're in on the bit (they said yes)", isOn: $consent)
                        Text("Spite only works between people who both want it. No yes, no ribbing.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    .navigationTitle("New rival")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) { Button("Cancel") { adding = false } }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                store.addRival(name: name, emoji: emoji, project: project)
                                name = ""; project = ""; consent = false
                                adding = false
                            }
                            .disabled(name.isEmpty || !consent || !RibGenerator.isSafe(name + project))
                        }
                    }
                }
            }
        }
    }
}
