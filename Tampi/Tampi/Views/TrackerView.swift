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
    // Start & End date should be configured based on your needs.

    
      @ObservedObject var calendarManager = MonthlyCalendarManager(
        configuration: CalendarConfiguration(startDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (-30 * 36))),
                                             endDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36)))))

    
    @State private var calendarTheme: CalendarTheme = .fluorescentPink

    var body: some View {
        List{
            
            Section{
                Text("Welcome to the Tracker Page!").bold().font(.title2)
                
                
                Text("Here, you can view your cycle")
                    .foregroundColor(.gray).fontWeight(.semibold)
            }
            
            //            Section{
          
                
                
                MonthlyCalendarView(calendarManager: calendarManager).theme(calendarTheme).frame(height: 600)
                VStack{
                 Spacer()
                    HStack{
                        
                        Button(action: {tampi.appController.editTracker.toggle() }){
                            HStack {
                                Image(systemName: "square.and.pencil")
                                Text("Edit").font(.title3)
                            }.foregroundColor(.indigo).frame(height:20)
                        }.sheet(isPresented: $tampi.appController.editTracker) {
                            VStack{
                                SheetView(tampi: tampi)
                            }
                        }
                    }.padding(10)
                  
                
                    
                
                //TODO: the date select- edit on multidate picker, then it gets sent here?
                //                public protocol ElegantCalendarDataSource: MonthlyCalendarDataSource, YearlyCalendarDataSource { }
                //
                //                public protocol MonthlyCalendarDataSource {
                //
                //                    func calendar(backgroundColorOpacityForDate date: Date) -> Double
                //                    func calendar(canSelectDate date: Date) -> Bool
                //                    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView
                //
                //                }
                
                
                
                //                MonthlyCalendarView(calendarManager: calendarManager)
                //                MultiDatePicker(
                //                    "Start Date",
                //                    selection: $tampi.userInfo.cycleDates
                //                )
                ////                .onChange(of: tampi.userInfo.cycleDates, perform: { _ in
                ////                    $tampi.formatSelectedDates
                ////                })
                //                .datePickerStyle(.graphical)
                //                .tint(.purple)
                //                .disabled(true)
            }
            
            
            
        }
            
            
//        }
        
    }
    
    // delete later:
    struct ContentView_Previews2: PreviewProvider {
        static var previews: some View {
            TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
                .previewDevice("iPhone 12 Pro")
                .previewLayout(.device)
        }}
    
    struct SheetView: View {
        @Environment(\.dismiss) var dismiss
        @ObservedObject var tampi: Tampi
      //  @State private var selectedDates: Set<DateComponents> = []
        
        var body: some View {
            HStack{
                Spacer()
                Button(action:{ dismiss()}) {
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
                selection: $tampi.userInfo.cycleDates
            )
            .datePickerStyle(.graphical)
            .tint(.purple)

            Spacer()
        }
    }
}


extension TrackerView: MonthlyCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
//        let startOfDay = currentCalendar.startOfDay(for: date)
//        print(Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0)
//        return Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0
        
        return Double(date.ISO8601Format().count) / 5.0
    }

    func calendar(canSelectDate date: Date) -> Bool {
        return date.timeIntervalSinceReferenceDate != 5
    }

}


extension TrackerView: MonthlyCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Will show month: \(date)")
    }

}
