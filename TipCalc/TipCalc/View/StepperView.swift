//
//  StepperView.swift
//  TipCalc
//
//  Created by Israel Manzo on 2/16/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import SwiftUI

struct StepperView: View {
    @State var value: Int = 0
    var body: some View {
        HStack {
            Stepper {
                Text("Split bill")
            } onIncrement: {
                value += 1
            } onDecrement: {
                value -= 1
            }
        }
    }
}

#Preview {
    StepperView()
}
