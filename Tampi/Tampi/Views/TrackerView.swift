//
//  TrackerView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI
import UIKit

struct TrackerView: View {
    @ObservedObject var tampi: Tampi
   
    let calendarView = UICalendarView()
    let gregorianCalendar = Calendar(identifier: .gregorian)
   
    
    var body: some View {
        List {
            Text("Welcome to the Tracker Page!").bold()
            
            VStack{
                Text("Here, you can view ") +
                Text("**\(tampi.userInfo.cycleOwnerName)'s** ")
                    .foregroundColor(.purple) +
                Text("cycle!")
            }
          
       
               
        }
    
     
    
        VStack{
          
        }.padding(10)
    
    }
}

// delete later:
struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}
