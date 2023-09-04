//
//  Protocols.swift
//  ruswarlosses
//
//  Created by Vitaliy on 29.08.2023.
//

import Foundation
import SwiftUI


protocol StatsData: Codable, Identifiable {}

struct Dummy: StatsData {
    var id: UUID = UUID()
    let dummy: Int
}

struct StatisticsData: Codable, Identifiable {
    let id: UUID = UUID()
    
    let date: String
    let day: Int
    let aircraft: Int
    let helicopter: Int
    let tank: Int
    let APC: Int
    let field_artillery: Int
    let MRL: Int
    let military_auto: Int
    let fuel_tank: Int
    let drone: Int
    let naval_ship: Int
    let antiaircraft_warfare: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case day
        case aircraft
        case helicopter
        case tank
        case APC
        
        case field_artillery = "field artillery"
        
        case MRL
        
        case military_auto = "military auto"
        case fuel_tank = "fuel tank"
        
        case drone
        
        case naval_ship = "naval ship"
        case antiaircraft_warfare = "anti-aircraft warfare"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try values.decode(String.self, forKey: .date)
        day = try values.decode(Int.self, forKey: .day)
        aircraft = try values.decode(Int.self, forKey: .aircraft)
        helicopter = try values.decode(Int.self, forKey: .helicopter)
        tank = try values.decode(Int.self, forKey: .tank)
        APC = try values.decode(Int.self, forKey: .APC)
        field_artillery = try values.decode(Int.self, forKey: .field_artillery)
        MRL = try values.decode(Int.self, forKey: .MRL)
        military_auto = (try? values.decode(Int.self, forKey: .military_auto)) ?? 0
        fuel_tank = (try? values.decode(Int.self, forKey: .fuel_tank)) ?? 0
        drone = try values.decode(Int.self, forKey: .drone)
        naval_ship = try values.decode(Int.self, forKey: .naval_ship)
        antiaircraft_warfare = try values.decode(Int.self, forKey: .antiaircraft_warfare)
    }
}

struct EquipmentTitles {
    let aircraft = "Planes"
    let helicopter = "Helicopters"
    let tank = "Tanks"
    let APC = "APC"
    let field_artillery = "Arty"
    let MRL = "MRL"
    let military_auto = "Cars"
    let fuel_tank = "Fuel tanks"
    let drone = "Drones"
    let naval_ship = "Ships"
    let antiaircraft_warfare = "AA"
}

struct PropertyHelper {
    let keyPath: AnyKeyPath
    let name: String
//    var state: Bool = false
    
//    init<T>(_ keyPath: KeyPath<Root, T>, _ propertyName: String) {
//            self.keyPath = keyPath
//            self.propertyName = propertyName
//        }
}

let EquipmentKeys = [
    "aircraft": PropertyHelper(keyPath: \StatisticsData.aircraft, name: "Planes"),
    "helicopter": PropertyHelper(keyPath: \StatisticsData.helicopter, name: "Helicopters"),
    "tank": PropertyHelper(keyPath: \StatisticsData.tank, name: "Tanks"),
    "APC": PropertyHelper(keyPath: \StatisticsData.APC, name: "APC"),
    "field_artillery": PropertyHelper(keyPath: \StatisticsData.field_artillery, name: "Artys"),
    "MRL": PropertyHelper(keyPath: \StatisticsData.MRL, name: "MRL"),
    "military_auto": PropertyHelper(keyPath: \StatisticsData.military_auto, name: "Cars"),
    "fuel_tank": PropertyHelper(keyPath: \StatisticsData.fuel_tank, name: "Fuel tanks"),
    "drone": PropertyHelper(keyPath: \StatisticsData.drone, name: "Drones"),
    "naval_ship": PropertyHelper(keyPath: \StatisticsData.naval_ship, name: "Ships"),
    "antiaircraft_warfare": PropertyHelper(keyPath: \StatisticsData.antiaircraft_warfare, name: "AA"),
]

//struct ChartData {
//    let title: String
//    let Ytitle: String
//    let Xtitle: String
//    let points: [Int]
//    let values: [String]?
//    let color: Color?
//}

struct ChartData {
    let title: String
    let points: [Int]
    let values: [String]?
    let color: Color?
}
