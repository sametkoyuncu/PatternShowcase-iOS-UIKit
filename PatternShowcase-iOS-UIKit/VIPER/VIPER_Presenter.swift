//
//  VIPER_Presenter.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import Foundation

protocol VIPERPresenterDelegate: AnyObject {
    func showPosts(posts: [VIPERPost])
    func showError()
}

class VIPERPresenter {
    weak var delegate: VIPERPresenterDelegate?
    private let interactor = VIPERInteractor()

    func fetchPosts() {
        interactor.delegate = self
        interactor.fetchPosts()
    }
}

extension VIPERPresenter: VIPERInteractorDelegate {
    func postsFetched(posts: [VIPERPost]) {
        delegate?.showPosts(posts: posts)
    }

    func onError() {
        delegate?.showError()
    }
}
