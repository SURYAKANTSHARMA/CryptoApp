//
//  ChartView.swift
//  Crypto
//
//  Created by Surya on 01/01/24.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        maxY = self.data.max() ?? 0
        minY = self.data.min() ?? 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width/CGFloat(data.count) * CGFloat(index+1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat(data[index] - minY) / yAxis) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}
