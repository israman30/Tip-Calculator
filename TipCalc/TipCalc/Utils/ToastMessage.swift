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
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
            Text(message ?? NSLocalizedString("Bill saved!", comment: "Toast when bill is saved"))
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGreen))
        )
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ToastMessage()
}
