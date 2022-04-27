//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    private init() {}
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    
    var medications = [Medication]()
    
    func create(name: String, timeOfDay: Date) {
        Medication(name: name, timeOfDay: timeOfDay)
        CoreDataStack.saveContext()
    }
    
    func fetch() {
        medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []        
    }
    
    func update(medication: Medication, with name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func delete() {
        
    }
    
}
