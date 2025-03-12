//
//  ArticleDetailCoordinator.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 11/03/25.
//

import UIKit

class ArticleDetailCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // Navigate to Article Detail Screen
    func navigateToArticleTagScreen(tagText: String) {
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let homeVC = storyboard.instantiateInitialViewController() as! HomeViewController
        
        homeVC.viewModel = HomeViewModel(filterUseCase: FilterUseCase(filterRepository: FilterRepository(service: LocaleFilterService())), articleUseCase: ArticleUseCase(articleRepository: ArticleRepository(service: LocaleArticleService())), coordinator: HomeScreenCoordinator(navigationController: self.navigationController))
        homeVC.loadFor = .tagBased
        homeVC.selectdTag = tagText
        self.navigationController.pushViewController(homeVC, animated: true)
    }
}
