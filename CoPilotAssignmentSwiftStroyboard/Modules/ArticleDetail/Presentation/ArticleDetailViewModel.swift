//
//  ArticleDetailViewModel.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 11/03/25.
//

import Foundation

class ArticleDetailViewModel {
    
    let article: ArticleItemModel
    let articleDetailCoordinator: ArticleDetailCoordinator
    
    init(article: ArticleItemModel, coordinator: ArticleDetailCoordinator) {
        self.article = article
        self.articleDetailCoordinator = coordinator
    }
    
    func numberOfTags() -> Int {
        return article.tags?.count ?? 0
    }
    
    func getTagText(at index: Int) -> String {
        return article.tags?[index] ?? ""
    }
    
    func navigateToArticleTagScreen(at index: Int) {
        let tagText = getTagText(at: index)
        articleDetailCoordinator.navigateToArticleTagScreen(tagText: tagText)
    }
}
