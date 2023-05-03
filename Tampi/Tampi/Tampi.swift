//
//  Tampi.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/3/23.
//

import Foundation
import CoreBluetooth
import Combine
import SwiftUI

class Tampi: NSObject, ObservableObject {
    let name: String
    @Published var lampiState = LampiState() {
        didSet {
            if oldValue != lampiState {
                updateDevice()
            }
        }
    }
    
    @Published var userInfo = UserInfo()
    @Published var appController = AppController()
    
    private func setupPeripheral() {
        if let lampiPeripheral = lampiPeripheral  {
            lampiPeripheral.delegate = self
        }
    }

    private var bluetoothManager: CBCentralManager?

    var lampiPeripheral: CBPeripheral? {
        didSet {
            setupPeripheral()
        }
    }
    
    // to track the Mode the lampi is on (Cycle Tracking, Preset) and related HS
    private var HSMCharacteristic: CBCharacteristic?
    // to track the power state of the lampi (TODO: IDK IF WE WANT THIS)
    private var powerStateCharacteristic: CBCharacteristic?
    // to track the number of days to next cycle
    private var remaningDaysCharacteristic: CBCharacteristic?

    private var skipNextDeviceUpdate = false
    private var pendingBluetoothUpdate = false

    init(name: String) {
        self.name = name
        super.init()

        self.bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }

    init(lampiPeripheral: CBPeripheral) {
        guard let peripheralName = lampiPeripheral.name else {
            fatalError("Tampi must initialized with a peripheral with a name")
        }

        self.lampiPeripheral = lampiPeripheral
        self.name = peripheralName

        super.init()

        self.setupPeripheral() // properties set in init() do not trigger didSet
    }
}

extension Tampi {
//       Implement HSV characteristic (to change cylce color)?
//       Add brightness (maybe no)
    static let SERVICE_UUID = CBUUID(string: "0001A7D3-D8A4-4FEA-8174-1736E808C066")
    static let HSM_UUID = CBUUID(string: "0002A7D3-D8A4-4FEA-8174-1736E808C066")
    static let POWERSTATE_UUID = CBUUID(string: "0004A7D3-D8A4-4FEA-8174-1736E808C066")
    static let DAYS_UUID = CBUUID(string: "0006A7D3-D8A4-4FEA-8174-1736E808C066")
    
    private var shouldSkipUpdateDevice: Bool {
        return skipNextDeviceUpdate || pendingBluetoothUpdate
    }

    private func updateDevice(force: Bool = false) {
        if lampiState.isConnected && (force || !shouldSkipUpdateDevice) {
            pendingBluetoothUpdate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                
                self?.writePowerState()
                self?.writeHSM()
                self?.writeDays()
                
                self?.pendingBluetoothUpdate = false
            }
        }

        skipNextDeviceUpdate = false
    }

    private func writePowerState() {
        if let powerStateCharacteristic = powerStateCharacteristic {
            let data = Data(bytes: &lampiState.isOn, count: 1)
            lampiPeripheral?.writeValue(data, for: powerStateCharacteristic, type: .withResponse)
        }
    }
    
    private func writeDays() {
        if let remaningDaysCharacteristic = remaningDaysCharacteristic {
            let data = Data(bytes: &userInfo.daysUntilNewCycle, count: 1)
            lampiPeripheral?.writeValue(data, for: remaningDaysCharacteristic, type:.withResponse)
        }
    }
        
    private func writeHSM() {
        if let HSMCharacteristic = HSMCharacteristic {
            var hsm: UInt32 = 0
            let mode = UInt32(lampiState.mode)
            var hueInt = UInt32(0.0)
            var satInt = UInt32(1.0)
            
            // TODO: Tie the custom presets to custom ones?
            if mode == 0 {
                hueInt = UInt32(0.0 * 255.0)
                satInt = UInt32(1.0 * 255.0)
            }
            else if mode == 1 {
                hueInt = UInt32(0.141 * 255.0)
                satInt = UInt32(0.92 * 255.0)
            }
            else {
                hueInt = UInt32(0.411 * 255.0)
                satInt = UInt32(1.00 * 255.0)
            }
            
            hsm = hueInt
            hsm += satInt << 8
            hsm += mode << 16
            
            let data = Data(bytes: &hsm, count: 3)
            lampiPeripheral?.writeValue(data, for: HSMCharacteristic, type: .withResponse)
        }
    }
}

extension Tampi {
    // to track changes on the lamp (may not even be doing this ?)
    struct LampiState: Equatable {
        var isConnected = false
        var isOn = false
        var mode: Int = 0
        var hue: Double = 0.0
        var sat: Double = 0.0
    }
    
