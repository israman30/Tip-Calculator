//
//  ToastMessage.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/2/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import SwiftUI

struct ToastMessage: View {
    var message: String?
    
    var body: some View {
        Text(message ?? "Hello, World!")
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray4))
            .foregroundStyle(Color(.label))
            .cornerRadius(10)
    }
}

#Preview {
    ToastMessage()
}
