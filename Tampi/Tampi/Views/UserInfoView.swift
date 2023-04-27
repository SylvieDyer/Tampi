//
//  UserInfoView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/27/23.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var tampi: Tampi
    @State private var showingSheet = false
    
    var body: some View {
        VStack{
            VStack{
                Text("Welcome to your ").font(.title).bold().padding(.leading, 15)
                    .fontWidth(.expanded)
                    .font(.callout)
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
                }
                
            }.padding(.bottom, 60)
            Button(action: {showingSheet.toggle()}){
                Text("Get Started!").foregroundColor(.indigo.opacity(0.68))
                    .font(.title2)
                    .bold()
                    .font(.callout)
            }
            //            , content: UserInfoSheet.init){
            // Info Sheet
            .sheet(isPresented: $showingSheet){
                UserInfoSheet(tampi: tampi)
                
            }
        }
    }
}


struct UserInfoSheet: View {
    @ObservedObject var tampi: Tampi
    @State private var showingSheet = false
    
    var body: some View{
        Section{
            if (tampi.userInfo.newUser){
                Text("Getting Started").font(.title).bold()
                Text("Please fill out the following fields!").font(.title2).bold()
            }
            else {
                Text("Change User Information").font(.title2).bold()
            }
        }.padding(20)
        
        Form{
            
            Section{
                Text("What's your name?").font(.title3).bold().foregroundColor(.cyan)
                TextField(text: $tampi.userInfo.userName, prompt: Text("Required")) {
                    Text("What's your name?")
                }.bold()
            }
            
            
            Section{
                Text("How long is your average cycle?").font(.title3).bold().foregroundColor(.cyan)
                
                Picker("", selection: $tampi.userInfo.averageCycleLength) {
                    ForEach(20...31, id: \.self) {
                        Text("\($0)").bold()
                        
                    }
                }.pickerStyle(.wheel).frame(height: 100)
            }
            
            Section{
                Text("How many days does your period usually last for?").font(.title3).bold().foregroundColor(.cyan)
                Picker("", selection: $tampi.userInfo.periodLength) {
                    ForEach(2...7, id: \.self) {
                        Text("\($0)").bold()
                    }
                }.pickerStyle(.wheel).frame(height: 100)
            }
            
            
            Button(action: {
                showingSheet = false
                tampi.userInfo.newUser = false
            }){
                HStack{
                    Spacer()
                    if (tampi.userInfo.newUser){
                        Text("I'm ready to use TAMPI!").font(.title2).font(.callout).bold().foregroundColor(.indigo.opacity(0.8))
                    }
                    else {
                        Text("Save").font(.title2).font(.callout).bold().foregroundColor(.indigo.opacity(0.8))
                    }
                    Spacer()
                }
            }.disabled(tampi.userInfo.userName.isEmpty)
        }
    }
}
struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(tampi: Tampi(name: "LAMPI b827ebdb1727"))
    }
}
