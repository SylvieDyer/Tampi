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
import CoreData

struct TrackerView: View {
    
    @ObservedObject var tampi: Tampi
    @State private var isEditing = false
    @State private var selectedDates: Set<DateComponents> = []
    
    var user: User
    var viewContext: NSManagedObjectContext
    // the cycle dates entity
    @FetchRequest(sortDescriptors: [])
    private var cycleDates: FetchedResults<CycleDates>
    
    // updates the calendar display
    func updateCycle() {
        // formatter to put into a string
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        
        var dateString = ""
        
        // remove the dates that have been unselected
        for date in tampi.userInfo.editCycleDates.subtracting(selectedDates) {
            tampi.userInfo.cycleDates.remove(formatter.string(from: date.date!))
        }
        
        // add the new dates that have been selected
        for date in selectedDates.subtracting(tampi.userInfo.editCycleDates){
            dateString = formatter.string(from: date.date!)
            tampi.userInfo.cycleDates.insert(dateString)
            // add new dates to DB
            let newDate = CycleDates(context: viewContext)
            newDate.cycleDate = dateString
        }
        
        // ensure the changes are saved when the datepicker is opened again
        tampi.userInfo.editCycleDates = selectedDates
        
        // predicts the next cycle
        tampi.userInfo.predict()
        user.daysToNext = Int32(tampi.userInfo.daysUntilNewCycle)       // update that prediction in the db
        
        // save to DB new DB dates (that have been removed)
        for date in cycleDates {
            // if the date isn't in cycle dates
            if (!tampi.userInfo.cycleDates.contains(date.cycleDate!)){
                viewContext.delete(date)
            }
        }
        // save DB
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
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
