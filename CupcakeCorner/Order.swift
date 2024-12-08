//
//  Order.swift
//  CupcakeCorner
//
//  Created by Constantin Lisnic on 08/12/2024.
//

import Foundation
import Observation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _quantity = "quantity"
        case _type = "type"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _zip = "zip"
        case _specialRequests = "specialRequests"
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequests = false {
        didSet {
            if !specialRequests {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false

    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""

    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty
        {
            return false
        }

        return true
    }

    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2

        // complicated cakes cost more
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
}
