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
    var onTagsUpdated: (() -> Void)?

    var articleTitle: String { article.title ?? "" }
    var articleImageURL: String? { article.hero }
    var authorName: String { article.authorName ?? "" }
    var articleSubtitle: String { article.Subtitle ?? "" }
    var articleDescription: String { article.description ?? "" }
    var isArticleText: Bool { article.articleType == 1 }
    var videoURL: String { article.description ?? "" }
    
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
        articleDetailCoordinator.navigateToArticleTagScreen(tagText: article.tags?[index] ?? "")
    }
}
