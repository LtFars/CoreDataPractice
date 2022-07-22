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
    private var dataManager: CoreDataManager?
    
    // MARK: - Lifecycle
    
    init(view: MainScreenViewControllerInput) {
        self.view = view
        initDataManager()
    }
    
    // MARK: - Private functions
    
    private func initDataManager() {
        do {
            dataManager = try CoreDataManager()
        } catch {
            print("DataManager was not created!")
        }
    }
}

// MARK: - MainScreenViewControllerOutput

extension MainScreenPresenter: MainScreenViewControllerOutput {
    func fetchProfiles() {
        guard let dataManager = dataManager else { return }
        let data = dataManager.fetchData()
        view?.updateEntireTable(with: data)
    }
    
    func saveProfile(with name: String) {
        let profile = dataManager?.saveProfile(with: name)
        guard let profile = profile else { return }
        view?.update(with: profile)
    }
    
    func deleteProfile(_ profile: ProfileCardEntity) {
        guard let dataManager = dataManager else { return }
        dataManager.deleteProfile(profile.id) { [weak self] result in
            switch result {
            case .success(_):
                let data = dataManager.fetchData()
                self?.view?.updateEntireTable(with: data)
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
    
    func changeProfile(_ profile: ProfileCard) {
        guard let dataManager = dataManager else { return }
        dataManager.changeProfile(profile) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.view?.update(with: profile)
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
}
