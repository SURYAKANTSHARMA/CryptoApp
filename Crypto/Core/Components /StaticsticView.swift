//
//  StaticsticView.swift
//  Crypto
//
//  Created by Surya on 08/10/23.
//

import SwiftUI

struct StaticsticView: View {
    let stat: StatisticModel
    
    var body: some View {
        
        VStack(alignment: .leading) {

            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(stat.value)
                .font(.title3)
                .bold()
                .foregroundColor(.theme.accent)
                HStack {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(stat.percentageChange ?? 0 >  0 ? Angle.zero : Angle(degrees: 180))
                    
                    Text(stat.percentageChange?.asPercentString() ?? "")
                        .font(.caption)
                }
                .foregroundColor(stat.percentageChange ?? 0  > 0 ? Color.theme.green : Color.theme.red)
                .opacity(stat.percentageChange?.asPercentString() == nil ? 0 : 1.0)
        }
    }
}

struct StaticsticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StaticsticView(stat: dev.stat1)
            StaticsticView(stat: dev.stat2)
            StaticsticView(stat: dev.stat3)
        }.preferredColorScheme(.dark)
    }
}
