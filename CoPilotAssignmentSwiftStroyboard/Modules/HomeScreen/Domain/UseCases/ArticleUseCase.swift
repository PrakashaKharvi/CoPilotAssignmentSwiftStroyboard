//
//  ArticleUseCase.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 08/03/25.
//

import Foundation

class ArticleUseCase {
    private let articleRepository: ArticleRepositoryProtocol
    
    init(articleRepository: ArticleRepositoryProtocol = ArticleRepository()) {
        self.articleRepository = articleRepository
    }
    
    func fetchArticleList(completion: @escaping (Result<ArticleModel, Error>) -> Void) {
        articleRepository.fetchArticleLsit { result in
            completion(result)
        }
    }
}

