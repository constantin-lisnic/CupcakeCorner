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

    var name = UserDefaults.standard.string(forKey: "name") ?? "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    var streetAddress =
        UserDefaults.standard.string(forKey: "streetAddress") ?? ""
    {
        didSet {
            UserDefaults.standard.set(streetAddress, forKey: "streetAddress")
        }
    }
    var city = UserDefaults.standard.string(forKey: "city") ?? "" {
        didSet {
            UserDefaults.standard.set(city, forKey: "city")
        }
    }
    var zip = UserDefaults.standard.string(forKey: "zip") ?? "" {
        didSet {
            UserDefaults.standard.set(zip, forKey: "zip")
        }
    }

    var hasValidAddress: Bool {
        if isValidField(name) && isValidField(streetAddress)
            && isValidField(city) && isValidField(zip)
        {
            return true
        }

        return false
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

func isValidField(_ string: String) -> Bool {
    if string.trimmingCharacters(in: .whitespaces).isEmpty {
        return false
    }

    return true
}
