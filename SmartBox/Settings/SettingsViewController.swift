//
//  SettingsViewController.swift
//  SmartBox
//
//  Created by Agat Levi on 09/04/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum titles {
        static let accountDisconnected = "Connect to eBay account"
        static let isConnected = " is connected"
    }

    var presenter: SettingsPresenter!
    var ebayUserName: String?

    @IBOutlet var ebayAccountButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var boxIdTextBox: UITextField!
    @IBOutlet var thresholdTextBox: UITextField!
    @IBOutlet var ebayLinkTextBox: UITextField!
    
    @IBOutlet var checkmarkSuccess: UIImageView!
    
    //Labels:
    @IBOutlet var boxIdLabel: UILabel!
    @IBOutlet var thresholdLabel: UILabel!
    @IBOutlet var ebayLinkLabel: UILabel!
    @IBOutlet var ebayAccountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.attachView(self)
        presenter.setSubmitAvailability()
        ebayAccountButton.setTitle(presenter.setAccountButtonText(), for: .normal)
        submitButton.isHidden = false
        checkmarkSuccess.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.detachView()
    }
    
    @IBAction func boxIdextBoxEdited(_ sender: UITextField) {
        presenter.setSubmitAvailability()
    }
    
    @IBAction func thresholdTextBoxEdited(_ sender: UITextField) {
        presenter.setSubmitAvailability()
    }
    
    @IBAction func ebayLinkTextBoxEdited(_ sender: UITextField) {
        presenter.setSubmitAvailability()
    }
    
    
    @IBAction func ebayAcoountButtonTapped(_ sender: UIButton) {
        ebayUserName = presenter.connectToEbayAccount()
        sender.setTitle(presenter.setAccountButtonText(), for: .normal)
        presenter.setSubmitAvailability()
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if !presenter.verifyEbayLink(link: ebayLinkTextBox.text) || !presenter.verifyThreshold(threshold: thresholdTextBox.text) {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlertViewController(title: "Invalid input", message: "Are you sure this is the correct link? \nIs your threshold is between 0-100 ? Please fix and try again !", actions: [okAction], animated: true, completion: nil)
            return
        }
        
        guard let boxId = boxIdTextBox.text, let threshold = thresholdTextBox.text, let productLink = ebayLinkTextBox.text else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlertViewController(title: "Missing fields", message: "One or more fields are missing!\nPlease fill it before you continue.", actions: [okAction], animated: true, completion: nil)
            return
        }
        presenter.saveInformationBeforeSubmit(boxID: boxId, threshold: threshold, productLink: productLink)
        
        submitButton.isHidden = true
        checkmarkSuccess.isHidden = false
        // Delay in order to show  the user a confirmation UI:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presenter.submit()
        }
    }
    
    func setSubmitButton(enabled: Bool) {
        submitButton.isEnabled = enabled
    }
    
    func openBoxStateViewController() {
        //TODO: Remove the commented boxState's condition after Dor fixes the getInfo !!!!
//        let boxState = "30"
        
        guard let userVM = GlobalManager.instance.userManager.userViewModel, let boxId = userVM.boxId,
            let threshold = userVM.boxBaseline,
            let currentWeight = userVM.currentWeight
        else {
            Logger.instance.logEvent(type: .login, info: "openBoxStateVC failed because of an empty userVM")
            return
        }
        let boxStateStoryboard = UIStoryboard(name: "BoxState", bundle: nil)
        let boxStateVC = boxStateStoryboard.instantiateViewController(withIdentifier: "BoxState") as! BoxStateViewController
        let boxStatePresenter = BoxStatePresenter(viewModel: BoxStateViewModel(boxID: boxId, currentWeight: currentWeight, threshold: threshold), view: boxStateVC)
        boxStateVC.presenter = boxStatePresenter
        navigationController?.pushViewController(boxStateVC, animated: true)
    }
    
//}
// TODO: Return it after figuring out what to do with the protocols
//extension SettingsViewController: SettingsPresenterView {
    func update(viewModel: SettingsViewModel) {
        //titles:
        boxIdLabel.text = viewModel.boxIdTitleText
        thresholdLabel.text = viewModel.ThresholdTitleText
        ebayLinkLabel.text = viewModel.ebayProductLinkTitleText
        ebayAccountLabel.text = viewModel.ebayAccountTitleText
        submitButton.titleLabel?.text = viewModel.submitButtonText
        
        //values:
        boxIdTextBox.text = viewModel.boxId
        if let threshold = viewModel.threshold {
            thresholdTextBox.text = String(threshold)
        } else {
            thresholdTextBox.text = ""
        }
        ebayLinkTextBox.text = viewModel.productLink
        ebayAccountButton.titleLabel?.text = viewModel.isAccountConnected ? titles.isConnected : titles.accountDisconnected
    }
}
