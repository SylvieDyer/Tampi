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
            
            CalendarView(
                ascVisits: Event.mocks(
                    start: .daysFromToday(-30*36),
                    end: .daysFromToday(30*36), tampi:tampi),
                initialMonth: Date(), tampi: tampi).frame(height: 600)

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
            }
        }
    }
    
    
    struct SheetView: View {
        @Environment(\.dismiss) var dismiss
        @ObservedObject var tampi: Tampi
        @State private var selectedDates: Set<DateComponents> = []
        
        func updateCycle(){
            for date in tampi.userInfo.editCycleDates{
                print(date.date?.formatted())
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
}

// delete later:
struct TrackerView_Preview: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}
