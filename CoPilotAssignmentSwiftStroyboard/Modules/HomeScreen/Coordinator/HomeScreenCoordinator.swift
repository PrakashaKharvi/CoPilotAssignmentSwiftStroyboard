//
//  HomeScreenCoordinator.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 11/03/25.
//

import UIKit

class HomeScreenCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Navigate to Article Detail Screen
    func navigateToArticleDetail(article: ArticleItemModel) {
        let detailViewModel = ArticleDetailViewModel(article: article, coordinator: ArticleDetailCoordinator(navigationController: self.navigationController))
        let detailVC = ArticleDetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
