//
//  SelectRoomTypeTableViewController.swift
//  HotelManzana
//
//  Created by Adnann Muratovic on 06.12.21.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate {
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, select roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    
    var roomType: RoomType?
    
    var delegate: SelectRoomTypeTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Room Type"
        
        tableView.rowHeight = 55
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

// MARK: - TableView
extension SelectRoomTypeTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RoomType.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        
        let roomType = RoomType.all[indexPath.row]
        
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = roomType.name
        cell.detailTextLabel?.text = "$ \(roomType.price)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = RoomType.all[indexPath.row]
        delegate?.selectRoomTypeTableViewController(self, select: roomType!)
        tableView.reloadData()
    }
}
