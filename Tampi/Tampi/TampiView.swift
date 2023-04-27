//
//  TampiView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/3/23.
//

import SwiftUI

struct TampiView: View {
    @ObservedObject var tampi: Tampi
    
    var body: some View {
        if (tampi.userInfo.newUser){
            UserInfoView(tampi: tampi)
        }
        else {
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
                        HomeView(tampi: tampi)
                    }
                    else if (tampi.appController.tracker){
                        TrackerView(tampi: tampi)
                    }
                    else if (tampi.appController.education){
                        EduView(tampi: tampi)
                        
                    }
                    else if (tampi.appController.settings){
                        SettingsView(tampi: tampi)
                    }
                    
                }
                
                // bottom nav bar
                HStack{
                    
                    Button(action:{
                        tampi.appController.setHome()
                    }){
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}
