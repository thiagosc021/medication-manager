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
        let request = NSFetchRequest<Medication>(entityName: Strings.medicationEntityType)
        request.predicate = NSPredicate(value: true)
        return request
    }()
    private var takenMeds: [Medication] = []
    private var notTakenMeds: [Medication] = []
    private var notificationScheduler = NotificationScheduler.shared
    
    var sections: [[Medication]]  { [takenMeds,notTakenMeds] }
    var sectionHeaders: [String] = ["Taken","Not Taken"]
    
    func create(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        CoreDataStack.saveContext()
        notificationScheduler.scheduleNotifications(for: medication)
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
        notificationScheduler.cancelNotifications(for: medication)
        notificationScheduler.scheduleNotifications(for: medication)
    }
    
    func markAsTaken(medication: Medication, wasTaken: Bool) {
        guard wasTaken else {
            deleteTakenDate(medication: medication)
            return
        }
        
        TakenDate(date: Date(), medication: medication)
        CoreDataStack.saveContext()
    }
    
    func markAsTaken(with id: String) {
        guard let medication = notTakenMeds.first(where: { $0.id == UUID(uuidString: id) }) else {
            return
        }
        markAsTaken(medication: medication, wasTaken: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.notificationMarkTakenActionIdentifier), object: self, userInfo: [Strings.medicationEntityIDKey: "\(id)"])
    }
    
    func delete(medication: Medication) {
        deleteFromTaken(medication)
        deleteFromNotTaken(medication)
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
        notificationScheduler.cancelNotifications(for: medication)
    }
    
    
}

private extension MedicationController {
    
    func deleteFromTaken(_ medication: Medication) {
        guard let index = takenMeds.firstIndex(of: medication) else {
            return
        }
        takenMeds.remove(at: index)
    }
    
    func deleteFromNotTaken(_ medication: Medication) {
        guard let index = notTakenMeds.firstIndex(of: medication) else {
            return
        }
        notTakenMeds.remove(at: index)
    }
    
    func deleteTakenDate(medication: Medication) {
        let takenDateSet = medication.mutableSetValue(forKey: Strings.takenDatesEntityType)
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
