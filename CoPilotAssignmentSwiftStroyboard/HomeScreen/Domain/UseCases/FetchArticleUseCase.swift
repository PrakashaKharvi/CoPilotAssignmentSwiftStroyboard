//
//  FetchArticleUseCase.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import Foundation

class FetchArticleUseCase {
    
    private let articleRepository: ArticleRepositoryProtocol
    
    init(articleRepository: ArticleRepositoryProtocol = ArticleRepository()) {
        self.articleRepository = articleRepository
    }
    
    func execute(completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
        articleRepository.fetchArticles { articles in
            completion(articles)
        }
    }
}

