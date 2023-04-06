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

            // home-header section
        List {
            Text("Welcome Back, \(tampi.userInfo.tampiOwnerName)!").bold().font(.title2)
            VStack{
                Text("Currently tracking ")
                    .foregroundColor(.gray).fontWeight(.semibold) +
                Text("**\(tampi.userInfo.cycleOwnerName)'s** ")
                    .foregroundColor(.purple.opacity(0.78)).fontWeight(.semibold)  +
                Text("cycle")
                    .foregroundColor(.gray).fontWeight(.semibold)
            }
            .font(.title3)
            // .scaledToFit()
            //.minimumScaleFactor(0.01)
            //.lineLimit(1)
            
            // info on cycle
        }.scrollDisabled(true).frame(height: 150)
        List{
            HStack{
                Spacer()
                Text("There are XX days until \(tampi.userInfo.cycleOwnerName)'s cycle begins").font(.title3).multilineTextAlignment(.center).fontWeight(.semibold).foregroundColor(.black.opacity(0.6))
                Spacer()
            }
        }.scrollDisabled(true).frame(height: 130)
            
    
            Divider()
            Text("Control your TAMPI below!").foregroundColor(.indigo.opacity(0.6)).font(.title3).fontWeight(.heavy).multilineTextAlignment(.leading)
           
            
            // list of lampi controls
        List {
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
                    
                    
                    Text("Preset 1")
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
                    
                    
                    Text("Preset 2")
                        .foregroundColor(tampi.lampiState.mode == 2 ? .green.opacity(0.7) : .gray).font(.title3).fontWeight(.heavy)
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
