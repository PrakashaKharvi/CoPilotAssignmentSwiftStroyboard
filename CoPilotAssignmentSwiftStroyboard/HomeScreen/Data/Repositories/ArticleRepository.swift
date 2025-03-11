//
//  ArticleRepository.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 08/03/25.
//

import Foundation

protocol ArticleRepositoryProtocol {
    func fetchArticleLsit(completion: @escaping (Result<ArticleModel, Error>) -> Void)
}

class ArticleRepository: ArticleRepositoryProtocol {
    
    private let service: ArticleServiceProtocol
    
    init(service: ArticleServiceProtocol = LocaleArticleService()) {
        self.service = service
    }
    
    func fetchArticleLsit(completion: @escaping (Result<ArticleModel, any Error>) -> Void) {
        service.fetchArticleList { result in
            completion(result)
        }
    }
}
