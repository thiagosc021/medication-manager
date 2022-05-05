//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool)
}

class MedicationTableViewCell: UITableViewCell {
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var wasTakenButton: UIButton!
    private var medication: Medication?
    private var wasTakenToday: Bool = false
    
    weak var delegate: MedicationTableViewCellDelegate?
    
    func configure(with medication: Medication) {
        nameLabel.text = medication.name
        timeLabel.text = medication.timeOfDay?.formatted(date: .omitted, time: .shortened)
        wasTakenToday = medication.wasTakenToday()
        self.medication = medication
        
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
    }
   
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        guard let medication = medication else {
            return
        }
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday)
    }
}
