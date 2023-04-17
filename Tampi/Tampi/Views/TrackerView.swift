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
    @ObservedObject var tampi: Tampi
    
    var body: some View {
        List {
            
            Section{
                Text("Welcome to the Tracker Page!").bold().font(.title2)
                
      
                    Text("Here, you can view your cycle")
                        .foregroundColor(.gray).fontWeight(.semibold)
//                    Text("**your** ")
//                        .foregroundColor(.purple) +
//                    Text("cycle!")
//                        .foregroundColor(.gray).fontWeight(.semibold)
                
            }
            
            Section{
                MultiDatePicker(
                    "Start Date",
                    selection: $tampi.userInfo.cycleDates
                )
//                .onChange(of: tampi.userInfo.cycleDates, perform: { _ in
//                    $tampi.formatSelectedDates
//                })
                .datePickerStyle(.graphical)
                .tint(.purple)
                .disabled(true)

                HStack{
                    Spacer()
                    Button(action: {tampi.appController.editTracker.toggle()}) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("Edit")
                        }.foregroundColor(.indigo)
                    }.sheet(isPresented: $tampi.appController.editTracker) {
                        VStack{
                            SheetView(tampi: tampi)
                        }
                    }
                }
            }
            
            Section {
                Text("Key Dates this Month:").fontWeight(.bold)
                LazyVStack(alignment: .leading) {
                    Text(tampi.userInfo.formatSelectedDates)
                }
            }
        }
        
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
        @State private var selectedDates: Set<DateComponents> = []
        
        private func sendDates(){
            tampi.userInfo.cycleDates = selectedDates
        }
        var body: some View {
            HStack{
                Spacer()
                Button(action:{ dismiss(); sendDates() }) {
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
                selection: $selectedDates
            )
            .datePickerStyle(.graphical)
            .tint(.purple)

            Spacer()
        }
    }
}
