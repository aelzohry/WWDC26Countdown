import Foundation

enum EventDates {
    static let wwdcURL = URL(string: "https://developer.apple.com/wwdc26/")!

    static let wwdc26Keynote: Date = {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(identifier: "America/Los_Angeles")
        components.year = 2026
        components.month = 6
        components.day = 8
        components.hour = 10
        components.minute = 0
        components.second = 0
        return components.date ?? Date(timeIntervalSince1970: 1_780_933_200)
    }()

    static let wwdc26End: Date = {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(identifier: "America/Los_Angeles")
        components.year = 2026
        components.month = 6
        components.day = 12
        components.hour = 23
        components.minute = 59
        components.second = 59
        return components.date ?? Date(timeIntervalSince1970: 1_781_352_000)
    }()
}

struct CountdownSnapshot {
    let now: Date
    let target: Date

    private var interval: TimeInterval {
        max(0, target.timeIntervalSince(now))
    }

    var isComplete: Bool {
        now >= target
    }

    var isConferenceWeek: Bool {
        now >= target && now <= EventDates.wwdc26End
    }

    var days: Int {
        Int(interval) / 86_400
    }

    var hours: Int {
        (Int(interval) % 86_400) / 3_600
    }

    var minutes: Int {
        (Int(interval) % 3_600) / 60
    }

    var seconds: Int {
        Int(interval) % 60
    }

    var progress: Double {
        let announcement = target.addingTimeInterval(-77 * 24 * 60 * 60)
        let total = target.timeIntervalSince(announcement)
        guard total > 0 else { return 1 }
        return min(1, max(0, now.timeIntervalSince(announcement) / total))
    }

    var headline: String {
        if isConferenceWeek {
            "WWDC26 is glowing"
        } else if isComplete {
            "Keynote time"
        } else {
            "WWDC26 begins in"
        }
    }

    var statusLine: String {
        if isConferenceWeek {
            "The week is live. Time to watch, learn, and bookmark every session you promise Future You will definitely revisit."
        } else if isComplete {
            "The keynote has started. Go absorb the future."
        } else {
            keynoteLine
        }
    }

    var keynoteLine: String {
        "Keynote: \(Self.localKeynoteFormatter.string(from: target)) \(Self.localTimeZoneFormatter.string(from: target))"
    }

    var menuBarTitle: String {
        if isConferenceWeek {
            return "WWDC live"
        }

        if isComplete {
            return "WWDC now"
        }

        if days > 0 {
            return "WWDC \(days)d \(hours)h"
        }

        if hours > 0 {
            return "WWDC \(hours)h \(minutes)m"
        }

        return "WWDC \(minutes)m \(seconds)s"
    }

    var hypeStage: HypeStage {
        if isConferenceWeek || isComplete {
            return .keynote
        }

        switch progress {
        case ..<0.45:
            return .charging
        case ..<0.72:
            return .polishing
        case ..<0.9:
            return .snacks
        default:
            return .ready
        }
    }

    private static var localKeynoteFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }

    private static var localTimeZoneFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = "z"
        return formatter
    }
}

enum HypeStage: String, CaseIterable {
    case charging = "Charging curiosity"
    case polishing = "Polishing demos"
    case snacks = "Queueing snacks"
    case ready = "Almost keynote"
    case keynote = "All systems glow"

    var symbol: String {
        switch self {
        case .charging:
            "bolt.fill"
        case .polishing:
            "wand.and.stars"
        case .snacks:
            "cup.and.saucer.fill"
        case .ready:
            "paperplane.fill"
        case .keynote:
            "sparkles"
        }
    }
}
