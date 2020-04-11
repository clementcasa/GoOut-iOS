//
//  DetailsAttestationPresenter.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import Foundation

protocol DetailsAttestationView {
    func onFileDeleted()
}

protocol DetailsAttestationPresenter {
    func attach(view: DetailsAttestationView)
    func deleteFile(filePath: String?)
}

class DetailsAttesationPresenterImpl: DetailsAttestationPresenter {
    var view: DetailsAttestationView?
    
    func attach(view: DetailsAttestationView) {
        self.view = view
    }
    
    func deleteFile(filePath: String?) {
        if let filePath = filePath {
            try? FileManager.default.removeItem(atPath: filePath)
            view?.onFileDeleted()
        }
    }
}
