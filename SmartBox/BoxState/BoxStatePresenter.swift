//
//  BoxStatePresenter.swift
//  SmartBox
//
//  Created by Agat Levi on 07/05/2022.
//

import Foundation

class BoxStatePresenter {
    var view: BoxStateViewController?
    var viewModel: BoxStateViewModel
    
    init(viewModel: BoxStateViewModel, view: BoxStateViewController) {
        self.viewModel = viewModel
        self.view = view
    }
    
    func attachView(_ view: BoxStateViewController) {
        self.view = view
        self.view?.update(viewModel: viewModel)
    }
        
    func detachView() {
        self.view = nil
    }
    
    func logout() {
        GlobalManager.instance.userManager.logout()
        view?.openMainScreen()
    }
}
