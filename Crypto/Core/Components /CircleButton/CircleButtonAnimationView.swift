//
//  CircleButtonAnimation.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var isAnimating: Bool 
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(isAnimating ? 1.0 : 0)
            .opacity(isAnimating ? 0.0 : 1.0)
            .animation(isAnimating ? .easeOut(duration: 1): .none)
        
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(isAnimating: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100, alignment: .center)
    }
}
