import Foundation
import UserNotifications

@MainActor
final class Store: ObservableObject {
    @Published var rivals: [Rival] = [] { didSet { save() } }
    @Published var spites: [Spite] = [] { didSet { save() } }

    private let rivalsKey = "spiteful.rivals"
    private let spitesKey = "spiteful.spites"

    init() {
        load()
        if rivals.isEmpty { rivals = Store.starterRivals }
    }

    // MARK: Actions

    func addRival(name: String, emoji: String, project: String) {
        rivals.append(Rival(name: name, emoji: emoji, project: project, optedIn: true))
    }

    func pass(_ rival: Rival) {
        update(rival) { $0.status = .passed }
    }

    func spite(_ rival: Rival, task: String, roast: String, intensity: Intensity, followUpIn hours: Double = 24) {
        let followUp = Date().addingTimeInterval(hours * 3600)
        spites.append(Spite(rivalID: rival.id, task: task, roast: roast,
                            intensity: intensity, followUpAt: followUp))
        update(rival) { $0.status = .spited }
        scheduleFollowUp(for: rival, at: followUp)
    }

    func nextRound(_ spite: Spite, roast: String) {
        guard let idx = spites.firstIndex(where: { $0.id == spite.id }) else { return }
        spites[idx].round += 1
        spites[idx].roast = roast
        spites[idx].followUpAt = Date().addingTimeInterval(24 * 3600)
        if let rival = rival(for: spite) { scheduleFollowUp(for: rival, at: spites[idx].followUpAt) }
    }

    func markDone(_ spite: Spite) {
        guard let idx = spites.firstIndex(where: { $0.id == spite.id }) else { return }
        spites[idx].done = true
    }

    func rival(for spite: Spite) -> Rival? {
        rivals.first { $0.id == spite.rivalID }
    }

    var deck: [Rival] { rivals.filter { $0.status == .pending && $0.optedIn } }

    func resetDeck() {
        for i in rivals.indices where rivals[i].status == .passed { rivals[i].status = .pending }
    }

    private func update(_ rival: Rival, _ change: (inout Rival) -> Void) {
        guard let idx = rivals.firstIndex(where: { $0.id == rival.id }) else { return }
        change(&rivals[idx])
    }

    // MARK: Notifications

    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private func scheduleFollowUp(for rival: Rival, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Spite check 🔥"
        content.body = "\(rival.name) hasn't answered yet. Time for round two."
        content.sound = .default
        let interval = max(60, date.timeIntervalSinceNow)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger))
    }

    // MARK: Persistence

    private func save() {
        let d = UserDefaults.standard
        if let r = try? JSONEncoder().encode(rivals) { d.set(r, forKey: rivalsKey) }
        if let s = try? JSONEncoder().encode(spites) { d.set(s, forKey: spitesKey) }
    }

    private func load() {
        let d = UserDefaults.standard
        if let data = d.data(forKey: rivalsKey), let r = try? JSONDecoder().decode([Rival].self, from: data) { rivals = r }
        if let data = d.data(forKey: spitesKey), let s = try? JSONDecoder().decode([Spite].self, from: data) { spites = s }
    }

    static let starterRivals = [
        Rival(name: "Maya", emoji: "🎨", project: "that painting", optedIn: true),
        Rival(name: "Dev", emoji: "🏃", project: "marathon training", optedIn: true),
        Rival(name: "Sam", emoji: "📚", project: "the thesis", optedIn: true)
    ]
}
