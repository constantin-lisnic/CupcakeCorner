//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Constantin Lisnic on 08/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper(
                        "Number of cakes: \(order.quantity)",
                        value: $order.quantity, in: 3...20)
                }

                Section {
                    Toggle(
                        "Any special requests?", isOn: $order.specialRequests)

                    if order.specialRequests {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add sprinkles", isOn: $order.addSprinkles)
                    }
                }

                Section {
                    NavigationLink("Delivery address") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
