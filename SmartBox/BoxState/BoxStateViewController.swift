//
//  BoxStateViewController.swift
//  SmartBox
//
//  Created by Agat Levi on 07/05/2022.
//

import UIKit

class BoxStateViewController: UIViewController {
    @IBOutlet var boxStateInfo: UILabel!
    @IBOutlet var boxIdInfo: UILabel!
    @IBOutlet var boxThresholdInfo: UILabel!
    
    var presenter: BoxStatePresenter!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.attachView(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.detachView()
    }
    
    @objc func logoutTapped() {
        presenter.logout()
    }
    
    func openMainScreen() {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension BoxStateViewController {
    func update(viewModel: BoxStateViewModel) {
        boxThresholdInfo.text = viewModel.threshold + "%"
        boxStateInfo.text = viewModel.currentWeight + "%"
        boxIdInfo.text = viewModel.boxID
        view.layoutIfNeeded()
    }
}
