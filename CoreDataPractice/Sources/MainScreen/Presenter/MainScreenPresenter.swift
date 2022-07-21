//
//  MainScreenPresenter.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import Foundation

final class MainScreenPresenter {
    
    // MARK: - Elements
    
    private weak var view: MainScreenViewControllerInput?
    
    // MARK: - Lifecycle
    
    init(view: MainScreenViewControllerInput) {
        self.view = view
    }
    
    // MARK: - Private functions
    
    
}

// MARK: - MainScreenViewControllerOutput

extension MainScreenPresenter: MainScreenViewControllerOutput {
    
}
