//
//  ScoutingReportViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/27/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit

class ScoutingReportViewController: UIViewController {

    @IBOutlet weak var scoutingReportTable: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    var scoutingReports = [String]()
    var scoutingNotesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoutingReportTable.delegate = self
        scoutingReportTable.dataSource = self
        
        scoutingReports = defaultsData.stringArray(forKey: "scoutingReports") ?? [String]()
        scoutingNotesArray = defaultsData.stringArray(forKey: "scoutingNotesArray") ?? [String]()
    }
    
    func saveDefaultsData(){
        defaultsData.set(scoutingReports, forKey: "scoutingReports")
        defaultsData.set(scoutingNotesArray, forKey: "scoutingNotesArray")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let destination = segue.destination as! ScoutingReportDetailViewController
            let index = scoutingReportTable.indexPathForSelectedRow!.row
            destination.scoutingItem = scoutingReports[index]
            destination.scoutingReportItem = scoutingNotesArray[index]
        } else {
            if let selectedPath = scoutingReportTable.indexPathForSelectedRow{
                scoutingReportTable.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromScoutingReportDetailViewController(segue:UIStoryboardSegue){
        let sourceViewController = segue.source as! ScoutingReportDetailViewController
        if let indexPath = scoutingReportTable.indexPathForSelectedRow {
            scoutingReports[indexPath.row] = sourceViewController.scoutingItem!
            scoutingNotesArray[indexPath.row] = sourceViewController.scoutingReportItem!
            scoutingReportTable.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: scoutingReports.count, section: 0)
            scoutingReports.append(sourceViewController.scoutingItem!)
            scoutingNotesArray.append(sourceViewController.scoutingReportItem!)
            scoutingReportTable.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveDefaultsData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if scoutingReportTable.isEditing {
            scoutingReportTable.setEditing(false, animated: true)
            addBarButton.isEnabled = true
            editBarButton.title = "Edit"
        } else {
            scoutingReportTable.setEditing(true, animated: true)
            addBarButton.isEnabled = false
            editBarButton.title = "Done"
        }
    }
}

extension ScoutingReportViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoutingReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoutingReportTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(scoutingReports[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            scoutingReports.remove(at: indexPath.row)
            scoutingNotesArray.remove(at: indexPath.row)
            scoutingReportTable.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = scoutingReports[sourceIndexPath.row]
        let reportToMove = scoutingNotesArray[sourceIndexPath.row]
        scoutingReports.remove(at: sourceIndexPath.row)
        scoutingNotesArray.remove(at: sourceIndexPath.row)
        scoutingReports.insert(itemToMove, at: destinationIndexPath.row)
        scoutingNotesArray.insert(reportToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
    
}
