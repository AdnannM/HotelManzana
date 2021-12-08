//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Adnann Muratovic on 04.12.21.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    
    var saveRegistration: [Registration] = []
    
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
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var numberOfNights: UILabel!
    @IBOutlet weak var dateOfNights: UILabel!
    
    @IBOutlet weak var roomTypePrice: UILabel!
    @IBOutlet weak var roomTypeName: UILabel!
    
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var wifiPriceLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    var selectedRegistration: Registration?
    
    init?(_ coder: NSCoder, registration: Registration?) {
        self.selectedRegistration = registration
        super.init(coder: coder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.string(from: date)
        return dateFormatter
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent user from selecting a date outside range
        let minToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = minToday
        checkInDatePicker.date = minToday
        
        editRegistrationView()
        updateDateView()
        updateNumberOfGuest()
        updateRoomType()
        disableDoneButton()
        
        updateNumberOfNights()
        updateNumberOfDatesLabel()
        
        updateRoomTypePrice()
        updateRoomTypeNameLabel()
        
        switchValueChanged(wifiSwitch)
        updateWifiPrice()
        
        updateTotalPriceLabel()
    }
    
    
    // MARK: - UpdateView
    private func updateDateView() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        updateNumberOfNights()
        updateNumberOfDatesLabel()
        updateRoomTypePrice()
    }
    
    private func disableDoneButton() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextFiled.text ?? ""
        let email = emailTextField.text ?? ""
        doneButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }
    
    private func updateNumberOfGuest() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    private func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            updateRoomTypePrice()
            updateRoomTypeNameLabel()
            updateTotalPriceLabel()
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    private func editRegistrationView() {
        if let selectedRegistration = selectedRegistration {
            firstNameTextField.text = selectedRegistration.firstname
            lastNameTextFiled.text = selectedRegistration.lastname
            emailTextField.text = selectedRegistration.email
            checkInDateLabel.text = "\(checkInDatePicker.date)"
            checkOutDateLabel.text = "\(checkOutDatePicker.date)"
            numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
            numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
            roomTypeLabel.text = "\(selectedRegistration.roomType.self)"
            print(selectedRegistration.roomType.name)
            wifiSwitch.isOn  = selectedRegistration.wifi
            
            title = "Edit Guest Registration"
            
        } else {
            title = "Add Guest Registration"
        }
    }
    
    private func updateNumberOfNights() {
        numberOfNights.text = "\(daysBetween(start: checkInDatePicker.date, end: checkOutDatePicker.date))"
        updateWifiPrice()
        updateTotalPriceLabel()
    }
    
    private func updateNumberOfDatesLabel() {
        dateOfNights.text = "\(checkInDateLabel.text ?? "Not set") : \(checkOutDateLabel.text ?? "Not Set")"
    }
    
    private func updateRoomTypePrice() {
        guard let room = roomType?.price else {
            return
        }
        
        let numberOfDays = Int(numberOfNights.text!)
        
        roomTypePrice.text = "$ \(pricePerDay(price: room, numerOfDays: numberOfDays!))"
        
        updateTotalPriceLabel()
        
    }
    
    private func updateRoomTypeNameLabel() {
        guard let room = roomType?.name,
              let price = roomType?.price
        else {
            return
        }
        roomTypeName.text = "\(room) @ $\(price) per night"
    }
    
    private func updateWifiPrice() {
        let wifiPrice = Int(numberOfNights.text!)
        wifiPriceLabel.text = "$ \(pricePerDay(price: wifiPrice!, numerOfDays: 10))"
        
    }
    
    private func updateTotalPriceLabel() {

        self.totalPriceLabel.text = "\(roomTypePrice.text!)"
    }
    
    //MARK: - daysBetween
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func pricePerDay(price: Int, numerOfDays: Int) -> Int {
        return price * numerOfDays
    }
    
        
    // MARK: - Action
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    @IBAction func stepperValueChanged(_ sender: Any) {
        updateNumberOfGuest()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if wifiSwitch.isOn {
            wifiLabel.text = "Yes"
            updateWifiPrice()
        } else {
            wifiLabel.text = "No"
            wifiPriceLabel.text = "$ \(0)"
        }
    }
    
    @IBSegueAction func selectedRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectedRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectedRoomTypeController?.delegate = self
        selectedRoomTypeController?.roomType = roomType
        Registration.saveRegistration(saveRegistration)
        return selectedRoomTypeController
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textDidEditChange(_ sender: UITextField) {
        disableDoneButton()
    }
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

