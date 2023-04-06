//
//  EduView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI

struct EduView: View {
    @ObservedObject var tampi: Tampi
    var body: some View {
        VStack{
            List {
                Text("Welcome to the Education Page, \(tampi.userInfo.tampiOwnerName)!").bold().font(.title2)
            }.scrollDisabled(true).padding(.bottom, 0).frame(height: 150)
            
            List {
                Section(header: Text("For \(tampi.userInfo.cycleOwnerName)")
                    .font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){
                        Link("Your First Period & You", destination: URL(string:"https://www.google.com/search?client=safari&rls=en&q=sea+anenome&ie=UTF-8&oe=UTF-8")!)
                            .foregroundColor(.teal)
                        Link("Understanding your changing body", destination: URL(string:"https://www.google.com/search?client=safari&rls=en&q=sea+anenome&ie=UTF-8&oe=UTF-8")!)
                            .foregroundColor(.teal)
                    }.bold()
                
                Section(header: Text("For Family").font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){ //footer: Text("We will miss you")) {
                    Link("Understanding your daughter's flow", destination: URL(string:"https://www.google.com/search?client=safari&rls=en&q=sea+anenome&ie=UTF-8&oe=UTF-8")!)
                        .foregroundColor(.teal)
                    Link("Teen Angst or Menstration", destination: URL(string:"https://www.google.com/search?client=safari&rls=en&q=sea+anenome&ie=UTF-8&oe=UTF-8")!)
                        .foregroundColor(.teal)
                    
                }.bold()
                
                Section(header: Text("For Friends").font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58)), footer: Text("A lot to learn")) {
                    Link("When is it ok to ask \"are you on your period\"? ", destination: URL(string:"https://www.google.com/search?client=safari&rls=en&q=sea+anenome&ie=UTF-8&oe=UTF-8")!)
                        .foregroundColor(.teal)
                }.bold()
                
            }.listStyle(GroupedListStyle())
            
            
        }
        Spacer()
        
      
    }
}

// delete later
struct ContentView_Previews5: PreviewProvider {
    static var previews: some View {
        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
            .previewDevice("iPhone 12 Pro")
            .previewLayout(.device)
    }
}

