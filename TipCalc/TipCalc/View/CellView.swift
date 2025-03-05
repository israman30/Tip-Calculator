//
//  CellView.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/4/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import SwiftUI

struct CellView: View {
    var body: some View {
        HStack {
            Divider()
                .frame(width: 5)
                .overlay(.red)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("$97.00")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Text("Mar 4, 2025 at 1:100 PM")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        HStack {
                            Text("$89.00")
                                .font(.body)
                            Text("Initial bill")
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("-")
                        HStack {
                            Text("$8.90")
                                .font(.body)
                            Text("tip")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            Spacer()
        }
        .cornerRadius(5, antialiased: true)
        .background(Color(.systemGray6))
        .padding()
    }
}

#Preview {
    CellView()
        .frame(height: 150)
}
