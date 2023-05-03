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
    @State private var isEditing = false
    @State private var selectedDates: Set<DateComponents> = []
    
    var user: User
    
    // updates the calendar display
    func updateCycle() {
        // formatter to put into a string
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        
        // remove the dates that have been unselected
        for date in tampi.userInfo.editCycleDates.subtracting(selectedDates) {
            tampi.userInfo.cycleDates.remove(formatter.string(from: date.date!))
        }
        
        // add the new dates that have been selected
        for date in selectedDates.subtracting(tampi.userInfo.editCycleDates){
            tampi.userInfo.cycleDates.insert(formatter.string(from: date.date!))
        }
        
        // ensure the changes are saved when the datepicker is opened again
        tampi.userInfo.editCycleDates = selectedDates
        
        // predicts the next cycle
        tampi.userInfo.predict()
    }
  
    var body: some View {
        List{
            // header section
            Section{
                Text("Welcome to the Tracker Page!").bold().font(.title2)
                VStack(alignment: .leading){
                    Text("Here, you can view your cycle")
                        .foregroundColor(.black.opacity(0.7)).fontWeight(.semibold)
                    
                    Text("Aided by ElegantCalendar, by Kevin Li").foregroundColor(.gray).font(.subheadline)
                }
            }
            
            // calendar and edit
            Section{
//                Button (action: {
//                    
//                    print(tampi.userInfo.nextCycle)
//                }) {
//                    Text("TEST")
//                }
                HStack{
                    Button(action: {
                        // open the sheet
                        isEditing = true
                        // set the temp var selected dates to be the previously selected dates
                        selectedDates = tampi.userInfo.editCycleDates
                    }){
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.pencil").resizable().frame(width: 20, height: 23)
//                      Text("Edit").font(.title3).frame(height: 20)
                        }.foregroundColor(.indigo).frame(height:10)
                        
                    // pop up for the multidate selector
                    }.sheet(isPresented: $isEditing, onDismiss: updateCycle) {
                        
                        VStack{
                            // close button
                            HStack{
                                Spacer()
                                Button(action:{
                                    isEditing = false;
                                }) {
                                    HStack{
                                        Image(systemName: "chevron.down")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                                            .foregroundColor(.black)
                                    }
                                }.font(.title)
                                    .padding()
                            }
                            // calendar to edit the cycle
                            Text("Edit Cycle").font(.title).fontWeight(.bold)
                            MultiDatePicker("Start Date", selection: $selectedDates)
                                .datePickerStyle(.graphical)
                                .tint(.purple)
                        }
                    }
                }
                
                HStack{
                    Spacer()
                    CalendarView(
                        ascVisits: Event.addEvents(
                            start: .daysFromToday(-30*36),
                            end: .daysFromToday(30*36), tampi: tampi),
                        initialMonth: Date(),
                        withTampi: tampi,
                        withDates: $tampi.userInfo.cycleDates)
                    .frame(height: 600)
                    Spacer()
                }.padding(10)
                
            }
        }
    }
}

//// delete later:
//struct TrackerView_Preview: PreviewProvider {
//    static var previews: some View {
//        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
//            .previewDevice("iPhone 12 Pro")
//            .previewLayout(.device)
//    }
//}
