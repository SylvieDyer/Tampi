//
//  HomeView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI

struct HomeView: View{
    @ObservedObject var tampi: Tampi
    
    var body: some View{
        
        List {
            // home-header section
            Section {
                Text("Welcome Back, \(tampi.userInfo.userName)!").bold().font(.title2)
//                VStack{
//                    Text("Currently tracking ")
//                        .foregroundColor(.gray).fontWeight(.semibold) +
//                    Text("**\(tampi.userInfo.userName)'s** ")
//                        .foregroundColor(.purple.opacity(0.78)).fontWeight(.semibold)  +
//                    Text("cycle")
//                        .foregroundColor(.gray).fontWeight(.semibold)
//                }
//                .font(.title3)
            }
            
            // info on cycle
            Section{
                HStack{
                    Spacer()
                    Text("There are **\(tampi.userInfo.daysUntilNewCycle)** days until your next cycle begins").font(.title3).multilineTextAlignment(.center).fontWeight(.semibold).foregroundColor(.black.opacity(0.6))
                    Spacer()
                }
            }.scrollDisabled(true).frame(height: 130)
            
            
            Text("TAMPI Controls:").foregroundColor(.indigo.opacity(0.6)).font(.title3).fontWeight(.heavy).multilineTextAlignment(.leading)
            
            // list of lampi controls
            Section {
                Button(action:{
                    tampi.lampiState.isOn = !tampi.lampiState.isOn
                })
                {
                    HStack{
                        Image(systemName: "power")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                            .foregroundColor(tampi.lampiState.isOn ? .purple.opacity(0.7) : .gray.opacity(0.7))
                        
                        if (tampi.lampiState.isOn){
                            Text("Turn Off")
                                .foregroundColor(.purple.opacity(0.7)).font(.title3).fontWeight(.heavy)
                        }
                        else{
                            Text("Turn On") .foregroundColor(.gray).font(.title3).fontWeight(.heavy)
                        }
                    }
                }
                
                Button(action:{
                    tampi.lampiState.mode = 0
                })
                {
                    HStack{
                        
                        Image(systemName: "drop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                            .foregroundColor(.red.opacity(0.7))
                        
                        Text("Track Cycle")
                            .foregroundColor(tampi.lampiState.mode == 0 ? .red.opacity(0.7) : .gray).font(.title3).fontWeight(.heavy)
                    }
                }
                Button(action:{
                    tampi.lampiState.mode = 1
                })
                {
                    HStack{
                        Image(systemName: "sun.min.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                            .foregroundColor(.yellow.opacity(0.7))
                        
                        
                        Text("\(tampi.appController.preset1)")
                            .foregroundColor(tampi.lampiState.mode == 1 ? .yellow.opacity(0.7) : .gray).font(.title3).fontWeight(.heavy)
                    }
                }
                Button(action:{
                    tampi.lampiState.mode = 2
                })
                {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit).frame(width: 30, height: 20)
                            .foregroundColor(.green.opacity(0.7))
                        
                        Text("\(tampi.appController.preset2)")
                            .foregroundColor(tampi.lampiState.mode == 2 ? .green.opacity(0.7) : .gray).font(.title3).fontWeight(.heavy)
                    }
                    
                }
            }
            
        }
    }
}


// delete later:
struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}

