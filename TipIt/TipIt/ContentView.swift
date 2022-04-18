//
//  ContentView.swift
//  TipIt
//
//  Created by Israel Manzo on 4/17/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var input = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter value..", text: $input)
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.trailing)
                .font(.title)
                
                VStack {}.frame(width: UIScreen.main.bounds.size.width - 100, height: 5).background(Color.secondary)
                
                VStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            Text("Tip")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Spacer()
                            Text("$0.0")
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                        }
                    }
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            Text("Total")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Spacer()
                            Text("$0.0")
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Tip It")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
