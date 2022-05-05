//
//  TakenDate+convinience.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/27/22.
//

import Foundation
import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
