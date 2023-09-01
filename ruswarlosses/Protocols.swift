//
//  Protocols.swift
//  ruswarlosses
//
//  Created by Vitaliy on 29.08.2023.
//

import Foundation


protocol StatsData: Codable, Identifiable {}

struct Dummy: StatsData {
    var id: UUID = UUID()
    let dummy: Int
}

struct StatisticsData: StatsData {
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
