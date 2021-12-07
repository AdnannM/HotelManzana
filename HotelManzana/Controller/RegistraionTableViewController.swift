//
//  RegistraionTableViewController.swift
//  HotelManzana
//
//  Created by Adnann Muratovic on 06.12.21.
//

import UIKit

class RegistraionTableViewController: UITableViewController {
    
    var registraion: [Registration] = []
    
    var dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedRegistration = Registration.loadRegistration() {
            registraion = savedRegistration
        }
    }
}

// MARK: - Table view data source
extension RegistraionTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registraion.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        
        let registraion = registraion[indexPath.row]
        
        cell.textLabel?.text = registraion.firstname + " " + registraion.lastname
        cell.detailTextLabel?.text = dateFormatter.string(from: registraion.checkInDate) + " - " + dateFormatter.string(from: registraion.checkOutDate) + "  :   " + registraion.roomType.name
        
        return cell
    }
    
    @IBAction func unwindFromAddRegistration(_ segue: UIStoryboardSegue) {
        guard let addRegistraionTableVC = segue.source as? AddRegistrationTableViewController,
              let registration = addRegistraionTableVC.registration else { return }
     
        registraion.append(registration)
        tableView.reloadData()
        
        Registration.saveRegistration(registraion)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registraion.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Registration.saveRegistration(registraion)
        }
    }
    
    /// TODO:
    ///        Show Registration and editi Registration
    ///        Hidde Done Button - All textFiled must be filled
    ///        Add one more section for charges
    ///
}
