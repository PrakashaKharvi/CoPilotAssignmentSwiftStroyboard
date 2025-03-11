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
//        let remoteDataSource = LocaleFilterService()
//        let repository = FilterRepository(service: remoteDataSource)
//        let filterUseCase = FilterUseCase(filterRepository: repository)
//        
//        let localeArticleService = LocaleArticleService()
//        let articleRepository = ArticleRepository(service: localeArticleService)
//        let articleUseCase = ArticleUseCase(articleRepository: articleRepository)
//        
//        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
//        let homeVC = storyboard.instantiateInitialViewController() as! HomeViewController
//        let navgationController = UINavigationController(rootViewController: homeVC)
//        
//        let viewModel = HomeViewModel(filterUseCase: filterUseCase, articleUseCase: articleUseCase, coordinator: HomeScreenCoordinator(navigationController: navgationController))
//        homeVC.viewModel = viewModel //container.resolve(HomeViewModel)!
                
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let homeVC = storyboard.instantiateInitialViewController() as! HomeViewController
        
        homeVC.viewModel = HomeViewModel(filterUseCase: FilterUseCase(filterRepository: FilterRepository(service: LocaleFilterService())), articleUseCase: ArticleUseCase(articleRepository: ArticleRepository(service: LocaleArticleService())), coordinator: HomeScreenCoordinator(navigationController: self.navigationController))
        homeVC.loadFor = .tagBased
        homeVC.selectdTag = tagText
        self.navigationController.pushViewController(homeVC, animated: true)
    }
}
