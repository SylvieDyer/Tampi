//
//  TrackerView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
import ElegantCalendar

struct TrackerView: View {
    
    @ObservedObject var tampi: Tampi
   
    
//    @ObservedObject private var calendarManager: MonthlyCalendarManager

//    let visitsByDay: [Date: [Event]]
//
//    @State private var calendarTheme: CalendarTheme = .royalBlue

//    init(ascVisits: [Event], initialMonth: Date?, tampi: Tampi) {
//        let configuration = CalendarConfiguration(
//            calendar: currentCalendar,
//            startDate: .daysFromToday(-365),
//            endDate: .daysFromToday(365*2))
//
//        calendarManager = MonthlyCalendarManager(
//            configuration: configuration,
//            initialMonth: initialMonth)
//
//        visitsByDay = Dictionary(
//            grouping: ascVisits,
//            by: { currentCalendar.startOfDay(for: $0.date) })
//        self.tampi = Tampi(name: "LAMPI b827ebdb1217")
//        calendarManager.datasource = self
//        calendarManager.delegate = self
//    }
    
  
    var body: some View {
        List{
            Section{
                Text("Welcome to the Tracker Page!").bold().font(.title2)
                VStack(alignment: .leading){
                    Text("Here, you can view your cycle")
                        .foregroundColor(.gray).fontWeight(.semibold)
                    
                    Text("Aided by ElegantCalendar, by Kevin Li").foregroundColor(.gray).font(.subheadline)
                }
            }
            
            Section{
                HStack{
                    Button(action: {tampi.appController.editTracker.toggle() }){
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.pencil").resizable().frame(width: 20, height: 23)
//                            Text("Edit").font(.title3).frame(height: 20)
                        }.foregroundColor(.indigo).frame(height:10)
                    }.sheet(isPresented: $tampi.appController.editTracker) {
                        VStack{
                            CalendarPopUp(tampi: tampi)
                        }
                    }
                }
                
                HStack{
                    Spacer()
                    
//                    MonthlyCalendarView(calendarManager: calendarManager)
//                        .theme(calendarTheme).frame(height: 600)
                   
                    CalendarView(
                        ascVisits: Event.mocks(
                            start: .daysFromToday(-30*36),
                            end: .daysFromToday(30*36), tampi: tampi),
                        initialMonth: Date(), withDates: $tampi.userInfo.cycleDates).frame(height: 600)
//
                    
                    Spacer()
                }.padding(10)
                
            }
        }
    }
    
    
}
struct CalendarPopUp: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var tampi: Tampi
    @State private var selectedDates: Set<DateComponents> = []
    
    func updateCycle(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        var dateString: String
        
        for date in tampi.userInfo.editCycleDates{
            dateString = formatter.string(from: date.date!)
            tampi.userInfo.cycleDates.insert(dateString)
               
            //print(formatter.string(from: date.date!))
        }
        
    }
    var body: some View {
        HStack{
            Spacer()
            Button(action:{ dismiss(); updateCycle()}) {
                HStack{
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                        .foregroundColor(.black)
                }
            }.font(.title)
            .padding()
        }
        Text("Edit Cycle").font(.title).fontWeight(.bold)
        MultiDatePicker(
            "Start Date",
            selection: $tampi.userInfo.editCycleDates
        )
        .datePickerStyle(.graphical)
        .tint(.purple)

        Spacer()
    }
}

//extension TrackerView: MonthlyCalendarDelegate {
//
//    func calendar(didSelectDay date: Date) {
//        print("Selected date: \(date)")
//    }
//
//    func calendar(willDisplayMonth date: Date) {
//        print("Month displayed: \(date)")
//    }
//
//    func calendar(didSelectMonth date: Date) {
//        print("Selected month: \(date)")
//    }
//
//    func calendar(willDisplayYear date: Date) {
//        print("Year displayed: \(date)")
//    }
//}
//
//
//extension TrackerView: MonthlyCalendarDataSource {
//
//    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
//       // if the cycleDates includes this date
//        if tampi.userInfo.cycleDates.contains(String(date.formatted(.dateTime).dropLast(10))) {
//            return 0.4
//        }
//        else {
//            return 0
//        }
//    }
//
//
//}

struct CalendarView: View {
    @ObservedObject private var calendarManager: MonthlyCalendarManager
  
    
    let visitsByDay: [Date: [Event]]
    @Binding var cycleDates: Set<String> {
        didSet {
            print("did set cycle dates")
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            for date in cycleDates{
                calendarManager
                calendarManager.datasource?.calendar(backgroundColorOpacityForDate: formatter.date(from: date)!)
                print(date)
            }
        }
    }

    @State private var calendarTheme: CalendarTheme = .royalBlue

    init(ascVisits: [Event], initialMonth: Date?, withDates cycleDates: Binding<Set<String>>) {
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
        
        self._cycleDates = cycleDates
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
        if cycleDates.contains(String(date.formatted(.dateTime).dropLast(10))) {
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

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

// delete later:
struct TrackerView_Preview: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}
