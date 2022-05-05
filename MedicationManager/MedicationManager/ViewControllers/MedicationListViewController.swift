//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import UIKit

class MedicationListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var mentalStateButton: UIButton!
    @IBOutlet weak private var tableView: UITableView!
    private let medicationModelController = MedicationController.shared
    private let moodSurveyModelController = MoodSurveyController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicationModelController.fetch()
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let todaysMood = moodSurveyModelController.fetchTodaysMood() else {
            return
        }        
        mentalStateButton.setTitle(todaysMood.mentalState, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        medicationModelController.fetch()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toMedicationDetails",
              let destinationVC = segue.destination as? MedicationDetailViewController,
              let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        destinationVC.model = medicationModelController.sections[selectedIndexPath.section][selectedIndexPath.row]
    }
    
    @IBAction func surveyButtonTapped(_ sender: UIButton) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moodSurveyViewController") as? MoodSurveyViewController else {
            return
        }
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true)
    }
    
}

extension MedicationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return medicationModelController.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationModelController.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell") as? MedicationTableViewCell else {
            return UITableViewCell()
        }
        
        let medication = medicationModelController.sections[indexPath.section][indexPath.row]
        
        cell.configure(with: medication)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return medicationModelController.sections[section].count > 0 ? medicationModelController.sectionHeaders[section] : nil
    }
}

extension MedicationListViewController: MedicationTableViewCellDelegate {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool) {
        medicationModelController.markAsTaken(medication: medication, wasTaken: wasTaken)
        medicationModelController.fetch()
        tableView.reloadData()
    }
    
}

extension MedicationListViewController: MoodSurveyViewControllerDelegate {
    func moodButtonTapped(with emoji: String) {
        mentalStateButton.setTitle(emoji, for: .normal)
    }
    
    
}
