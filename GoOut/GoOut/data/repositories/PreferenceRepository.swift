//
//  PreferenceRepository.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import Foundation

class PreferenceRepository {
    private let userDefaults: UserDefaults

    init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func setFirstName(firstName: String) {
        userDefaults.set(firstName, forKey: keyFirstName)
    }

    func getFirstName() -> String {
        userDefaults.string(forKey: keyFirstName) ?? ""
    }
    
    func setLastName(lastName: String) {
        userDefaults.set(lastName, forKey: keyLastName)
    }

    func getLastName() -> String {
        userDefaults.string(forKey: keyLastName) ?? ""
    }
    
    func setBirthDate(birthDate: String) {
        userDefaults.set(birthDate, forKey: keyBirthDate)
    }

    func getBirthDate() -> String {
        userDefaults.string(forKey: keyBirthDate) ?? ""
    }
    
    func setBirthPlace(birthPlace: String) {
        userDefaults.set(birthPlace, forKey: keyBirthPlace)
    }

    func getBirthPlace() -> String {
        userDefaults.string(forKey: keyBirthPlace) ?? ""
    }
    
    func setAddress(address: String) {
        userDefaults.set(address, forKey: keyAddress)
    }

    func getAddress() -> String {
        userDefaults.string(forKey: keyAddress) ?? ""
    }
    
    func setCity(city: String) {
        userDefaults.set(city, forKey: keyCity)
    }

    func getCity() -> String {
        userDefaults.string(forKey: keyCity) ?? ""
    }
    
    func setZipcode(zipcode: String) {
        userDefaults.set(zipcode, forKey: keyZipcode)
    }

    func getZipcode() -> String {
        userDefaults.string(forKey: keyZipcode) ?? ""
    }
    
    func isUserConnected() -> Bool {
        !(userDefaults.string(forKey: keyFirstName)?.isEmpty ?? true)
    }
}

private let keyFirstName = "keyFirstName"
private let keyLastName = "keyLastName"
private let keyBirthDate = "keyBirthDate"
private let keyBirthPlace = "keyBirthPlace"
private let keyAddress = "keyAddress"
private let keyCity = "keyCity"
private let keyZipcode = "keyZipcode"
