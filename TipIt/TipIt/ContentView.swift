//
//  ContentView.swift
//  TipIt
//
//  Created by Israel Manzo on 4/17/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var input = ""
    @State var tipValue = ""
    @State var totalValue = ""
    @State var selectedPercentage = 0.15
    var percentages = [0.15, 0.20, 0.25]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter value..", text: $input)
                        .keyboardType(.decimalPad)
                        .onChange(of: input) { _ , newValue in
                            calculateTip(newValue)
                        }
                    
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.trailing)
                .font(.title)
                
                Divider()
                    .background(Color.secondary)
                
                VStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            Text("Tip")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Spacer()
                            Text(input.isEmpty ? "$0.0" : tipValue)
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
                            Text(input.isEmpty ? "$0.0" : totalValue)
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                        }
                    }
                }
                Picker("Pick value", selection: $selectedPercentage) {
                    ForEach(percentages, id:\.self) {
                        Text("\(Int($0 * 100))%")
                    }
                }
                .onChange(of: selectedPercentage, { _, newValue in
                    print("-->\(newValue)")
                })
                .pickerStyle(.segmented)
                Text("Percentage: \(selectedPercentage)")
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Tip It")
        }
    }
    
    func calculateTip(_ input: String) {
        let tipPercentage = [0.15, 0.20, 0.25]
        let bill = Double(input)
        guard Double(input) != nil else { return }
        
        if let bill = bill {
            let tip = bill * tipPercentage[Int(selectedPercentage)]
            let total = bill + tip
            tipValue = String(format: "$%.2f", tip)
            totalValue = String(format: "$%.2f", total)
        } else {
            totalValue = "$0.0"
            tipValue = "$0.0"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
