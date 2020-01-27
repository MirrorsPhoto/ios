//
//  PieChartView.swift
//  ios
//
//  Created by Сергей Прищенко on 26.01.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    
    var data: Today
    
    var slices: [PieSlice] {
        var result: [PieSlice] = []
        var lastEndDeg: Double = 0
        let sum: Double = Double(data.sum())
        let childrens = Mirror(reflecting: self.data).children
        
        for (_, attr) in childrens.enumerated() {
            let value = attr.value as! Int
            let name = attr.label!
            if name == "total" || name == "printing" {
                continue
            }
            let percent: Double = sum != 0 ? Double(value) / Double(sum) : 1.0 / Double(childrens.count - 2) // Минус 2 потому, что исключаем total и printing
            
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (percent * 360)
            lastEndDeg = endDeg
            
            result.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: Int(value), percent: percent, name: name))
        }
        
        return result
    }
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                ZStack {
                    ForEach(self.slices, id: \.id) { slice in
                        PieChartCell(rect: geometry.frame(in: .local), pieSlice: slice)
                    }
                }
            }
            Spacer()
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(10)
                VStack {
                    ForEach(self.slices, id: \.id) { slice in
                        Text(NSLocalizedString(slice.name, comment: ""))
                            .padding(5)
                            .foregroundColor(slice.color)
                            .font(.body)
                    }
                }
                .padding()
            }
            
        }
    }
}

struct PieSlice: Identifiable {
    let id = UUID()
    let startDeg: Double
    let endDeg: Double
    let value: Int
    let percent: Double
    let name: String
    var color: Color {
        var red, green, blue: Double
        
        switch self.name {
            case "photo":
                red = 231
                green = 76
                blue = 60
            case "good":
                red = 241
                green = 196
                blue = 15
            case "copy":
                red = 46
                green = 204
                blue = 113
            case "service":
                red = 136
                green = 96
                blue = 208
            case "lamination":
                red = 52
                green = 152
                blue = 219
            default:
                red = 231
                green = 76
                blue = 60
        }
        
        return Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
}

struct PieChartCell: View {
    
    var rect: CGRect
    var radius: CGFloat {
        return min(rect.width, rect.height) / 2
    }
    var pieSlice: PieSlice
    
    public var body: some View {
        Path { path in
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: self.radius, startAngle: Angle(degrees: self.pieSlice.startDeg - 90), endAngle: Angle(degrees: self.pieSlice.endDeg - 90), clockwise: false)
            path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
            path.closeSubpath()
        }
        .fill(self.pieSlice.color)
    }
    
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PieChartView(data: Today(photo: 10, good: 0, copy: 5, lamination: 1, printing: 0, service: 1, total: 19)).frame(height: 200)
//            PieChartView(data: Today(photo: 0, good: 0, copy: 0, lamination: 0, printing: 0, service: 0, total: 0)).frame(height: 400)
        }
    }
}
