//
//  BuyingForm.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 29.04.21.
//

import UIKit

class BuyingForm {
    
    var isNeedToShow: Bool {
        if StoreManager.isFullVersion {
            return false
        }
        if notes.count <= 10 {
            return false
        }
        return true
    }
    
    var storeManager = StoreManager()
    
    func showForm(inController: UIViewController) {
        if let fullVersionProduct = fullVersionProduct {
            let alertController = UIAlertController(title: fullVersionProduct.localizedTitle, message: fullVersionProduct.localizedDescription, preferredStyle: .alert)
            
            let actionBuy = UIAlertAction(title: "Buy for \(fullVersionProduct.price) \(fullVersionProduct.priceLocale.currencySymbol ?? "")", style: .default) { (alert) in
                self.storeManager.byFullVersion()
            }
            let actionRestore = UIAlertAction(title: "Restore", style: .default) { (alert) in
                self.storeManager.restoreFullVersion()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
    
            }
            alertController.addAction(actionBuy)
            alertController.addAction(actionRestore)
            alertController.addAction(actionCancel)
            
            inController.present(alertController, animated: true, completion: nil)
        }
    }
}
