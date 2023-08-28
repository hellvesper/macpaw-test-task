//
//  ContentView.swift
//  ruswarlosses
//
//  Created by Vitaliy on 24.08.2023.
//

import Charts
import SwiftUI

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

//let keyPaths: [KeyPath<StatisticsData, Int>] = [
//    \.day,
//    \.aircraft,
//    \.helicopter,
//     \.tank,
//     \.APC,
//     \.field_artillery,
//     \.MRL,
//     \.military_auto,
//     \.fuel_tank,
//     \.drone,
//     \.naval_ship,
//     \.antiaircraft_warfare
//]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    @State private var statisticsData: [StatisticsData] = []
    @State private var isFetchingData = false
    @State private var selectedChartType: ChartType = .bar
    
    enum ChartType {
        case bar
        case line
    }
    
    var body: some View {
        VStack {
            Picker("Chart Type", selection: $selectedChartType) {
                Text("Bar Chart").tag(ChartType.bar)
                Text("Line Chart").tag(ChartType.line)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Fetch Data") {
                fetchData()
            }
            .padding()
            
            if isFetchingData {
                ProgressView("Fetching Data...")
            } else if !statisticsData.isEmpty {
                if selectedChartType == .bar {
                    BarChart(data: statisticsData)
                        .frame(height: 300)
                        .padding()
                } else if selectedChartType == .line {
                    LineChart(data: statisticsData, fieldKeys: [\.tank, \.APC, \.field_artillery])
                        .frame(height: 300)
                        .padding()
                }
            }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: "https://raw.githubusercontent.com/MacPaw/2022-Ukraine-Russia-War-Dataset/main/data/russia_losses_equipment.json") else {
            return
        }
        
        isFetchingData = true
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            defer {
                DispatchQueue.main.async {
                    isFetchingData = false
                }
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([StatisticsData].self, from: data)
                    DispatchQueue.main.async {
                        statisticsData = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}


struct BarChart: View {
    let data: [StatisticsData]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 10) {
                ForEach(data, id: \.id) { entry in
                    VStack {
                        Text("\(entry.tank)")
                            .foregroundColor(.white)
                            .padding(.top, 5)
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: self.getHeight(entry: entry))
                            .frame(width: 30)
                        Text(entry.date)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, 10) // Add padding for better spacing
        }
    }
    
    func getHeight(entry: StatisticsData) -> CGFloat {
        let maxBarHeight: CGFloat = 150  // You can adjust this value
        let percentage = CGFloat(entry.tank) / CGFloat(data.max(by: { $0.tank < $1.tank })?.tank ?? 1)
        return maxBarHeight * percentage
    }
}


struct LineChart: View {
    let data: [StatisticsData]
//    let fieldKey: KeyPath<StatisticsData, Int>
    let fieldKeys: [KeyPath<StatisticsData, Int>]
    
    static var color: [Color] = [.blue, .cyan, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal, .yellow, .gray]
    
    var body: some View {
        ZStack {
            ForEach(fieldKeys, id: \.self) { keyPath in
                drawLineChart(fk: keyPath)
            }
        }
    }
    
    private func drawLineChart(fk: KeyPath<StatisticsData, Int>) -> some View {
        GeometryReader { geometry in
            Path { path in
                for (index, entry) in data.enumerated() {
                    let x = geometry.size.width / CGFloat(data.count - 1) * CGFloat(index)
                    let y = geometry.size.height - self.getY(entry: entry, geometry: geometry, fk: fk)
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(lineColor(), lineWidth: 2)
        }
    }
    
    func getY(entry: StatisticsData, geometry: GeometryProxy, fk: KeyPath<StatisticsData, Int>) -> CGFloat {
        let maxDataValue = CGFloat(data.max(by: { $0[keyPath: fk] < $1[keyPath: fk] })?[keyPath: fk] ?? 1)
        let scale = geometry.size.height / maxDataValue
        return CGFloat(entry[keyPath: fk]) * scale
    }
    
    private func lineColor() -> Color {
        LineChart.color = LineChart.color.shuffled()
        if let lastColor = LineChart.color.popLast() {
            return lastColor
        } else {
            return .blue
        }
    }
    
}
