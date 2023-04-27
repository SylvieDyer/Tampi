// Kevin Li - 11:47 AM - 6/13/20

import ElegantCalendar
import SwiftUI

struct CalendarView: View {

    @ObservedObject private var tampi: Tampi;
    @ObservedObject private var calendarManager: MonthlyCalendarManager

    let visitsByDay: [Date: [Event]]

    @State private var calendarTheme: CalendarTheme = .royalBlue

    init(ascVisits: [Event], initialMonth: Date?, tampi: Tampi) {
        let configuration = CalendarConfiguration(
            calendar: currentCalendar,
            startDate: .daysFromToday(-365),
            endDate: .daysFromToday(365*2))

        calendarManager = MonthlyCalendarManager(
            configuration: configuration,
            initialMonth: initialMonth)

        visitsByDay = Dictionary(
            grouping: ascVisits,
            by: { currentCalendar.startOfDay(for: $0.date) })
        self.tampi = Tampi(name: "LAMPI b827ebdb1217")
        calendarManager.datasource = self
        calendarManager.delegate = self
    }

    var body: some View {
       
            MonthlyCalendarView(calendarManager: calendarManager)
                .theme(calendarTheme)
       
    }
}

extension CalendarView: MonthlyCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
       // if the cycleDates includes this date
        if tampi.userInfo.cycleDates.contains(String(date.formatted(.dateTime).dropLast(10))) {
            return 0.4
        }
        else {
            return 0
        }
    }

    func calendar(canSelectDate date: Date) -> Bool {
        let day = currentCalendar.dateComponents([.day], from: date).day!
        return day != 4
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return VisitsListView(cycleEvents: visitsByDay[startOfDay] ?? [], height: size.height).erased
    }
    
}

extension CalendarView: MonthlyCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var tampi = Tampi(name: "LAMPI b827ebdb1217")
    static var previews: some View {
        CalendarView(ascVisits: Event.mocks(start: .daysFromToday(-365), end: .daysFromToday(365*2), tampi: tampi), initialMonth: nil, tampi: tampi)
    }
}

