//
//  CreateAttestationPresenter.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import Foundation

protocol CreateAttestationView {
    func onShowLoading()
    func onHideWebView()
    func onCreateFile(jsCode: String)
}

protocol CreateAttestationPresenter {
    func attach(view: CreateAttestationView)
    
    func getCodeToFillForm() -> String
    func setGroceriesCheckBox(checked: Bool) -> String
    func setWalkCheckBox(checked: Bool) -> String
    func setDoctorCheckBox(checked: Bool) -> String
    func didClickOnCreate()
    
    func getFileName() -> String
}

class CreateAttestationPresenterImpl: CreateAttestationPresenter {
    
    var view: CreateAttestationView?
    
    let preferenceRepository: PreferenceRepository
    
    init(preferenceRepository: PreferenceRepository) {
        self.preferenceRepository = preferenceRepository
    }
    
    func attach(view: CreateAttestationView) {
        self.view = view
    }
    
    func getCodeToFillForm() -> String {
        buildJavaScriptFiller()
    }
    
    func setGroceriesCheckBox(checked: Bool) -> String {
        getFillFormWithCheckedGroceries(checked: checked)
    }
    
    func setWalkCheckBox(checked: Bool) -> String {
        getFillFormWithCheckedWalk(checked: checked)
    }
    
    func setDoctorCheckBox(checked: Bool) -> String {
        getFillFormWithCheckedDoctor(checked: checked)
    }
    
    func didClickOnCreate() {
        view?.onShowLoading()
        view?.onHideWebView()
        view?.onCreateFile(jsCode: getShowSubmitButton() + performClick())
    }
    
    func getFileName() -> String {
        getDateFormatted()
    }
    
    private func buildJavaScriptFiller() -> String {
        getFillFormWithFirstName() + getFillFormWithLastName() + getFillFormWithBirthDate() + getFillFormWithPlaceOfBirth() + getFillFormWithAddress() + getFillFormWithCity() + getFillFormWithZipcode() + getFillFormWithCurrentTime() + getFillFormWithCheckedWalk(checked: true) + getHideSubmitButton()
    }
    
    private func getFillFormWithFirstName() -> String {
        "\(getElement(id: "field-firstname")).value = \"\(preferenceRepository.getFirstName())\"; "
    }
    
    private func getFillFormWithLastName() -> String {
        "\(getElement(id: "field-lastname")).value = \"\(preferenceRepository.getLastName())\"; "
    }

    private func getFillFormWithBirthDate() -> String {
        "\(getElement(id: "field-birthday")).value = \"\(preferenceRepository.getBirthDate())\"; "
    }
    
    private func getFillFormWithPlaceOfBirth() -> String {
        "\(getElement(id: "field-placeofbirth")).value = \"\(preferenceRepository.getBirthPlace())\"; "
    }
    
    private func getFillFormWithAddress() -> String {
        "\(getElement(id: "field-address")).value = \"\(preferenceRepository.getAddress())\"; "
    }
    
    private func getFillFormWithCity() -> String {
        "\(getElement(id: "field-city")).value = \"\(preferenceRepository.getCity())\"; "
    }
    
    private func getFillFormWithZipcode() -> String {
        "\(getElement(id: "field-zipcode")).value = \"\(preferenceRepository.getZipcode())\"; "
    }
    
    private func getFillFormWithCheckedGroceries(checked: Bool) -> String {
        "\(getElement(id: "checkbox-achats")).checked = \(checked); "
    }

    private func getFillFormWithCheckedWalk(checked: Bool) -> String {
        "\(getElement(id: "checkbox-sport_animaux")).checked = \(checked); "
    }

    private func getFillFormWithCheckedDoctor(checked: Bool) -> String {
        "\(getElement(id: "checkbox-sante")).checked = \(checked); "
    }

    private func getFillFormWithCurrentTime() -> String {
        "\(getElement(id: "field-heuresortie")).value = \"\(getCurrentTime())\"; "
    }
    
    private func getHideSubmitButton() -> String {
        "\(getElement(id: "generate-btn")).style.visibility = 'hidden'; "
    }
    
    private func getShowSubmitButton() -> String {
        "\(getElement(id: "generate-btn")).style.visibility = 'visible'; "
    }
    
    private func performClick() -> String {
        "\(getElement(id: "generate-btn")).click(); "
    }
    
    private func getElement(id: String) -> String {
        "document.getElementById(\"\(id)\")"
    }

    private func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.init(identifier: "fr")
        return dateFormatter.string(from: Date())
    }
    
    private func getDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        let localeFormatString = DateFormatter.dateFormat(
            fromTemplate: "MMMM d, h:mm",
            options: 0,
            locale: dateFormatter.locale
        )
        dateFormatter.dateFormat = localeFormatString
        return dateFormatter.string(from: Date())
    }
}
