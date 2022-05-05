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
    private var takenMeds: [Medication] = []
    private var notTakenMeds: [Medication] = []
    
    var sections: [[Medication]]  { [takenMeds,notTakenMeds] }
    var sectionHeaders: [String] = ["Taken","Not Taken"]
    
    func create(name: String, timeOfDay: Date) {
        Medication(name: name, timeOfDay: timeOfDay)
        CoreDataStack.saveContext()
    }
    
    func fetch() {
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        
        takenMeds = medications.filter { $0.wasTakenToday()}
        notTakenMeds = medications.filter { !$0.wasTakenToday()}
    }
    
    func update(medication: Medication, with name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func markAsTaken(medication: Medication, wasTaken: Bool) {
        guard wasTaken else {
            deleteTakenDate(medication: medication)
            return
        }
        
        TakenDate(date: Date(), medication: medication)
        CoreDataStack.saveContext()
    }
    
    
    func delete() {
        
    }
}

private extension MedicationController {
    func deleteTakenDate(medication: Medication) {
        let takenDateSet = medication.mutableSetValue(forKey: "takenDates")
        guard let mutableTakenDates = takenDateSet as? Set<TakenDate>,
              let takenDate = mutableTakenDates.first(where: {
                  guard let date = $0.date else { return false }
                  return Calendar.current.isDateInToday(date) }) else {
            return
        }
        takenDateSet.remove(takenDate)
        CoreDataStack.saveContext()
    }
}
