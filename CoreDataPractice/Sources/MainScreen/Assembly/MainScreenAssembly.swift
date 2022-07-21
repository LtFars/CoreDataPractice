//
//  MainScreenAssembly.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import UIKit

final class MainScreenAssembly {
    static func assembly() -> UINavigationController {
        
        let viewController = MainScreenViewController()
        let presenter = MainScreenPresenter(view: viewController)
        viewController.presenter = presenter
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
}
