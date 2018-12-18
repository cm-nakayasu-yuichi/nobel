//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

extension TimeZone {
    
    static let jst = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    
    static let jp = Locale(identifier: "ja_JP")
}

extension Date {
    
    static var timezone: TimeZone = .current
    static var locale: Locale = .current
    
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Date.timezone
        calendar.locale = Date.locale
        return calendar
    }
    
    var calendar: Calendar {
        return Date.calendar
    }
}

extension Date {
    
    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar
        var comp = DateComponents()
        comp.year   = year   ?? calendar.component(.year,   from: self)
        comp.month  = month  ?? calendar.component(.month,  from: self)
        comp.day    = day    ?? calendar.component(.day,    from: self)
        comp.hour   = hour   ?? calendar.component(.hour,   from: self)
        comp.minute = minute ?? calendar.component(.minute, from: self)
        comp.second = second ?? calendar.component(.second, from: self)
        return calendar.date(from: comp)!
    }
    
    func added(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year   = (year   ?? 0) + calendar.component(.year,   from: self)
        comp.month  = (month  ?? 0) + calendar.component(.month,  from: self)
        comp.day    = (day    ?? 0) + calendar.component(.day,    from: self)
        comp.hour   = (hour   ?? 0) + calendar.component(.hour,   from: self)
        comp.minute = (minute ?? 0) + calendar.component(.minute, from: self)
        comp.second = (second ?? 0) + calendar.component(.second, from: self)
        return calendar.date(from: comp)!
    }
}

extension Date {
    
    init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        self.init()
        if let value = year   { self.year   = value }
        if let value = month  { self.month  = value }
        if let value = day    { self.day    = value }
        if let value = hour   { self.hour   = value }
        if let value = minute { self.minute = value }
        if let value = second { self.second = value }
    }
    
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            setComponentValue(newValue, for: .year)
        }
    }
    
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            setComponentValue(newValue, for: .month)
        }
    }
    
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            setComponentValue(newValue, for: .day)
        }
    }
    
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            setComponentValue(newValue, for: .hour)
        }
    }
    
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            setComponentValue(newValue, for: .minute)
        }
    }
    
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            setComponentValue(newValue, for: .second)
        }
    }
    
    private mutating func setComponentValue(_ value: Int, for component: Calendar.Component) {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.setValue(value, for: component)
        if let date = calendar.date(from: components) {
            self = date
        }
    }
}

extension Date {
    
    enum SymbolType {
        case `default`
        case standalone
        case veryShort
        case short
        case shortStandalone
        case veryShortStandalone
        case custom(symbols: [String])
    }
}

extension Date {
    
    enum Week: Int {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        
        static func weeks(startWeek: Week = .sunday) -> [Week] {
            return (0..<7).map { i -> Week in // 7 = number of weeks
                let n = startWeek.rawValue + i
                let m = (n < 7) ? n : n - 7
                return Week(rawValue: m)!
            }
        }
        
        static func symbols(_ type: SymbolType = .short, locale: Locale? = nil) -> [String] {
            let formatter = DateFormatter()
            formatter.locale = locale ?? calendar.locale
            
            switch type {
            case .`default`:           return formatter.weekdaySymbols
            case .standalone:          return formatter.standaloneWeekdaySymbols
            case .veryShort:           return formatter.veryShortWeekdaySymbols
            case .short:               return formatter.shortWeekdaySymbols
            case .shortStandalone:     return formatter.shortStandaloneWeekdaySymbols
            case .veryShortStandalone: return formatter.veryShortStandaloneWeekdaySymbols
            case let .custom(symbols): return symbols
            }
        }
        
        func symbol(_ type: SymbolType = .short, locale: Locale? = nil) -> String {
            return Week.symbols(type, locale: locale)[rawValue]
        }
        
        var symbol: String {
            return symbol(.shortStandalone, locale: .jp)
        }
    }
    
    var weekIndex: Int {
        return calendar.component(.weekday, from: self) - 1
    }
    
    var weak: Week {
        return Week(rawValue: weekIndex)!
    }
    
    var isSunday: Bool {
        return weekIndex == Week.sunday.rawValue
    }
    
    var isSaturday: Bool {
        return weekIndex == Week.saturday.rawValue
    }
    
