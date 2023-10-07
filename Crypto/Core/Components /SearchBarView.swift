//
//  SearchBarView.swift
//  Crypto
//
//  Created by Surya on 23/09/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText : .theme.accent
                )
            
            TextField("Search by name or symbols",
                      text: $searchText)
            .foregroundColor(.theme.accent)
            .autocorrectionDisabled(true)
            .overlay(
              Image(systemName: "xmark.circle.fill")
                .padding()
                .offset(x: 10)
                .foregroundColor(Color.theme.accent)
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    searchText = ""
                    UIApplication.shared.endEditing()
                }
              ,
              alignment: .trailing
            )
        }
        .font(.headline)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.2),
                        radius: 10, x: 0, y: 0)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                
            SearchBarView(searchText:  .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)

        }
       
    }
}
