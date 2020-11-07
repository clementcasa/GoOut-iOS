//
//  ViewController.swift
//  GoOut
//
//  Created by Clément Casamayou on 10/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import UIKit
import UserNotifications
import PDFKit
import WebKit

protocol MainViewDelegate {
    func didCreateNewAttestation()
    func didDeleteAttestation()
}

class MainViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showAttestationButton: UIButton!
    @IBOutlet weak var emptyView: UIStackView!
    
    let presenter: MainPresenter =
        MainPresenterImpl(
            preferenceRepository: PreferenceRepository(with: UserDefaults.standard)
        )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.attach(view: self)
        presenter.setup()
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { _, _ in }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        showAttestationButton.layer.cornerRadius = 10
    }

    private func removeAllPendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    @IBAction func didTapOnShowAttestation(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: "CreateAttestationViewController") as? CreateAttestationViewController {
                vc.setDelegate(delegate: self)
                present(vc, animated: true)
        }
    }
    
    @IBAction func didTapOnDeleteAll(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete all attestations?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Delete forever",
                          style: .destructive,
                          handler: { (action) -> Void in
                            self.presenter.deleteAllAttestations()
                            self.removeAllPendingNotifications()
                          }
            )
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (a) -> Void in }))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfFiles()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AttestationTableViewCell")
            as? AttestationTableViewCell {
                cell.setData(title: presenter.getTitleOfFile(index: indexPath.row))
                cell.backgroundColor = UIColor.clear
                return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAttestation(index: indexPath.row)
    }
}

extension MainViewController: MainView {
    func onShowSettings() {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    func onShowAndUpdateList() {
        emptyView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func onShowEmptyList() {
        emptyView.isHidden = false
        tableView.isHidden = true
    }
    
    func onShowAttestationDetails(file: String) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailsAttestationViewController")
            as? DetailsAttestationViewController {
                vc.fileName = file
            vc.setDelegate(delegate: self)
                navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: MainViewDelegate {
    func didCreateNewAttestation() {
        presenter.refreshData()
    }
    
    func didDeleteAttestation() {
        presenter.refreshData()
    }
}

