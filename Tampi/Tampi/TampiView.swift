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
    
    // the user
    @FetchRequest(
        sortDescriptors: []
    )
    private var users: FetchedResults<User>
    
    // the cycle dates entity
    @FetchRequest(sortDescriptors: [])
    private var cycleDates: FetchedResults<CycleDates>
    
    
    var body: some View {
        if (users.isEmpty || users.first!.newUser) {
            UserInfoView(tampi: tampi, viewContext: viewContext)
        }
        
        else if (users.first!.newUser == false) {
            
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
                        TrackerView(tampi: tampi, user: users.first!, viewContext: viewContext)
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
                        updateTampiCalendar()               // pull data from DB for calendar
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
                        updateSettingsInfo()             // pull data from DB for settings page
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
    
    private func updateTampiCalendar(){
        // if there is info to save,
        if (!cycleDates.isEmpty){
            // if the app has just ben reopened (no data in cycleDates), add all dates
            if (tampi.userInfo.cycleDates.count == 0 ){
                let formatter = DateFormatter()
                formatter.dateFormat = "M/dd/yyyy"
                for entity in cycleDates{
                    tampi.userInfo.cycleDates.insert(entity.cycleDate!)
                    let dayToAdd = formatter.date(from: entity.cycleDate!)
                    tampi.userInfo.editCycleDates.insert(Calendar.current.dateComponents([.year, .month, .day], from: dayToAdd!))
                }
                tampi.userInfo.predict()
            }
        }
    }
    
    private func updateSettingsInfo(){
        // if the DB isn't empty, and the info hasn't been updated
        if (!users.isEmpty && tampi.userInfo.userName != users.first!.name){
            tampi.userInfo.userName = users.first!.name ?? "No Name Entered"
            tampi.userInfo.averageCycleLength = Int(users.first!.avgCycleLength)
            tampi.userInfo.periodLength = Int(users.first!.periodLength)
            tampi.appController.preset1 = users.first!.preset1 ?? "Preset 1"
            tampi.appController.preset2 = users.first!.preset2 ?? "Preset 2"
        }
    }
}
