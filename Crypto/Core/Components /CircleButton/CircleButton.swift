//
//  CircleButton.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

struct CircleButton: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .frame(width: 50, height: 50)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .background(alignment: .center) {
                Circle()
                    .foregroundColor(Color.theme.background)
            }
            .shadow(color: .theme.accent.opacity(0.25),
                    radius: 10,
                    x: 0,
                    y: 0)
            .padding()
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButton(iconName: "heart.fill")
    //            .padding()
                .previewLayout(.sizeThatFits)

            
            CircleButton(iconName: "heart.fill")
    //            .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
