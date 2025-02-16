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
                            if let amount = Double(newValue) {
                                let tipAmount = amount * percentages[Int(selectedPercentage)]
                                print(tipAmount)
                                let totalAmount = amount + tipAmount
                                self.tipValue = String(format: "%.2f", tipAmount)
                                self.totalValue = String(format: "%.2f", totalAmount)
                            }
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
                .pickerStyle(.segmented)
                Text("Percentage: \(selectedPercentage)")
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Tip It")
        }
    }
    
    func calculateTip() {
//        let tipPercentage = [0.15, 0.20, 0.25]
//        let bill = Double(input)
//        guard let index = Int(selectedPercentage) else { return }
//        
//        if let bill = bill {
//            let tip = bill * tipPercentage[index]
//            let total = bill + tip
//            tipValue = String(format: "$%.2f", tip)
//            totalValue = String(format: "$%.2f", total)
//        } else {
//            tipValue = "$0.0"
//            totalValue = "$0.0"
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
