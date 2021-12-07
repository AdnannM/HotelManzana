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
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    var registration: Registration? {
        guard let roomType = roomType else {
            return nil
        }
            
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextFiled.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChild = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstname: firstName,
                            lastname: lastName,
                            email: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChild,
                            wifi: hasWifi,
                            roomType: roomType)
        
    }
    
    var roomType: RoomType?
    
    let checkInDataPickerCellIndexPath = IndexPath(row: 1,
                                                   section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3,
                                                    section: 1)
    
    var isCheckInDatePickerIsVisible: Bool = false {
        didSet {
            checkInDateLabel.isHidden = !isCheckInDatePickerIsVisible
        }
    }
    
    var isCheckOutDatePickerIsVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerIsVisible
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
        
        // Prevent user from selecting a date outside range
        let minToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = minToday
        checkInDatePicker.date = minToday
        
//        
//        if let selectRegistration = selectedRegistration {
//            firstNameTextField.text = selectRegistration.firstname
//            lastNameTextFiled.text = selectRegistration.lastname
//            emailTextField.text = selectRegistration.email
//            checkInDateLabel.text = "\(selectRegistration.checkInDate)"
//            checkOutDateLabel.text = "\(selectRegistration.checkOutDate)"
//            numberOfAdultsLabel.text = "\(Int(selectRegistration.numberOfAdults))"
//            numberOfChildrenLabel.text = "\(Int(selectRegistration.numberOfChildren))"
//            roomTypeLabel.text = selectRegistration.roomType.name
//            
//            title = "Edit Guest Registration"
//        } else {
//            title = "Add Guest Registration"
//        }
        
        updateDateView()
        updateNumberOfGuest()
        updateRoomType()
    }
    
    
    // MARK: - UpdateView
    private func updateDateView() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    private func updateNumberOfGuest() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    private func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    // MARK: - Action
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    @IBAction func stepperValueChanged(_ sender: Any) {
        updateNumberOfGuest()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        // immplement latter
    }
    
    @IBSegueAction func selectedRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectedRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectedRoomTypeController?.delegate = self
        selectedRoomTypeController?.roomType = roomType
        
        return selectedRoomTypeController
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:  - Segue
}
// MARK: -TableView
extension AddRegistrationTableViewController {

    // MARK: - Hidde date picker
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath {
//            case checkInDataPickerCellIndexPath where
//            isCheckInDatePickerIsVisible == false:
//            return 0
//            case checkOutDatePickerCellIndexPath where
//            isCheckOutDatePickerIsVisible == false:
//            return 0
//        default:
//            return UITableView.automaticDimension
//        }
//    }

    override func tableView(_ tableView: UITableView,
       didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath == checkInDataPickerCellIndexPath &&
           isCheckOutDatePickerIsVisible == false {
            // check-in label selected, check-out picker is not
            //   visible, toggle check-in picker
            isCheckInDatePickerIsVisible.toggle()
        } else if indexPath == checkOutDatePickerCellIndexPath &&
                    isCheckOutDatePickerIsVisible == false {
            // check-out label selected, check-in picker is not
            //   visible, toggle check-out picker
            isCheckOutDatePickerIsVisible.toggle()
        } else if indexPath == checkInDataPickerCellIndexPath ||
           indexPath == checkOutDatePickerCellIndexPath {
            // either label was selected, previous conditions failed
            // meaning at least one picker is visible, toggle both
            isCheckInDatePickerIsVisible.toggle()
            isCheckOutDatePickerIsVisible.toggle()
        } else {
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerDelegate {
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, select roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
}


