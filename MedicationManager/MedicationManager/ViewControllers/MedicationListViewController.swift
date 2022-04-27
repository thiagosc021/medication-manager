//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import UIKit

class MedicationListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak private var tableView: UITableView!
    private let modelController = MedicationController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController.fetch()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modelController.fetch()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toMedicationDetails",
              let destinationVC = segue.destination as? MedicationDetailViewController,
              let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        destinationVC.model = modelController.medications[selectedIndexPath.row]
    }
}

extension MedicationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.medications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell") as? MedicationTableViewCell else {
            return UITableViewCell()
        }
        
        let medication = modelController.medications[indexPath.row]
        
        cell.configure(with: medication)
        
        return cell
    }
    
    
}
