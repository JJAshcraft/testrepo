import SwiftUI

struct SwipeDeckView: View {
    @EnvironmentObject var store: Store
    @State private var composing: Rival?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.orange.opacity(0.25), .pink.opacity(0.2)],
                               startPoint: .top, endPoint: .bottom).ignoresSafeArea()

                if store.deck.isEmpty {
                    VStack(spacing: 12) {
                        Text("😈").font(.system(size: 64))
                        Text("Out of victims. For now.").font(.title3.bold())
                        Button("Bring back the ones I passed") { store.resetDeck() }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    // Show top 3 cards, only the top one is draggable.
                    ForEach(Array(store.deck.prefix(3).enumerated().reversed()), id: \.element.id) { index, rival in
                        RivalCard(rival: rival,
                                  isTop: index == 0,
                                  onSpite: { composing = rival },
                                  onPass: { store.pass(rival) })
                            .scaleEffect(1 - CGFloat(index) * 0.04)
                            .offset(y: CGFloat(index) * 12)
                    }
                }
            }
            .navigationTitle("Spiteful")
            .sheet(item: $composing) { rival in
                ComposeView(rival: rival)
            }
        }
    }
}

struct RivalCard: View {
    let rival: Rival
    let isTop: Bool
    let onSpite: () -> Void
    let onPass: () -> Void

    @State private var offset: CGSize = .zero

    var body: some View {
        VStack(spacing: 16) {
            Text(rival.emoji).font(.system(size: 90))
            Text(rival.name).font(.largeTitle.bold())
            Text("Working on: \(rival.project)")
                .font(.headline).foregroundStyle(.secondary)
            Text("Opted in to friendly spite ✅")
                .font(.caption).padding(6)
                .background(.green.opacity(0.2), in: Capsule())
        }
        .frame(maxWidth: .infinity, minHeight: 380)
        .background(.background, in: RoundedRectangle(cornerRadius: 28))
        .shadow(radius: 8)
        .overlay(alignment: .topLeading) { stamp("SPITE 🔥", .orange, opacity: offset.width > 0 ? Double(offset.width) / 120 : 0) }
        .overlay(alignment: .topTrailing) { stamp("PASS", .gray, opacity: offset.width < 0 ? Double(-offset.width) / 120 : 0) }
        .padding(.horizontal, 24)
        .offset(x: offset.width, y: offset.height * 0.2)
        .rotationEffect(.degrees(Double(offset.width) / 20))
        .gesture(isTop ? drag : nil)
        .animation(.spring(), value: offset)
    }

    private func stamp(_ text: String, _ color: Color, opacity: Double) -> some View {
        Text(text).font(.title.bold()).foregroundStyle(color)
            .padding(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 3))
            .rotationEffect(.degrees(-12)).padding(24).opacity(min(opacity, 1))
    }

    private var drag: some Gesture {
        DragGesture()
            .onChanged { offset = $0.translation }
            .onEnded { value in
                if value.translation.width > 120 {
                    offset = .zero
                    onSpite()
                } else if value.translation.width < -120 {
                    onPass()
                } else {
                    offset = .zero
                }
            }
    }
}