    struct UserInfo: Equatable {
        // menstruator name
        var userName: String = ""
        
        // average cycle length - defaults at 28
        var averageCycleLength: Int = 28
        
        // average period length
        var periodLength: Int = 5
        
        // the period dates "4/4/2023"
        var cycleDates: Set<String> = []
        
        // preiod dates when editing the dates of the period
        var editCycleDates: Set<DateComponents> = []
        
        // calculates the first day of the period based on the length
        var dayOne: String {
            cycleDates.sorted()[cycleDates.count - periodLength]
        }
        
        // the the days fo the next cycle
        var nextCycle: Set<Date> = []
        
        // predicts the next period, based on length and cycle length
        mutating func predict(){
            // predict when there is user data
            if (!cycleDates.isEmpty){
                
                let formatter = DateFormatter()
                formatter.dateFormat = "M/dd/yyyy"
                
                // determine the start of the next cycle
                let newDayOne = Calendar.current.date(byAdding: .day, value: averageCycleLength, to: formatter.date(from: dayOne)!)
                nextDayOne = newDayOne!
                nextCycle = [nextDayOne]
                
                // mark the predicted period 
                for i in 1...periodLength-1 {
                    nextCycle.insert(Calendar.current.date(byAdding: .day, value: i, to: newDayOne!)!)
                }
                // dayOne+ averageCycleLength
                daysUntilNewCycle =  Int(nextDayOne.timeIntervalSince(Date())/86400)
            }
        }
        
        // the start of the next cycle
        var nextDayOne: Date = Date()
        
        // finds the days until the next cycle
        var daysUntilNewCycle: Int = 666
    }
    
    // to control the app & page being shown
    struct AppController: Equatable{
        var home = true
        var tracker = false
        var education = false
        var settings = false
        var editTracker = false
        var preset1 = "Preset1"
        var preset2 = "Preset2"
    
        mutating func setHome(){
            home = true
            tracker = false
            education = false
            settings = false
        }
        
        mutating func setTracker(){
            tracker = true
            home = false
            education = false
            settings = false
        }
        
        mutating func setEducation(){
            education = true
            home = false
            tracker = false
            settings = false
        }
        
        mutating func setSettings(){
            settings = true
            home = false
            tracker = false
            education = false
            
        }
    }
}

extension Tampi: CBCentralManagerDelegate {
    private static let DEVICE_NAME_L = "TAMPI b827eb3d9134"
    private static let DEVICE_NAME_S = "TAMPI b827ebdb1727"
    private static let OUR_SERVICE_UUID = "0001A7D3-D8A4-4FEA-8174-1736E808C066"
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("SCANNING>>")
        if central.state == .poweredOn {
            let services = [CBUUID(string:Tampi.OUR_SERVICE_UUID)]
            bluetoothManager?.scanForPeripherals(withServices: services)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == Tampi.DEVICE_NAME_L || peripheral.name == Tampi.DEVICE_NAME_S {
            print("Found \(peripheral.name)")

            lampiPeripheral = peripheral

            bluetoothManager?.stopScan()
            bluetoothManager?.connect(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string:Tampi.OUR_SERVICE_UUID)])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral \(peripheral)")
        lampiState.isConnected = false
        bluetoothManager?.connect(peripheral)
    }
}


extension Tampi: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Found: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            switch characteristic.uuid {
            case Tampi.DAYS_UUID:
                self.remaningDaysCharacteristic = characteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
                
            case Tampi.HSM_UUID:
                self.HSMCharacteristic = characteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)

            case Tampi.POWERSTATE_UUID:
                self.powerStateCharacteristic = characteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)

            default:
                continue
            }
        }

        // not connected until all characteristics are discovered
        if self.HSMCharacteristic != nil && self.remaningDaysCharacteristic != nil && self.powerStateCharacteristic != nil {
            skipNextDeviceUpdate = true
            lampiState.isConnected = true
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        skipNextDeviceUpdate = true

        guard let updatedValue = characteristic.value,
              !updatedValue.isEmpty else { return }

        switch characteristic.uuid {
        case Tampi.HSM_UUID:
            lampiState.mode = parseHSM(for: updatedValue)

        case Tampi.POWERSTATE_UUID:
            lampiState.isOn = parsePowerState(for: updatedValue)

        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }

    private func parsePowerState(for value: Data) -> Bool {
        return value.first == 1
    }

    private func parseHSM(for value: Data) -> Int {
        return Int(value[2])
    }
    
    private func parseMode(for value: Data) -> Int {
        return Int(value[0])
    }
}
