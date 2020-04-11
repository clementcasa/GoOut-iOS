//
//  SettingsPresenter.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import Foundation

protocol SettingsView {
    func configureUI(
        firstName: String?,
        lastName: String?,
        dateOfBirth: String?,
        placeOfBirth: String?,
        address: String?,
        city: String?,
        zipcode: String?
    )
    func onHideCloseButton()
    func onInfosSaved()
}

protocol SettingsPresenter {
    func attach(view: SettingsView)
    func setup()
    
    func saveInfos(
        firstName: String?,
        lastName: String?,
        dateOfBirth: String?,
        placeOfBirth: String?,
        address: String?,
        city: String?,
        zipcode: String?
    )
}

class SettingsPresenterImpl: SettingsPresenter {
    
    var view: SettingsView?
    
    let preferenceRepository: PreferenceRepository
    
    init(preferenceRepository: PreferenceRepository) {
        self.preferenceRepository = preferenceRepository
    }
    
    func attach(view: SettingsView) {
        self.view = view
    }
    
    func setup() {
        if !preferenceRepository.isUserConnected() {
            view?.onHideCloseButton()
        } else {
            view?.configureUI(
                firstName: preferenceRepository.getFirstName(),
                lastName: preferenceRepository.getLastName(),
                dateOfBirth: preferenceRepository.getBirthDate(),
                placeOfBirth: preferenceRepository.getBirthPlace(),
                address: preferenceRepository.getAddress(),
                city: preferenceRepository.getCity(),
                zipcode: preferenceRepository.getZipcode()
            )
        }
    }
    
    func saveInfos(firstName: String?,
                   lastName: String?,
                   dateOfBirth: String?,
                   placeOfBirth: String?,
                   address: String?,
                   city: String?,
                   zipcode: String?) {
        guard let firstName = firstName, !firstName.isEmpty,
            let lastName = lastName, !lastName.isEmpty,
            let dateOfBirth = dateOfBirth, !dateOfBirth.isEmpty,
            let placeOfBirth = placeOfBirth, !placeOfBirth.isEmpty,
            let address = address, !address.isEmpty,
            let city = city, !city.isEmpty,
            let zipcode = zipcode, !zipcode.isEmpty else { return }
        preferenceRepository.setFirstName(firstName: firstName)
        preferenceRepository.setLastName(lastName: lastName)
        preferenceRepository.setBirthDate(birthDate: dateOfBirth)
        preferenceRepository.setBirthPlace(birthPlace: placeOfBirth)
        preferenceRepository.setAddress(address: address)
        preferenceRepository.setCity(city: city)
        preferenceRepository.setZipcode(zipcode: zipcode)
        view?.onInfosSaved()
    }
}
