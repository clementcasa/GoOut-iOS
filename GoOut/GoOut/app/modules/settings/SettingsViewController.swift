//
//  SettingsViewController.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var placeOfBirthTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    let presenter: SettingsPresenter =
        SettingsPresenterImpl(
            preferenceRepository: PreferenceRepository(with: UserDefaults.standard)
        )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        presenter.setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        saveButton.layer.cornerRadius = 10
    }
    
    @IBAction func didTapOnClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnSave(_ sender: UIButton) {
        presenter.saveInfos(
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text,
            dateOfBirth: dateOfBirthTextField.text,
            placeOfBirth: placeOfBirthTextField.text,
            address: addressTextField.text,
            city: cityTextField.text, zipcode:
            zipcodeTextField.text
        )
    }
}

extension SettingsViewController: SettingsView {
    func configureUI(firstName: String?,
                     lastName: String?,
                     dateOfBirth: String?,
                     placeOfBirth: String?,
                     address: String?,
                     city: String?,
                     zipcode: String?) {
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        dateOfBirthTextField.text = dateOfBirth
        placeOfBirthTextField.text = placeOfBirth
        addressTextField.text = address
        cityTextField.text = city
        zipcodeTextField.text = zipcode
    }
    
    func onHideCloseButton() {
        closeButton.isEnabled = false
        closeButton.tintColor = UIColor.clear
    }
    
    func onInfosSaved() {
        dismiss(animated: true)
    }
}
