//
//  XMarkButton.swift
//  Crypto
//
//  Created by Surya on 15/10/23.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
         dismiss()
     },label: {
         Image(systemName: "xmark")
     })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
