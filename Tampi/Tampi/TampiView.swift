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
        VStack(alignment: .leading) {
            Text("Tampi").multilineTextAlignment(.leading).bold().padding()
     
            Text("Currently viewing \(tampi.userInfo.cycleOwnerName)'s cycle")
            Spacer()
            
            HStack{
                Button(action: nil) {
                    Text("Sign In")
                }
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
