//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Constantin Lisnic on 08/12/2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showApiRequestFail = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    AsyncImage(
                        url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                        scale: 3
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .accessibilityHidden(true)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 233)
                    .accessibilityHidden(true)

                    Text(
                        "Your total cost is \(order.cost, format: .currency(code: "USD"))"
                    )
                    .font(.title)

                    Button("Place order") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .alert("Thank you!", isPresented: $showingConfirmation) {
                Button("OK") {}
            } message: {
                Text(confirmationMessage)
            }
            .alert("Something went wrong!", isPresented: $showApiRequestFail) {
                Button("OK") {}
            } message: {
                Text("Your request to place the order failed. Try again later.")
            }
        }
    }

    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(
                for: request, from: encoded)

            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)

            confirmationMessage =
                "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way"

            showingConfirmation = true
        } catch {
            showApiRequestFail = true
            print("Checkout failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
