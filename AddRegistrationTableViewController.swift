//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Adnann Muratovic on 04.12.21.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 2, section: 2)
    let chekOutDatePickerCellIndexPath = IndexPath(row: 2, section: 3)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    // Date Formatter
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let minToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = minToday
        checkInDatePicker.date = minToday
        
        updateDateView()
    }
    
    private func updateDateView() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    // MARK: - Action
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextFiled.text ?? ""
        let email = emailTextFiled.text ?? ""
        
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        
        print("Done Tapped")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("check-in Date: \(checkInDate)")
        print("check-out Date: \(checkOutDate)")
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
}
// MARK: -TableView
extension AddRegistrationTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            case checkInDatePickerCellIndexPath where
            isCheckInDatePickerVisible == false:
            return 0
            case chekOutDatePickerCellIndexPath where
            isCheckOutDatePickerVisible == false:
            return 0
            
        default:
            tableView.rowHeight = 33
            return UITableView.automaticDimension
        }
    }
}
