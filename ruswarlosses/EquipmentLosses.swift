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
    @State private var selectedChartType: ChartType = .line
    @State private var chartsVisible: [String: Bool] = Dictionary(uniqueKeysWithValues: EquipmentKeys.map {($0.key, false)})
    
    private static var color: [Color] = [.blue, .cyan, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal, .yellow, .gray].shuffled()
    
    private let chartColor: [String: Color] = Dictionary(uniqueKeysWithValues: EquipmentKeys.map {($0.key, color.popLast() ?? .blue)})
    
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
            .pickerStyle(SegmentedPickerStyle()).padding()
            
//            Button("Fetch Data") {
//                fetchData()
//            }
//            .padding()
            
            if isFetchingData {
                ProgressView("Fetching Data...")
            } else if !statisticsData.isEmpty {
                
//                let listOfTuples = statisticsData.map { myStruct in
//                    return (myStruct.name, myStruct.age)
//                }
//                for (key, value) in EquipmentKeys {
//
//                }
                
                if selectedChartType == .bar {
                    BarChart(data: statisticsData)
                        .frame(height: 300)
                        .padding()
                } else if selectedChartType == .line {
                    HStack {
                        // Toggles
                        VStack(alignment: .leading) {
                            ForEach(Array(EquipmentKeys), id: \.key) { (key, value) in
                                Toggle(value.name, isOn: binding(for: key)).padding(.leading)
                                    .toggleStyle(.automatic)
                            }
                        }
                        
                        ZStack {
                            ForEach(Array(EquipmentKeys), id: \.key) { (key, value) in
                                if chartsVisible[key]! {
                                    LineChart(chart: ChartData(
                                        title: value.name,
                                        points: statisticsData.map {eq in eq[keyPath: value.keyPath] as! Int},
                                        values: nil,
                                        color: chartColor[key]! // TODO: fix colors
                                    ))
//                                    print(statisticsData.map {eq in eq[keyPath: value.keyPath] as! Int})
                                }
                            }
//                            LineChart(chart: ChartData(title: "Preview Chart", points: [1,2,3,4,5,3,2,1,0,3,5,7], values: ["a","b","c","d","e","f","g","k","l","m","n","o"], color: Color.blue))
                        }
                    }
                    HStack {
                        ForEach(Array(EquipmentKeys), id: \.key) { (key, value) in
                            if chartsVisible[key]! {
                                drawLegend(name: value.name, color: chartColor[key]!)
                            }
                        }
                    }
//                    ForEach(Array(EquipmentKeys), id: \.key) { (key, value) in
//                        if chartsVisible[key]! {
//                            Text("\(value.name) ")
//                            List(statisticsData.map {eq in eq[keyPath: value.keyPath] as! Int}, id: \.self) { num in
//                                Text("\(num)")
//                            }
//                        }
//                    }
                }
            }
        }
        .padding()
//        .frame(minWidth: 500)
//        .background(.blue)
        .onAppear(perform: {
            fetchData()
        })
    }
    
    private func drawLegend(name: String, color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 20, height: 20)
                .foregroundColor(color)
            Text(name)
        }
//        .padding(.trailing)
    }
    
    // TODO: Probably better use struct
    private func binding(for key: String) -> Binding<Bool> {
        return Binding(
            get: { self.chartsVisible[key] ?? false },
            set: { self.chartsVisible[key] = $0 }
        )
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
