//
//  TampiApp.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/3/23.
//

import SwiftUI

@main
struct TampiApp: App {

    #warning("Update DEVICE_NAME")
    let DEVICE_NAME = "LAMPI XXXXXXX"
    let USE_BROWSER = false

    var body: some Scene {
        WindowGroup {
            TampiView(tampi: Tampi(name: DEVICE_NAME))
        }
    }

}


