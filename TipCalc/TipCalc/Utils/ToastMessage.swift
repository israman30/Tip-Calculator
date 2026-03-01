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
        Text(message ?? "Amount added!")
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .foregroundStyle(Color(.label))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ToastMessage()
}
