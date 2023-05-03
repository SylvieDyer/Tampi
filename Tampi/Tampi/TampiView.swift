//
//  TampiView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/3/23.
//

import SwiftUI

struct TampiView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var tampi: Tampi
 
    // new user
    @FetchRequest(
        sortDescriptors: []
    )
    private var users: FetchedResults<User>
    
    var body: some View {
        if (users.isEmpty || users.first!.newUser){
            UserInfoView(tampi: tampi, viewContext: viewContext)
        }
            
        else if (users.first!.newUser == false){
            
            VStack {
                HStack(alignment: .lastTextBaseline, spacing:0){
                    Text("Tamp").font(.largeTitle).bold().padding(.leading, 15)
                        .fontWidth(.expanded)
                        .font(.callout)
                    Image(systemName:"balloon.fill")
                        .resizable()
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: 10, height: 36)
                        .foregroundColor(.black)
                        .padding(.leading, 2)
                    Spacer()
                }
                
                VStack{
                    if (tampi.appController.home){
                        HomeView(tampi: tampi, user: users.first!)
                    }
                    else if (tampi.appController.tracker){
                        TrackerView(tampi: tampi, user: users.first!)
                    }
                    else if (tampi.appController.education){
                        EduView(tampi: tampi, name: users.first!.name!)
                        
                    }
                    else if (tampi.appController.settings){
                        SettingsView(tampi: tampi, user: users.first!, viewContext: viewContext)
                    }
                    
                }
                
                // bottom nav bar
                HStack{
                    
                    Button(action:{ tampi.appController.setHome() }){
                        Image(systemName: "house.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 60, height: 30)
                            .foregroundColor(tampi.appController.home ? .orange.opacity(0.95) : .gray)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                    .frame(width: 100)
                    .background(tampi.appController.home ? .white.opacity(0.3) : .clear)
                    
                    Button(action: {
                        tampi.appController.setTracker()
                    }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 60, height: 30)
                            .foregroundColor(tampi.appController.tracker ? .teal.opacity(0.75) : .gray)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                    .frame(width: 100)
                    .background(tampi.appController.tracker ? .white.opacity(0.3) : .clear)
                    
                    Button(action: {
                        tampi.appController.setEducation()
                    }) {
                        Image(systemName: "graduationcap.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 60, height: 30)
                            .foregroundColor(tampi.appController.education ? .pink.opacity(0.75) : .gray)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                    .frame(width: 100)
                    .background(tampi.appController.education ? .white.opacity(0.3) : .clear)
                    
                    Button(action: {
                        tampi.appController.setSettings()
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 60, height: 30)
                            .foregroundColor(tampi.appController.settings ? .blue.opacity(0.75) : .gray)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                    .frame(width: 100)
                    .background(tampi.appController.settings ? .white.opacity(0.3) : .clear)
                    
                    
                }.background(Color.indigo.opacity(0.25).edgesIgnoringSafeArea(.bottom))
            }
        }
        
    }
    
//    private func saveInfo(){
////        let newUser = User(context: viewContext)
////        newUser.newUser = false
////        newUser.avgCycleLength = Int32(tampi.userInfo.averageCycleLength)
////        newUser.periodLength = Int32(tampi.userInfo.periodLength)
////        newUser.name = tampi.userInfo.userName
//        users.first!.newUser = false
//        users.first!.avgCycleLength = Int32(tampi.userInfo.averageCycleLength)
//        users.first!.periodLength = Int32(tampi.userInfo.periodLength)
//        users.first!.name = tampi.userInfo.userName
//
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
//            .previewDevice("iPhone 12 Pro")
//            .previewLayout(.device)
//    }
//}
