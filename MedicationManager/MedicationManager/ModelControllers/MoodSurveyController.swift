//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by Thiago Costa on 5/3/22.
//

import Foundation
import CoreData

class MoodSurveyController {
    static let shared = MoodSurveyController()
    private init() {}
    private var todaysMood: MoodSurvey?
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let afterPredicate = NSPredicate(format: "date > %@", startDate as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", endDate as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate,beforePredicate])
        return request
    }()
    
    let emojis:[String] = ["😀","😕","☹️"]
    
    func fetchTodaysMood() -> MoodSurvey? {
        guard let _ = todaysMood else {
            do {
                todaysMood = try CoreDataStack.context.fetch(fetchRequest).first
            } catch {
                return nil
            }
            return todaysMood
        }
        return todaysMood
    }
    
    func saveMood(mood: String) {
        guard let _ = todaysMood else {
            create(mentalState: mood)
            return
        }
        update(mood: mood)
    }
}

private extension MoodSurveyController {
    func create(mentalState: String, date: Date = Date()) {
        MoodSurvey(mentalState: mentalState, date: date)
        CoreDataStack.saveContext()
    }
    
    func update(mood: String) {
        guard let todaysMood = todaysMood else {
            return
        }
        todaysMood.mentalState = mood
        CoreDataStack.saveContext()
    }
}
