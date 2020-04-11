//
//  MainViewController.swift
//  GoOut
//
//  Created by Clément Casamayou on 10/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import UIKit
import WebKit

class CreateAttestationViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
            let _ = webView.exportAsPdfFromWebView(fileName: presenter.getFileName())
            delegate?.didCreateNewAttestation()
            dismiss(animated: true)
        }
    }
    
    @IBAction func didTapOnCreateAttestation(_ sender: UIButton) {
        presenter.didClickOnCreate()
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
