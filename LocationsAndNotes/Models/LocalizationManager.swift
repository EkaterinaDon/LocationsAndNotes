//
//  LocalizationManager.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 29.04.21.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
