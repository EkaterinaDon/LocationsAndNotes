//
//  PriceManager.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 29.04.21.
//

import UIKit
import StoreKit

let idFullVersion = ""
var fullVersionProduct: SKProduct?

class PriceManager: NSObject {

    func getPriceForProduct(idProduct: String) {
        if !SKPaymentQueue.canMakePayments() {
            debugPrint("You cant make purchases")
            return
        }
        let request = SKProductsRequest(productIdentifiers: [idProduct])
        request.delegate = self
        request.start()
    }
}

extension PriceManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.count != 0 {
            debugPrint("There are invalid products: \(response.invalidProductIdentifiers)")
        }
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
        }
    }
}
