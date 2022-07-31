//
//  LoginViewController.swift
//  SmartBox
//
//  Created by agat levi on 02/03/2022.
//

import UIKit

protocol AuthenticationErrorDelegate {
    func userNameAuthenticationError(title: String, description: String)
}

class LoginViewController: UIViewController {

//    var authenticatorError: AuthenticationErrorProtocol
    lazy var presenter = LoginPresenter(view: self, viewModel: LoginViewModel(), loginManager: GlobalManager.instance.loginManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        authenticatorError.delegate += self
        loadingAnimation.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.attachView(self)
        loadingAnimation.stopAnimating()
        loginButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.detachView()
    }
    
    deinit {
//        authenticatorError.delegate -= self
    }

    @IBOutlet var smartBoxLogo: UILabel!
    @IBOutlet var userNameTextBox: UITextField!
    @IBOutlet var passwordTextBox: UITextField!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet var loginButton: UIButton!
    
    func changeLoginButtonAvailability() {
        if !userNameTextBox.state.isEmpty && !passwordTextBox.state.isEmpty {
            //TODO: Change login button to enabled
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        loadingAnimation.startAnimating()
        sender.isHidden = true
        guard let password = passwordTextBox.text else { return }
        guard let username = userNameTextBox.text else { return }
        if !username.isValidEmail() {
            let okAction = UIAlertAction(title: "Let me fix it", style: .default, handler: nil)
            showAlertViewController(title: "Invalid input", message: "Your email looks fishy, are you sure it is correct?", actions: [okAction], animated: true, completion: {
                self.loadingAnimation.stopAnimating()
                self.loginButton.isHidden = false
            })
            return
        }
        presenter.login(with: username, and: password)
    }
    
    func openBoxStateViewController(){
        //TODO: Remove the commented boxState's condition after Dor fixes the getInfo !!!!
//        let boxState = "30"
        
        Logger.instance.logEvent(type: .login, info: "openBoxStateVC  triggered")
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
        Logger.instance.logEvent(type: .login, info: "openBoxStateVC: presenter  created!")
        navigationController?.pushViewController(boxStateVC, animated: true)
    }
    
    func showLoginFailedAlert(error: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlertViewController(title: "Login failed", message: error, actions: [okAction], animated: true, completion: {
            self.loadingAnimation.stopAnimating()
            self.loginButton.isHidden = false
        })
        return
    }
}

extension LoginViewController: AuthenticationErrorDelegate {
    func userNameAuthenticationError(title: String, description: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: LoginPresenterView {
    func update(viewModel: LoginViewModel) {
//       changeTextLabel.text = "I have been changed!"
//       self.view.backgroundColor = .yellow
    }
}

