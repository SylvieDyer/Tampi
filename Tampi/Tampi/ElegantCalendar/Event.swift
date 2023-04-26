// Kevin Li - 1:32 PM - 6/13/20

import SwiftUI

let currentCalendar = Calendar.current
let screen = UIScreen.main.bounds

struct Event {

    let eventName: String
    let tagColor: Color
    let arrivalDate: Date
    let departureDate: Date
    let dateString: String

    var notes: String {
        "crying" + " ➝ " + "bleeding"
    }
}

// TODO: NEED THIS ? each date should be identifiable by datStrign (ONLY PREIOD FOR NOW)
extension Event: Identifiable {

    var id: String {
        dateString
    }
}

extension Event {

    // create the individual event with an input date
    static func mock(withDate date: Date, withDateString dateString: String) -> Event {
        Event(eventName: "Period",
              tagColor: .randomColor,
              arrivalDate: date,
              departureDate: date.addingTimeInterval(60*60),
              dateString: dateString)
    }

//    // populate the calendar
    static func mocks(start: Date, end: Date, tampi: Tampi) -> [Event] {
        currentCalendar.markPeriods(
            start: start,
            end: end, tampi: tampi)
    }
}

fileprivate let visitCountRange = 1...20

private extension Calendar {
    
    func markPeriods(start: Date, end:Date, tampi:Tampi)-> [Event]{
        var cycleEvents = [Event]()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MM/DD/YYYY"
        for dateString in tampi.userInfo.cycleDates {
            cycleEvents.append(.mock(withDate: formatter.date(from: dateString)!,withDateString: dateString))
        }
        return cycleEvents
    }
    
//    func generateVisits(start: Date, end: Date) -> [Event] {
//        var cycleEvents = [Event]()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYYMMDD"
//
//        enumerateDates(
//            startingAfter: start,
//            matching: .everyDay,
//            matchingPolicy: .nextTime) { date, _, stop in
//                if let date = date {
//
////                    print(date.formatted(.dateTime).dropLast(10))
////                    print("Date Time \(date.formatted(.dateTime))")
//                    // 2025-04-24 04:00:00 +0000 (for ex.)
//                    if date < end {
//                        for _ in 0..<Int.random(in: visitCountRange) {
//                            cycleEvents.append(.mock(withDate: date))
//                        }
//                    } else {
//                        stop = true
//                    }
//                }
//            }
//        return cycleEvents
//    }
//    
//    func compareDates(dayOne: Date, dayTwo: Date) -> Bool {
//        
//    }
}

fileprivate let colorAssortment: [Color] = [.turquoise, .forestGreen, .darkPink, .darkRed, .lightBlue, .salmon, .military]

private extension Color {

    static var randomColor: Color {
        let randomNumber = arc4random_uniform(UInt32(colorAssortment.count))
        return colorAssortment[Int(randomNumber)]
    }

}

private extension Color {

    static let turquoise = Color(red: 24, green: 147, blue: 120)
    static let forestGreen = Color(red: 22, green: 128, blue: 83)
    static let darkPink = Color(red: 179, green: 102, blue: 159)
    static let darkRed = Color(red: 185, green: 22, blue: 77)
    static let lightBlue = Color(red: 72, green: 147, blue: 175)
    static let salmon = Color(red: 219, green: 135, blue: 41)
    static let military = Color(red: 117, green: 142, blue: 41)

}

fileprivate extension Color {

    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red)/255, green: Double(green)/255, blue: Double(blue)/255)
    }

}

fileprivate extension DateComponents {

    static var everyDay: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0)
    }

}
