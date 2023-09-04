//
//  LineChart.swift
//  ruswarlosses
//
//  Created by Vitaliy on 02.09.2023.
//

import SwiftUI

struct LineChart: View {
    /*
     Scheme:
     @title: String - chart title
     @Ytitle: String - Y axis title
     @Xtitle: String - X axis title
     @points: [Int] - Array of points of Y axis
     @values: [String]? - Array of values of X axis (optional)
     @color?: Color
     
     */
    
    @State var chart: ChartData
    
    var body: some View {
        drawLineChart(points: chart.points)
    }
    
    private func drawLineChart(points: [Int]) -> some View  {
        let maxVal = points.max() ?? 1
        return GeometryReader { geometry in
            Path { path in
                for (index, point) in points.enumerated() {
                    let x = geometry.size.width / CGFloat(points.count - 1) * CGFloat(index)
                    let y = geometry.size.height - self.getY(point: point, geometry: geometry, max: maxVal)
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        if y != 0.0 {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        else {
                            print("x:\(index) y: \(point)")
                        }
                    }
                }
            }
            .stroke(chart.color ?? .blue, lineWidth: 2)
        }
    }
    
    func getY(point: Int, geometry: GeometryProxy, max: Int) -> CGFloat {
//        let maxDataValue = CGFloat(data.max(by: { $0[keyPath: fk] < $1[keyPath: fk] })?[keyPath: fk] ?? 1)
        let maxDataValue = CGFloat(max)
        let scale = geometry.size.height / maxDataValue
        return CGFloat(point) * scale
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(chart: ChartData(title: "Preview Chart", points: [1,2,3,4,5,3,2,1,0,3,5,7], values: ["a","b","c","d","e","f","g","k","l","m","n","o"], color: Color.blue))
    }
}
