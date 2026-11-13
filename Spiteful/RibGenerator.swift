import Foundation

/// Generates over-the-top, backhanded-compliment style ribbing.
/// Rule #1: roast the WORK and the DRAMA, never the person.
enum RibGenerator {

    // MARK: Guardrails

    /// Topics that are never fun. Anything touching these gets blocked.
    private static let offLimits = [
        "fat", "ugly", "stupid", "dumb", "idiot", "loser", "weight", "body",
        "race", "gay", "trans", "disab", "retard", "die", "kill", "hate you"
    ]

    static func isSafe(_ text: String) -> Bool {
        let lower = text.lowercased()
        return !offLimits.contains { lower.contains($0) }
    }

    // MARK: Roasts

    static func roast(for rival: Rival, task: String, intensity: Intensity) -> String {
        let name = rival.name
        let what = task.isEmpty ? rival.project : task
        let options: [String]
        switch intensity {
        case .playful:
            options = [
                "\(name), I know you put real effort into \(what), but I think you have more in you. Show me.",
                "Cute start on \(what), \(name). Do it again like you actually mean it.",
                "\(what) was fine, \(name). Fine. I'm sure the next one will be the one you try on."
            ]
        case .theatrical:
            options = [
                "\(name), I know you poured hours into \(what), but don't you think it could be bolder next time? Do it again and show me you actually love this.",
                "I've seen the \(what). I have thoughts. Mostly that you're capable of way more and we both know it, \(name).",
                "Honestly \(name), \(what) was a lovely rough draft. When's the real one coming?"
            ]
        case .operatic:
            options = [
                "\(name). NAME. I have witnessed \(what) and I am not mad, I am simply TRANSCENDENTLY unimpressed, and I believe in your potential. Redeem yourself by Friday.",
                "History will remember \(what) as the warm up, \(name). The sequel is overdue and the whole kingdom is waiting.",
                "\(name), I'm putting a timer on \(what). Beat me and I'll admit it was good. I won't mean it, but I'll say it."
            ]
        }
        return options.randomElement() ?? options[0]
    }

    // MARK: Follow ups

    /// Keeps the bit going so the spite turns into actual progress.
    static func followUps(for rival: Rival, round: Int) -> [String] {
        [
            "Round \(round + 1): \(rival.name), I heard you did it. I don't believe you. Photo evidence or it didn't happen.",
            "\(rival.name), it's been a day. The silence is deafening. Is the masterpiece ready or are we doing excuses?",
            "Okay fine \(rival.name), that was actually good. Don't let it go to your head. Now do the next one."
        ]
    }

    /// Spite is a motivator, so each round suggests one tiny next step too.
    static func nudges(for task: String) -> [String] {
        [
            "Set a 15 minute timer and just start \(task.isEmpty ? "it" : task).",
            "Send them a progress pic before you feel ready.",
            "Do the smallest possible piece right now, then gloat."
        ]
    }
}
