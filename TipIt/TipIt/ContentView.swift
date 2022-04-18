//
//  ContentView.swift
//  TipIt
//
//  Created by Israel Manzo on 4/17/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var input = ""
    @State var selectedPercentage = "15%"
    var percentages = ["15%", "20%", "25%"]
    
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
                            Text(input.isEmpty ? "$0.0" : input)
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
                Picker("Pick value", selection: $selectedPercentage) {
                    ForEach(percentages, id:\.self) {
                        Text($0)
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
        let tipPercentage = [0.15, 0.20, 0.25]
        let bill = Double(input)
        guard let index = Int(selectedPercentage) else { return }
        
        if let bill = bill {
            let tip = bill * tipPercentage[index]
            let total = bill + tip
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
