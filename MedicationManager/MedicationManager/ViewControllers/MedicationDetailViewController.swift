//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let modelController = MedicationController.shared
    var model: Medication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Medication Details"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(Strings.medicationReminderReceived),
                                               object: nil)
        
        configureUI()                
    }
    
    private func configureUI() {
        guard let model = model else {
            return
        }
        self.title = model.name
        nameTextField.text = model.name
        datePicker.date = model.timeOfDay ?? Date()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
      
        guard let name = nameTextField.text,
              !name.isEmpty else {
            return
        }
        
        let timeOfDay = datePicker.date
        
        if let model = model {
            modelController.update(medication: model, with: name, timeOfDay: timeOfDay)
        } else {
            modelController.create(name: name, timeOfDay: timeOfDay)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func reminderFired() {
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemBlue
        }
    }
    
}
