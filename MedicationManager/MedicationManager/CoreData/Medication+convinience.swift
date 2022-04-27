//
//  Medication+convinience.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/26/22.
//

import CoreData

extension Medication {
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
    }
}
