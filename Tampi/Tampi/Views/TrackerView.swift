//
//  TrackerView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct TrackerView: View {
    
    //    @State private var models: [CalendarViewModel] = []
    //    @State private var dragging: ScheduleItem?
    //    private let sevenColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    
    @ObservedObject var tampi: Tampi
    @State private var selectedDates: Set<DateComponents> = []
    
   
    
    @State private var formattedDates: String = ""
    
    private func formatSelectedDates() {
        formatter.dateFormat = "MMM-dd-YY"
        let dates = selectedDates
            .compactMap { date in
                Calendar.current.date(from: date)
            }
            .map { date in
                formatter.string(from: date)
            }
        formattedDates = dates.joined(separator: "\n")
    }
    let formatter = DateFormatter()
    
    var body: some View {
        List {
            Section{
                Text("Welcome to the Tracker Page!").bold().font(.title2)
                
                VStack{
                    Text("Here, you can view ")
                        .foregroundColor(.gray).fontWeight(.semibold) +
                    Text("**\(tampi.userInfo.cycleOwnerName)'s** ")
                        .foregroundColor(.purple) +
                    Text("cycle!")
                        .foregroundColor(.gray).fontWeight(.semibold)
                }
                
            }
            Section{
                MultiDatePicker(
                    "Start Date",
                    selection: $selectedDates
                    
                )
                .datePickerStyle(.graphical)
                .tint(.purple)
                .onChange(of: selectedDates, perform: { _ in
                    formatSelectedDates()
                })
                .disabled(!tampi.appController.editTracker)
                
                
                HStack{
                    Spacer()
                    Toggle("Edit", isOn: $tampi.appController.editTracker)
                        .toggleStyle(.button)
                        .tint(.indigo)
                }
            }
            
            Section {
                
                LazyVStack(alignment: .leading) {
                    Text(formattedDates)
                }
            }
        }
        
        //        VStack {
        //            LazyVGrid(columns: sevenColumnGrid) {
        //
        //                ForEach(models) { model in
        //                    VStack {
        //                        Text(model.date)
        //                            .frame(maxWidth: .infinity, alignment: .trailing)
        //                        ForEach(model.items) { item in
        //                            if let name = item.name {
        //                                VStack {
        //                                    Spacer()
        //                                    Text(name)
        //                                        .frame(maxWidth: .infinity, alignment: .center)
        //                                    Spacer()
        //                                }
        //                                .background(Color.green.opacity(0.3))
        //                                .cornerRadius(4)
        //                                .overlay(dragging?.id == item.id ? Color.green.opacity(0.3) : Color.clear)
        //                                .onDrag {
        //                                    self.dragging = item
        //                                    return NSItemProvider(object: item.id as NSString)
        //                                }
        //                                .onDrop(of: [UTType.text],
        //                                        delegate: DropDelegateImpl(item: item, listData: $models, current: $dragging))
        //                            } else {
        //                                VStack {
        //                                    Spacer()
        //                                    Text("")
        //                                        .frame(maxWidth: .infinity, alignment: .center)
        //                                    Spacer()
        //                                }
        //                                .background(Color.white)
        //                                .onDrop(of: [UTType.text],
        //                                        delegate: DropDelegateImpl(item: item, listData: $models, current: $dragging))
        //                            }
        //                        }
        //                        if model.items.isEmpty {
        //                            Spacer()
        //                        }
        //                    }
        //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, alignment: .center)
        //                }
        //            }
        //            .animation(.default, value: models)
        //        }
        //        .background(Color.blue)
        //    }
        
    }
    
    // delete later:
    struct ContentView_Previews2: PreviewProvider {
        static var previews: some View {
            TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
                .previewDevice("iPhone 12 Pro")
                .previewLayout(.device)
        }}
}


    /*
struct ScheduleItem: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let name: String? // I will explain later why we need an optional name. This is part of the fake concept I will explain later.
}

struct CalendarViewModel: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let date: String
    var items: [ScheduleItem] // I make it var because we will mutate this later
}

struct DropDelegateImpl: DropDelegate {
     let item: ScheduleItem // 0.
     @Binding var listData: [CalendarViewModel] // 1.
     @Binding var current: ScheduleItem? // 2.
 
     func dropEntered(info: DropInfo) {
         guard let current = current, item != current else {
             return
         } // 3.
        let from = listData.first { cvm in
            return cvm.items.contains(current)
        } // 4.
         let to = listData.first { cvm in
             return cvm.items.contains(item)
         } // 5.

        guard var from = from, var to = to, from != to else {
            return
        } // 6.

        if let toItems = to.items.first(where: { $0.id == item.id }),
           toItems.id != current.id { // 7.
            let fromIndex = listData.firstIndex(of: from) ?? 0 // 8.
            let toIndex = listData.firstIndex(of: to) ?? 0 // 9.
            to.items.append(current) // 10.
            to.items.removeAll(where: { $0.name == nil}) // 11.
            from.items.removeAll(where: { $0.id == current.id }) // 12.
            if from.items.isEmpty {
                from.items.append(ScheduleItem(name: nil)) // 13.
            }
            listData[toIndex].items = to.items // 14.
            listData[fromIndex].items = from.items // 15.
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move) // 16.
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil // 17.
        return true
    }
}
*/
