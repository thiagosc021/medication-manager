//
//  SurveyViewController.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/28/22.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: AnyObject {
    func moodButtonTapped(with emoji: String)
}

class MoodSurveyViewController: UIViewController {
    
    weak var delegate: MoodSurveyViewControllerDelegate?
  
    @IBOutlet weak var mentalStateHappy: UIButton!
    @IBOutlet weak var mentalStateNotSoHappy: UIButton!
    @IBOutlet weak var mentalStateSad: UIButton!
    
    var model = MoodSurveyController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mentalStateHappy.setTitle(model.emojis[0], for: .normal)
        mentalStateHappy.titleLabel?.font = .systemFont(ofSize: 50)
        mentalStateNotSoHappy.setTitle(model.emojis[1], for: .normal)
        mentalStateNotSoHappy.titleLabel?.font = .systemFont(ofSize: 50)
        mentalStateSad.setTitle(model.emojis[2], for: .normal)
        mentalStateSad.titleLabel?.font = .systemFont(ofSize: 50)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        let emoji = model.emojis[sender.tag]
        delegate?.moodButtonTapped(with: emoji)
        model.saveMood(mood: emoji)
        dismiss(animated: true)
    }   
}
