//
//  MoodSurvey+convinience.swift
//  MedicationManager
//
//  Created by Thiago Costa on 5/3/22.
//

import Foundation
import CoreData

extension MoodSurvey {
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}
