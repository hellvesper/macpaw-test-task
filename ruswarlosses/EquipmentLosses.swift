//
//  EquipmentLosses.swift
//  ruswarlosses
//
//  Created by Vitaliy on 01.09.2023.
//

import SwiftUI

struct EquipmentLosses: View {
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
                    LineChart(data: statisticsData, fieldKeys: [\StatisticsData.tank, \StatisticsData.APC, \StatisticsData.field_artillery])
                        .frame(height: 300)
                        .padding()
                }
            }
        }
    }
    
    private func fetchData()  {
        let url = URL(string: "https://raw.githubusercontent.com/MacPaw/2022-Ukraine-Russia-War-Dataset/main/data/russia_losses_equipment.json")!
        
        isFetchingData = true
        
        Task {
            do {
                statisticsData = try await URLSession.shared.decode([StatisticsData].self, from: url)
                isFetchingData = false
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}



struct EquipmentLosses_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentLosses()
    }
}
