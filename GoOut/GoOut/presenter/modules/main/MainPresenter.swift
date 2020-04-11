//
//  MainPresenter.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import Foundation

protocol MainView {
    func onShowSettings()
    
    func onShowAndUpdateList()
    func onShowEmptyList()
    
    func onShowAttestationDetails(file: String)
}

protocol MainPresenter {
    func attach(view: MainView)
    func setup()
    func refreshData()
    
    func getNumberOfFiles() -> Int
    func getTitleOfFile(index: Int) -> String
    func didSelectAttestation(index: Int)
    
    func deleteAllAttestations()
}

class MainPresenterImpl: MainPresenter {
    
    var view: MainView?
    
    var attestations: [String] = []
    
    let preferenceRepository: PreferenceRepository
    
    init(preferenceRepository: PreferenceRepository) {
        self.preferenceRepository = preferenceRepository
    }
    
    func attach(view: MainView) {
        self.view = view
    }
    
    func setup() {
        if !preferenceRepository.isUserConnected() {
            view?.onShowSettings()
        } else {
            refreshData()
        }
    }
    
    func refreshData() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0].absoluteString.replacingOccurrences(of: "file://", with: "")
        attestations = contentsOfDirectoryAtPath(path: String(docDirectoryPath)) ?? []
        if attestations.count > 0 {
            view?.onShowAndUpdateList()
        } else {
            view?.onShowEmptyList()
        }
    }
    
    func getNumberOfFiles() -> Int {
        attestations.count
    }
    
    func getTitleOfFile(index: Int) -> String {
        attestations[index]
            .components(separatedBy: "/")
            .last?
            .replacingOccurrences(of: ".pdf", with: "") ?? ""
    }
    
    func didSelectAttestation(index: Int) {
        view?.onShowAttestationDetails(file: attestations[index])
    }
    
    func deleteAllAttestations() {
        guard attestations.count > 0 else { return }
        attestations.forEach { fileName in
            try? FileManager.default.removeItem(atPath: fileName)
        }
        refreshData()
    }
    
    private func contentsOfDirectoryAtPath(path: String) -> [String]? {
        guard let paths = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
        return paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
}
