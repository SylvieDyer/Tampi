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
    
    // to track the mode the lampi is on (Cycle Tracking, Preset)
    private var lampiModeCharacteristic: CBCharacteristic?
    // to track the power state of the lampi (TODO: IDK IF WE WANT THIS)
    private var powerStateCharacteristic: CBCharacteristic?

    // MARK: State Tracking
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
    // TODO: FRom class may want to change?
    static let SERVICE_UUID = CBUUID(string: "0001A7D3-D8A4-4FEA-8174-1736E808C066")
    static let POWERSTATE_UUID = CBUUID(string: "0004A7D3-D8A4-4FEA-8174-1736E808C066")
    static let MODE_UUID = CBUUID(string: "0005A7D3-D8A4-4FEA-8174-1736E808C066")
    
    private var shouldSkipUpdateDevice: Bool {
        return skipNextDeviceUpdate || pendingBluetoothUpdate
    }

    private func updateDevice(force: Bool = false) {
        if lampiState.isConnected && (force || !shouldSkipUpdateDevice) {
            pendingBluetoothUpdate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.writePowerState()
                self?.writeLampiMode()

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
    
    private func writeLampiMode() {
        if let lampiModeCharacteristic = lampiModeCharacteristic {
            let data = Data(bytes: &lampiState.mode, count: 1)
            lampiPeripheral?.writeValue(data, for: lampiModeCharacteristic, type: .withResponse)
        }
    }
    
}

extension Tampi {
    
   
    // to track changes on the lamp (may not even be doing this ?)
    struct LampiState: Equatable {
        var isConnected = false
        var isOn = false
        var mode: Double = 0.0
    }
    
    struct UserInfo: Equatable {
        // who owns the Lampi?
        var tampiOwnerName: String = "Sylvie" // DEFAULT FOR NOW
        // if the Tampi is tracking their own cycle or not
        var userCycle = false
        // name of the cycle owner
        var cycleOwnerName: String{
            userCycle ? tampiOwnerName : "Luis" // DEFAULT FOR NOW
        }
        
        // average cycle length - defaults at 28
        var averageCycleLength: Double = 28
        
        // TODO: how to hold the dates: maybe hold the current cycle in this struct, and then generate calendar stuff elsewhere?
        // TODO: ORRRR, use a hashtable with a deafaulf of 31 keys where the values will be boleans to indicate period or not?
        var cycleInfo: [Int: Bool] = [:]
        
        var dayOne = Date()
        var cycleDates: Set<DateComponents> = []
        
//        var setDates: Set<DateComponents>{
//            //return dates
//        }
        
        init(){
            // to set up the hash table with dates
            for i in 1 ... 31 {
                cycleInfo[i] = false
            }
        }
        //TODO: updating on app: each number on calendar will be value in hash table? or somethign that is a listener maybe each on eis a button with an id being the motn and date and we go from there... not sure... easiest thingw ould be to only allow one cucle at once on the calendar page (so if ur period comes from March 27 - April 3, you only see like... half of march and half of april (rather than being able to click an arrow to see ach separately? idk not sure.
        
        // TODO: Futher thoughts... bc we won't be sending the calendar over BLE, we'll just be sending a value or smthn that will get parsed on the lampi end maybe indicating what color it shold be ? not rly sure how to pass data otherwise , but if eel like passing the info ab where in cycle makes sense to me . also we won't be listening for changes from BLE either for the cycle information
    }
    
    struct AppController: Equatable{
        var home = false //TODO: CHANGE BACK
        var tracker = true
        var education = false
        var settings = false
        var editTracker = false
    
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
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            bluetoothManager?.scanForPeripherals(withServices: [Tampi.SERVICE_UUID])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == name {
            print("Found \(name)")

            lampiPeripheral = peripheral

            bluetoothManager?.stopScan()
            bluetoothManager?.connect(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices([Tampi.SERVICE_UUID])
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
            case Tampi.MODE_UUID:
                self.lampiModeCharacteristic = characteristic
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
        if self.lampiModeCharacteristic != nil && self.powerStateCharacteristic != nil {
            skipNextDeviceUpdate = true
            lampiState.isConnected = true
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        skipNextDeviceUpdate = true

        guard let updatedValue = characteristic.value,
              !updatedValue.isEmpty else { return }

        switch characteristic.uuid {
        case Tampi.MODE_UUID:

            lampiState.mode = parseMode(for: updatedValue)

        case Tampi.POWERSTATE_UUID:
            lampiState.isOn = parsePowerState(for: updatedValue)

        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }

    private func parsePowerState(for value: Data) -> Bool {
        return value.first == 1
    }

    private func parseMode(for value: Data) -> Double {
        return Double(value[0])
    }
}
