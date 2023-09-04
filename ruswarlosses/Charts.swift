//
//  Charts.swift
//  ruswarlosses
//
//  Created by Vitaliy on 29.08.2023.
//

import SwiftUI

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


struct LineCharts: View {
    /*
     Scheme:
     @title: String - chart title
     @Ytitle: String - Y axis title
     @Xtitle: String - X axis title
     @points: [Int] - Array of points of Y axis
     @values: [String]? - Array of values of X axis (optional)
     @color?: Color
     
     */
    let data: [StatisticsData]
    let fieldKeys: [KeyPath<StatisticsData, Int>]
    
    private static var color: [Color] = [.blue, .cyan, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal, .yellow, .gray].shuffled()
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(fieldKeys, id: \.self) { keyPath in
                    drawLineChart(fk: keyPath)
                }
            }
            HStack {
                ForEach(fieldKeys, id: \.self) { keyPath in
//                    drawLegend(fk: keyPath)
                }
            }
            .padding(.top, 10)
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
            .stroke(lineColor(fieldKey: fk), lineWidth: 2)
        }
    }
    
    func getY(entry: StatisticsData, geometry: GeometryProxy, fk: KeyPath<StatisticsData, Int>) -> CGFloat {
        let maxDataValue = CGFloat(data.max(by: { $0[keyPath: fk] < $1[keyPath: fk] })?[keyPath: fk] ?? 1)
        let scale = geometry.size.height / maxDataValue
        return CGFloat(entry[keyPath: fk]) * scale
    }
    
    private func drawLegend(fk: KeyPath<StatisticsData, Int>) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 20, height: 20)
                .foregroundColor(lineColor(fieldKey: fk))
            Text(fk == \StatisticsData.tank ? "Tanks" :
                    fk == \StatisticsData.APC ? "APC" :
                    fk == \StatisticsData.field_artillery ? "Arty" :
                    fk == \StatisticsData.aircraft ? "Planes" : "")
        }
//        .padding(.trailing)
    }
    
    private func lineColor(fieldKey: KeyPath<StatisticsData, Int>) -> Color {
        let index = fieldKeys.firstIndex(of: fieldKey) ?? 0
        return LineCharts.color.indices.contains(index) ? LineCharts.color[index] : .blue
    }
    
}
