import SwiftUI

struct DuelsView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationStack {
            List {
                if store.spites.isEmpty {
                    Text("No duels yet. Go swipe someone.").foregroundStyle(.secondary)
                }
                ForEach(store.spites.filter { !$0.done }) { spite in
                    if let rival = store.rival(for: spite) {
                        DuelRow(spite: spite, rival: rival)
                    }
                }
                let finished = store.spites.filter { $0.done }
                if !finished.isEmpty {
                    Section("Finished (gloating allowed)") {
                        ForEach(finished) { spite in
                            Text("\(store.rival(for: spite)?.name ?? "Someone"): \(spite.task) ✅")
                        }
                    }
                }
            }
            .navigationTitle("Duels")
        }
    }
}

struct DuelRow: View {
    @EnvironmentObject var store: Store
    let spite: Spite
    let rival: Rival

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(rival.emoji) \(rival.name)").font(.headline)
                Spacer()
                Text("Round \(spite.round) \(spite.intensity.flames)").font(.caption)
            }
            Text(spite.roast).font(.subheadline)
            Text(spite.followUpAt < Date() ? "Follow up is overdue 👀" : "Follow up \(spite.followUpAt.formatted(.relative(presentation: .named)))")
                .font(.caption).foregroundStyle(spite.followUpAt < Date() ? .red : .secondary)
            HStack {
                Button("Round \(spite.round + 1) 🔥") {
                    let options = RibGenerator.followUps(for: rival, round: spite.round)
                    store.nextRound(spite, roast: options.randomElement() ?? options[0])
                }
                .buttonStyle(.borderedProminent).tint(.orange)
                Button("They did it 🎉") { store.markDone(spite) }
                    .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 4)
    }
}
