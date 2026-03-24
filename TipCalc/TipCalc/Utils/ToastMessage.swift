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
    @State private var checkmarkScale: CGFloat = 0.5

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: Constant.Icon.checkmark_circle_fill)
                .font(.title2)
                .foregroundStyle(.white)
                .scaleEffect(checkmarkScale)
                .onAppear {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        checkmarkScale = 1.0
                    }
                }
            Text(message ?? LocalizedString.toastMessage)
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
