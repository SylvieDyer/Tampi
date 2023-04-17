//
//  SettingsView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var tampi: Tampi
    @State private var showChangeTampiOwner = false

    
    var body: some View {
        List {
            Text("Welcome to the Settings Page, \(tampi.userInfo.tampiOwnerName)!").bold().font(.title2)
        }.scrollDisabled(true).padding(.bottom, 0).frame(height: 150)
       
        // tbd what settings we're changing
        List{
            Button("Change Tampi Owner's Name") {
                showChangeTampiOwner.toggle()
            }
            .sheet(isPresented: $showChangeTampiOwner) {
                VStack{
                    SheetView()
                    
                    Text("??")
                    Spacer()
                }
            }
            
            Text("Change Tampi Owner-Name")
            Text("Change Cycle Owner-Name")
            Text("Change Color Scheme")
            Text("Change Presets")
        }.bold()
        Spacer()
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack{
            Spacer()
            
//            Button(Image(systemName: "exit")) {
//                Image(systemName: "exit")
//                dismiss()
//            }
//
            Button(action:{
                dismiss()
            })
            {
                HStack{
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                        .foregroundColor(.black)
                }
            }
            
            .font(.title)
            .padding()
           
        }
        
        Spacer()
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}
