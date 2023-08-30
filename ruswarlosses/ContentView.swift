//
//  ContentView.swift
//  ruswarlosses
//
//  Created by Vitaliy on 24.08.2023.
//

import SwiftUI

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


struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var subMenuItems: [MenuItem]?
}


struct SplitViewContent: View {
    @State private var fullScreen = false

    var body: some View {
        NavigationView {
//            VStack {
//                Text("Fisrt")
//                Text("Second")
//                Button("Toggle Full Screen") {
//                    self.fullScreen.toggle()
//                }
//                .navigationTitle("Full Screen")
//            }
            NavigationLink(destination: ContentView()) {
                Text("Hello, World!")
            }
            .navigationTitle("Navigation")
//            .navigationBarHidden(fullScreen)
        }
        .background(.ultraThinMaterial)
//        .statusBar(hidden: fullScreen)
    }
}


struct MySidebar: View {
    var body: some View {
        VStack {
            Text("Fisrt")
            Text("Second")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        SplitViewContent()
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
            
            if let _data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([StatisticsData].self, from: _data)
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

