//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!
    
    
    
    func configure(with medication: Medication) {
        nameLabel.text = medication.name
        timeLabel.text = medication.timeOfDay?.formatted(date: .omitted, time: .shortened)
    }
   
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
    }
    
}
