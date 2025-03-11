//
//  LocaleArticleService.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 08/03/25.
//

import Foundation

protocol ArticleServiceProtocol {
    func fetchArticleList(completion: @escaping (Result<ArticleModel, Error>) -> Void)
}

class LocaleArticleService: ArticleServiceProtocol {
    func fetchArticleList(completion: @escaping (Result<ArticleModel, any Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "ArticleListJson", withExtension: "json") else {
            completion(.failure(NSError(domain: "File Not Found", code: 404, userInfo: nil)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let filterDTOs = try JSONDecoder().decode(ArticleModelDTO.self, from: data)
            let filters = filterDTOs.toDomain()
            completion(.success(filters))
        } catch {
            completion(.failure(error))
        }
    }
}
