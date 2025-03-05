//
//  LocalArticleService.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import Foundation

protocol ArticleServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[ArticleModel], Error>) -> Void)
}

class LocalArticleService: ArticleServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[ArticleModel], any Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "ArticleJson", withExtension: "json") else {
            completion(.failure(NSError(domain: "File Not Found", code: 404, userInfo: nil)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let articleDTOs = try JSONDecoder().decode([ArticleModelDTO].self, from: data)
            let articles = articleDTOs.map { $0.toDomain() }
            completion(.success(articles))
        } catch {
            completion(.failure(error))
        }
    }
}
