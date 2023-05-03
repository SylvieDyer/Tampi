//
//  EduView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI

struct EduView: View {
    @ObservedObject var tampi: Tampi
    var name: String
    
    var body: some View {
        VStack{
            List {
                Section{
                    Text("Welcome to the Education Page, \(tampi.userInfo.userName)!").bold().font(.title2)
                    Text("Explore these medically verified resources to learn more about the menstural cycle:  ").font(.subheadline).bold()
                }
                
                Section {
                    Section(header: Text("For YOU")
                        .font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){
                            Link("Understanding the Menstrual Cycle", destination: URL(string:"https://www.mayoclinic.org/healthy-lifestyle/womens-health/in-depth/menstrual-cycle/art-20047186")!)
                                .foregroundColor(.teal)
                            Link("More On Premenstrual Syndrome", destination: URL(string:"https://www.mayoclinic.org/diseases-conditions/premenstrual-syndrome/symptoms-causes/syc-20376780")!)
                                .foregroundColor(.teal)
                            Link("Your Period in 2 Minutes", destination: URL(string:"https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiu6c7Lh7b-AhVjJkQIHVV0DSgQtwJ6BAgOEAI&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DWOi2Bwvp6hw&usg=AOvVaw23-I86CCWqGhKGZWnKvZmE")!)
                                .foregroundColor(.teal)
                            Link("Where to Find Free Feminine Products", destination: URL(string:"https://www.goodrx.com/health-topic/womens-health/free-tampons-and-period-menstrual-products")!)
                                .foregroundColor(.teal)
                            
                        
                        }.bold()
                    
                    Section(header: Text("For Family").font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){ //footer: Text("We will miss you")) {
                        Link("Fostering an Open Discussion About Menstruation", destination: URL(string:"https://mcpress.mayoclinic.org/parenting/dads-daughters-and-talking-about-menstruation-advice-from-an-expert/")!)
                            .foregroundColor(.teal)
                        Link("Talking About Periods with your Child", destination: URL(string:"https://kidshealth.org/en/parents/talk-about-menstruation.html")!)
                            .foregroundColor(.teal)
                        
                    }.bold()
                    
                    Section(header: Text("For Friends").font(.title3).fontWeight(.heavy).foregroundColor(.black.opacity(0.58))){
                        Link("How to Support A Friend on Their Period", destination: URL(string:"https://www.thedailystar.net/shout/news/how-be-supportive-friend-her-period-1792009")!)
                            .foregroundColor(.teal)
                    }.bold()
                    
                }.listStyle(GroupedListStyle())
                
            }
            .padding(.bottom, 0)
        }
        Spacer()
        
      
    }
}

//// delete later
//struct ContentView_Previews5: PreviewProvider {
//    static var previews: some View {
//        TampiView(tampi: Tampi(name: "LAMPI b827ebdb1217"))
//            .previewDevice("iPhone 12 Pro")
//            .previewLayout(.device)
//    }
//}

