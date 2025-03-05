//
//  ArticleRepository.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import Foundation

protocol ArticleRepositoryProtocol {
    func fetchArticles(completion: @escaping (Result<[ArticleModel], Error>) -> Void)
}

class ArticleRepository: ArticleRepositoryProtocol {
    private let service: ArticleServiceProtocol
    
    init(service: ArticleServiceProtocol = LocalArticleService()) {
        self.service = service
    }
    
    func fetchArticles(completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
        service.fetchArticles { result in
            completion(result)
        }
    }
}
