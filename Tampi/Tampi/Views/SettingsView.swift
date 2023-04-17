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
    @State private var showChangePresets = false

    var body: some View {
        List {
            Section {
                Text("Welcome to the Settings Page, \(tampi.userInfo.userName)!").bold().font(.title2)
            }
            Section{
                Button("Change Username") {
                    showChangeTampiOwner.toggle();
                    tampi.userInfo.resetEditPlaceholder()
                }
                .sheet(isPresented: $showChangeTampiOwner) {
                    VStack{
                        SheetView()
                        Text("Change Username:")
                        HStack{
                            Spacer()
                            TextField(
                                "Enter New Username Here",
                                text: $tampi.userInfo.editingUserName
                            )
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.indigo.opacity(0.2))
                            .cornerRadius(10)
                            
                            Spacer()
                        }
                        Button("Save"){
                            if (tampi.userInfo.editingUserName != ""){
                                tampi.userInfo.userName = tampi.userInfo.editingUserName
                            }
                        }
                        Spacer()
                    }
                }
                .fontWeight(.heavy)
                .foregroundColor(.indigo)
                .font(.title3)
                
                Button("Change Presets") {
                    showChangePresets.toggle()
                }
                .sheet(isPresented: $showChangePresets) {
                    VStack{
                        SheetView()
                        
                        Text("Change Presets")
                        Spacer()
                    }
                }
            }
                    
            .fontWeight(.heavy)
            .foregroundColor(.indigo)
            .font(.title3)
                
        }.scrollDisabled(true).padding(.bottom, 0)
        
        Spacer()
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack{
            Spacer()
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
