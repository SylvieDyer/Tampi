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
                Section{
                    Text("Welcome to the Education Page, \(tampi.userInfo.userName)!").bold().font(.title2)
                }
                
                Section {
                    Section(header: Text("For YOU")
                        .font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){
                            Link("Understanding the Menstrual Cycle", destination: URL(string:"https://www.mayoclinic.org/healthy-lifestyle/womens-health/in-depth/menstrual-cycle/art-20047186")!)
                                .foregroundColor(.teal)
                            Link("More On Premenstrual Syndrome", destination: URL(string:"https://www.mayoclinic.org/diseases-conditions/premenstrual-syndrome/symptoms-causes/syc-20376780")!)
                                .foregroundColor(.teal)
                        }.bold()
                    
                    Section(header: Text("For Family").font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){ //footer: Text("We will miss you")) {
                        Link("Fostering an Open Discussion About Menstruation", destination: URL(string:"https://mcpress.mayoclinic.org/parenting/dads-daughters-and-talking-about-menstruation-advice-from-an-expert/")!)
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
            .padding(.bottom, 0)
            
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

