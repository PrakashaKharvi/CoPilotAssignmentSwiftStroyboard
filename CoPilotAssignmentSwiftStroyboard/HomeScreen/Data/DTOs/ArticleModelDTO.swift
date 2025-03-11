//
//  ArticleModelDTO.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 07/03/25.
//

import Foundation

struct ArticleModelDTO: Codable {
    let status: Int?
    let message: String?
    let data: ArticleDataModelDTO?
    
    func toDomain() -> ArticleModel {
        return ArticleModel(status: status, message: message, data: data.map { $0.toDomain() })
    }
}

struct ArticleDataModelDTO: Codable {
    let page: Int?
    let categoryId: String?
    let tag: String?
    let authorName: String?
    let articles: [ArticleItemModelDTO]?
    
    func toDomain() -> ArticleDataModel {
        return ArticleDataModel(page: page, categoryId: categoryId, tag: tag, authorName: authorName, articles: articles?.map { $0.toDomain() })
    }
}

struct ArticleItemModelDTO: Codable {
    let title: String?
    let Subtitle: String?
    let hero: String?
    let articleId: String?
    let categoryId: String?
    let authorId: String?
    let articleType: Int?
    let tags: [String]?
    
    func toDomain() -> ArticleItemModel {
        return ArticleItemModel(title: title, Subtitle: Subtitle, hero: hero, articleId: articleId, categoryId: categoryId, authorId: authorId, articleType: articleType, tags: tags)
    }
}
