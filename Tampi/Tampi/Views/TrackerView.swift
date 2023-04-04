//
//  TrackerView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI

struct TrackerView: View {
    @ObservedObject var tampi: Tampi
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
