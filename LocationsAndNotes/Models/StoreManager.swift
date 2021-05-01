//
//  StoreManager.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 29.04.21.
//

import UIKit
import StoreKit

class StoreManager: NSObject {

    static var isFullVersion: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isFullVersion")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "isFullVersion")
        }
    }
    
    func byFullVersion() {
        if let fullVersionProduct = fullVersionProduct {
            let payment = SKPayment(product: fullVersionProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            if !SKPaymentQueue.canMakePayments() {
                debugPrint("You cant make purchases")
                return
            }
            let request = SKProductsRequest(productIdentifiers: [idFullVersion])
            request.delegate = self
            request.start()
        }
    }
    
    func restoreFullVersion() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKPaymentTransactionObserver

extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .deferred:
                fallthrough
            case .purchasing:
                fallthrough
            case .purchased:
                if transaction.payment.productIdentifier == idFullVersion {
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transaction)
                queue.remove(self)
            case .failed:
                debugPrint(transaction.error?.localizedDescription as Any)
                queue.finishTransaction(transaction)
                queue.remove(self)
            case .restored:
                if transaction.payment.productIdentifier == idFullVersion {
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transaction)
                queue.remove(self)
            @unknown default:
                debugPrint(transaction.error?.localizedDescription as Any)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
    }
}

// MARK: - SKProductRequestDelegate

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.count != 0 {
            debugPrint("There are invalid products: \(response.invalidProductIdentifiers)")
        }
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
            self.byFullVersion()
        }
    }
}