    var isWeekend: Bool {
        return isSunday || isSaturday
    }
    
    var isUsualDay: Bool {
        return !isWeekend
    }
}

extension Date {
    
    var monthIndex: Int {
        return calendar.component(.month, from: self) - 1
    }
    
    // SymbolType は 前項の「曜日の取得」で定義したもの
    func monthSymbols(_ type: SymbolType = .short, locale: Locale? = nil) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = locale ?? calendar.locale
        
        switch type {
        case .`default`:           return formatter.monthSymbols
        case .standalone:          return formatter.standaloneMonthSymbols
        case .veryShort:           return formatter.veryShortMonthSymbols
        case .short:               return formatter.shortMonthSymbols
        case .shortStandalone:     return formatter.shortStandaloneMonthSymbols
        case .veryShortStandalone: return formatter.veryShortStandaloneMonthSymbols
        case let .custom(symbols): return symbols
        }
    }
    
    func monthSymbol(_ type: SymbolType = .short, locale: Locale? = nil) -> String {
        return monthSymbols(type, locale: locale)[monthIndex]
    }
}

extension Date {
    
    static var now: Date {
        return Date()
    }
    
    static var today: Date {
        return now.zeroclock
    }
    
    static func day(after days: Int) -> Date {
        return today.added(day: days)
    }
    
    static var yesterday: Date {
        return day(after: -1)
    }
    
    static var tomorrow: Date {
        return day(after: 1)
    }
    
    static var dayAfterTomorrow: Date {
        return day(after: 2)
    }
}

extension Date {
    
    var oclock: Date {
        return fixed(minute: 0, second: 0)
    }
    
    var zeroclock: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }
    
    var firstOfDay: Date {
        return zeroclock
    }
    
    var lastOfDay: Date {
        return fixed(hour: 23, minute: 59, second: 59)
    }
    
    var firstDayOfMonth: Date {
        return fixed(day: 1, hour: 0, minute: 0, second: 0)
    }
    
    var lastDayOfMonth: Date {
        return added(month: 1).fixed(day: 0, hour: 0, minute: 0, second: 0)
    }
}

extension Date {
    
    func isSameDay(_ otherDay: Date) -> Bool {
        return zeroclock == otherDay.zeroclock
    }
    
    func isSameDay(after days: Int) -> Bool {
        return isSameDay(Date.day(after: days))
    }
    
    func isSameMonth(_ otherDay: Date) -> Bool {
        return year == otherDay.year && month == otherDay.month
    }
    
    var isToday: Bool {
        return isSameDay(Date.today)
    }
    
    var isYesterday: Bool {
        return isSameDay(Date.yesterday)
    }
    
    var isTomorrow: Bool {
        return isSameDay(Date.tomorrow)
    }
    
    var isDayAfterTomorrow: Bool {
        return isSameDay(Date.dayAfterTomorrow)
    }
}

extension Date {
    
    static func dates(year: Int, month: Int) -> [Date] {
        let date = Date(year: year, month: month)
        return (date.firstDayOfMonth...date.lastDayOfMonth).map { $0 }
    }
    
    static func datesForCalendar(year: Int, month: Int, startWeek: Date.Week = .sunday) -> [Date] {
        var ret = [Date]()
        let weeks = Week.weeks(startWeek: startWeek)
        let date = Date(year: year, month: month)
        
        if let weekIndex = weeks.index(of: date.firstDayOfMonth.weak) {
            for i in 0..<weekIndex {
                let n = -(weekIndex - i)
                ret.append(date.firstDayOfMonth.added(day: n))
            }
        }
        
        ret.append(contentsOf: dates(year: year, month: month))
        
        if let weekIndex = weeks.index(of: date.lastDayOfMonth.weak), weekIndex + 1 < 7 {
            for (i, _) in (weekIndex + 1..<7).enumerated() {
                ret.append(date.lastDayOfMonth.added(day: 1 + i))
            }
        }
        
        return ret
    }
    
