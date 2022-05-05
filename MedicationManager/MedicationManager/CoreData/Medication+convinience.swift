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
    
    func wasTakenToday() -> Bool {
        guard let mutableTakenDates = self.mutableSetValue(forKey: "takenDates") as? Set<TakenDate>,
                  mutableTakenDates.contains(where: { guard let date = $0.date else { return false }
                  return Calendar.current.isDateInToday(date) }) else {
            return false
        }
        
        return true
    }
}
