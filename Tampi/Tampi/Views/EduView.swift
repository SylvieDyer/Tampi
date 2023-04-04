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
        List {
            Text("Welcome to the Education Page \(tampi.userInfo.tampiOwnerName)").bold().font(.title2)
        }.scrollDisabled(true)
        List{}
        Spacer()
    }
}