    static func datesMatrixForCalendar(year: Int, month: Int, startWeek: Date.Week = .sunday) -> [Date] {
        var ret = [Date]()
        var i = 0, add = 1
        let dates = datesForCalendar(year: year, month: month, startWeek: startWeek)
        
        (0..<6).forEach { _ in // rows
            (0..<7).forEach { _ in // columns
                if i <= dates.lastIndex {
                    ret.append(dates[i])
                    i += 1
                } else {
                    ret.append(dates.last!.added(day: add))
                    add += 1
                }
            }
        }
        
        return ret
    }
    
    static func datesMatrixArraysForCalendar(year: Int, month: Int, startWeek: Date.Week = .sunday) -> [[Date]] {
        var ret = [[Date]]()
        var i = 0, add = 1
        let dates = datesForCalendar(year: year, month: month, startWeek: startWeek)
        
        (0..<6).forEach { _ in // rows
            var columns = [Date]()
            (0..<7).forEach { _ in // columns
                if i <= dates.lastIndex {
                    columns.append(dates[i])
                    i += 1
                } else {
                    columns.append(dates.last!.added(day: add))
                    add += 1
                }
            }
            ret.append(columns)
        }
        
        return ret
    }
}

extension Date {
    
    enum Format {
        case slashedYMD
        case slashedMD
        case slashedYMDHM
        case slashedYMDHMS
        case slashedVerbose
        case hyphenedYMD
        case hyphenedMD
        case hyphenedYMDHM
        case hyphenedYMDHMS
        case hyphenedVerbose 
        case colonedHM 
        case colonedHMS
        case colonedVerbose
        case japaneseYMD
        case japaneseMD
        case japaneseYMDHM 
        case japaneseYMDHMS 
        case japaneseVerbose
        case japaneseHM
        case japaneseHMS
        case japaneseTimeVerbose
        case custom(format: String)
        
        static var `default`: Format { return .slashedYMDHMS }
        
        var formatString: String {
            switch self {
            case .slashedYMD:          return "yyyy/MM/dd"
            case .slashedMD:           return "MM/dd"
            case .slashedYMDHM:        return "yyyy/MM/dd HH:mm"
            case .slashedYMDHMS:       return "yyyy/MM/dd HH:mm:ss"
            case .slashedVerbose:      return "yyyy/MM/dd HH:mm:ss.SSSS"
            case .hyphenedYMD:         return "yyyy-MM-dd"
            case .hyphenedMD:          return "MM-dd"
            case .hyphenedYMDHM:       return "yyyy-MM-dd HH:mm"
            case .hyphenedYMDHMS:      return "yyyy-MM-dd HH:mm:ss"
            case .hyphenedVerbose:     return "yyyy-MM-dd HH:mm:ss.SSSS"
            case .colonedHM:           return "HH:mm"
            case .colonedHMS:          return "HH:mm:ss"
            case .colonedVerbose:      return "HH:mm:ss.SSSS"
            case .japaneseYMD:         return "yyyy年MM月dd日"
            case .japaneseMD:          return "MM月dd日"
            case .japaneseYMDHM:       return "yyyy年MM月dd日 HH時mm分"
            case .japaneseYMDHMS:      return "yyyy年MM月dd日 HH時mm分ss秒"
            case .japaneseVerbose:     return "yyyy年MM月dd日 HH時mm分ss秒 SSSS"
            case .japaneseHM:          return "HH時mm分"
            case .japaneseHMS:         return "HH時mm分ss秒"
            case .japaneseTimeVerbose: return "HH時mm分ss秒 SSSS"
            case .custom(let format):  return format
            }
        }
    }
    
    func string(_ format: Format = .default) -> String {
        return Date.dateFormatter(format).string(from: self)
    }
    
    static func date(from string: String, format: Format = .default) -> Date? {
        return dateFormatter(format).date(from: string)
    }
    
    static func dateFormatter(_ format: Format = .default) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.formatString
        formatter.calendar = calendar
        formatter.timeZone = Date.timezone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}

extension Date {
    
    public func clone() -> Date {
        return Date(timeIntervalSince1970: timeIntervalSince1970)
    }
}

// Strideable準拠で date1...date2, date1..<date2 などが表現できる
extension Date: Strideable {
    
    public typealias Stride = Int
    
    public func distance(to other: Date) -> Int {
        return other.day - day
    }
    
    public func advanced(by n: Int) -> Date {
        return added(day: n)
    }
}
