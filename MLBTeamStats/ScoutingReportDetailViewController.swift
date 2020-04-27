//
//  ScoutingReportDetailViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/27/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit

class ScoutingReportDetailViewController: UIViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var scoutingReportField: UITextField!
    @IBOutlet weak var scoutingReportView: UITextView!
    
    var scoutingItem: String?
    var scoutingReportItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scoutingItem = scoutingItem {
            scoutingReportField.text = scoutingItem
        }
        if let scoutingReportItem = scoutingReportItem {
            scoutingReportView.text = scoutingReportItem
        }
        enableDisableSaveButton()
        scoutingReportField.becomeFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave"{
            scoutingItem = scoutingReportField.text
            scoutingReportItem = scoutingReportView.text
        }
    }
    func enableDisableSaveButton() {
        if let scoutingFieldCount = scoutingReportField.text?.count, scoutingFieldCount > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    @IBAction func scoutingFieldChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
                if isPresentingInAddMode {
                    dismiss(animated: true, completion: nil)
                } else {
                    navigationController?.popViewController(animated: true)
                }
    }
}
