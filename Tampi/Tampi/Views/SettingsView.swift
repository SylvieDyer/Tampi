//
//  SettingsView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @ObservedObject var tampi: Tampi
    var user: User
    var viewContext: NSManagedObjectContext
    // to dictate sheet opening
    @State private var showUserInfo = false
    @State private var showChangePresets = false
    @State private var showChangePresetNames = false
    
    var body: some View {
        List {
            Section {
                Text("Welcome to the Settings Page, \(tampi.userInfo.userName)!").bold().font(.title2)
            }
            Section{
                // edit user settings
                Button("User Settings") {
                    showUserInfo.toggle()
                }
                .sheet(isPresented: $showUserInfo) {
                    UserInfoSheet(tampi: tampi, user: user, viewContext: viewContext)
                }
                .fontWeight(.heavy)
                .foregroundColor(.indigo)
                .font(.title3)
                
                // edit presets
                Button("Change Presets") {
                    showChangePresets.toggle()
                }
                .sheet(isPresented: $showChangePresets) {
                    
                    VStack{
                        Text("Change Presets")
                        Spacer()
                    }
                }
                
                // edit preset names
                Button("Change Preset Names") {
                    showChangePresetNames.toggle()
                }
                .sheet(isPresented: $showChangePresetNames) {
                   // title
                    HStack(alignment: .center){
                        Text("Change the names of your lamp presets!").font(.title2).bold()
                    }.padding(20)
                    // form to prevent blank values
                    Form{
                        // preset 1 name
                        Section{
                            Text("Change Preset1's Name: ").font(.title3).bold().foregroundColor(.gray)
                            
                            TextField(text: $tampi.appController.preset1, prompt: Text("Required")) {
                                Text("Preset 1 Name?")
                            }.bold()
                        }
                        // preset2 name
                        Section{
                            Text("Change Preset2's Name: ").font(.title3).bold().foregroundColor(.gray)
                            
                            TextField(text: $tampi.appController.preset2, prompt: Text("Required")) {
                                Text("Preset 2 Name?")
                            }.bold()
                        }
                        // save button (to exit)
                        Section(footer: Text("All fields must be filled to save!").font(.subheadline)){
                            Button(action: {
                                showChangePresetNames = false
                            }){
                                HStack(alignment: .center){
                                    Text("Save Changes").font(.title2).font(.callout).bold().foregroundColor(.indigo.opacity(0.8))
                                }
                            }
                        }.disabled(tampi.appController.preset1.isEmpty || tampi.appController.preset2.isEmpty)
                    }.interactiveDismissDisabled(true)
                }
            }
            .fontWeight(.heavy)
            .font(.title3)
            .foregroundColor(.indigo)
                
        }.scrollDisabled(true).padding(.bottom, 0)
        
        Spacer()
    }
}

//struct ContentView_Previews2: PreviewProvider {
//    static var previews: some View {
//        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
//            .previewDevice("iPhone 12 Pro")
//            .previewLayout(.device)
//    }
//}

