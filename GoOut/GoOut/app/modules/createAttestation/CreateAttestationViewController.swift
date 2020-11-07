//
//  MainViewController.swift
//  GoOut
//
//  Created by Clément Casamayou on 10/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import UIKit
import UserNotifications
import WebKit

class CreateAttestationViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var hideCheckBoxButton: UIButton!
    @IBOutlet weak var walkCheckbox: UISwitch!
    @IBOutlet weak var groceriesCheckbox: UISwitch!
    @IBOutlet weak var doctorCheckbox: UISwitch!
    @IBOutlet weak var checkboxContainerView: UIStackView!
    @IBOutlet weak var createAttestationButton: UIButton!
    
    let presenter: CreateAttestationPresenter =
        CreateAttestationPresenterImpl(
            preferenceRepository: PreferenceRepository(with: UserDefaults.standard)
        )
    
    var delegate: MainViewDelegate?
    
    let formURL = "https://media.interieur.gouv.fr/deplacement-covid-19/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: formURL)!))
        
        presenter.attach(view: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createAttestationButton.layer.cornerRadius = 10
    }
    
    func setDelegate(delegate: MainViewDelegate) {
        self.delegate = delegate
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.absoluteString == formURL {
            webView.evaluateJavaScript(presenter.getCodeToFillForm())
        } else if webView.url?.absoluteString.contains("blob") ?? false {
            let fileName = presenter.getFileName()
            let _ = webView.exportAsPdfFromWebView(fileName: fileName)
            scheduleNotification(identifier: fileName)
            delegate?.didCreateNewAttestation()
            dismiss(animated: true)
        }
    }

    private func scheduleNotification(identifier: String) {
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2700, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Hurry to come back home!"
        content.body = "Your attestation is almost out of time, create a new one or go home!"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in })
    }
    
    @IBAction func didTapOnCreateAttestation(_ sender: UIButton) {
        presenter.didClickOnCreate()
    }

    @IBAction func didTapOnHideCheckBox(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            sender.setImage(sender.image(for: .normal)?.rotate(radians: .pi).withTintColor(UIColor(red: 0, green: 128, blue: 154)), for: .normal)
            self.checkboxContainerView.isHidden = !self.checkboxContainerView.isHidden
        }
    }
    
    @IBAction func didCheckWalk(_ sender: UISwitch) {
        webView.evaluateJavaScript(presenter.setWalkCheckBox(checked: sender.isOn))
    }
    
    @IBAction func didCheckGroceries(_ sender: UISwitch) {
        webView.evaluateJavaScript(presenter.setGroceriesCheckBox(checked: sender.isOn))
    }
    
    @IBAction func didCheckDoctor(_ sender: UISwitch) {
        webView.evaluateJavaScript(presenter.setDoctorCheckBox(checked: sender.isOn))
    }
    
    @IBAction func didTapOnClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension CreateAttestationViewController: CreateAttestationView {
    func onShowLoading() {
        activityIndicator.isHidden = false
    }
    
    func onHideWebView() {
        webView.isHidden = true
    }
    
    func onCreateFile(jsCode: String) {
        webView.evaluateJavaScript(jsCode)
    }
}
