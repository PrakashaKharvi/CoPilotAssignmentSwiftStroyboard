//
//  ArticleModelDTO.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import Foundation

//{
//"message": "success",
// "data": {
// "articleId": "a2b448sq",
// "published": "2024-12-24 13:45",
// "author": {
//   "authorId": "c3js6384",
//   "authorImage": "",
//   "authorName": "Anonymous"
//   },
// "category" : {
//   "categoryId": "a9d7hds2",
//   "categoryName": "Technology"
//   },
// "tags": ["technology", "Gen AI", "Copilot"],
// "title": "GitHub Copilot - About, Features and Use Cases",
// "Subtitle": "quantifying GitHub Copilot’s impact on developer productivity and happiness",
// "hero": "https://www.freecodecamp.org/news/content/images/size/w2000/2023/06/Screenshot-2023-06-14-at-12.42.04-PM.png",
// "description": "<p>Have you ever wondered how coding could become even more efficient? With GitHub Copilot, you can utilise the power of AI to generate code suggestions according to your specific context</p>\n    <h2 id='1'>Features of GitHub Copilot</h2> \n  <ul> \n   <li>GitHub Copilot uses an AI model trained on a large corpus of code from publicly available sources, including code on GitHub itself. This allows it to understand and generate programming patterns, functions, and entire classes.</li> \n   <li>It assists in writing new code and contributing to existing code. The tool can suggest complete methods, boilerplate code, tests, and even complex algorithms.</li>\n  </ul>"
//}
//}

// Create a new file named ArticleModelDTO.swift

struct ArticleModelDTO: Codable {
    var message: String?
    var data: ArticleDataDTO?
    
    func toDomain() -> ArticleModel {
        return ArticleModel(message: message, data: data?.toDomain())
    }
}

struct ArticleDataDTO: Codable {
    var articleId: String?
    var published: String?
    var author: AuthorDTO?
    var category: CategoryDTO?
    var tags: [String]?
    var title: String?
    var subtitle: String?
    var hero: String?
    var description: String?
    
    func toDomain() -> ArticleData {
        return ArticleData(articleId: articleId, published: published, author: author?.toDomain(), category: category?.toDomain(), tags: tags, title: title, subtitle: subtitle, hero: hero, description: description)
    }
}

struct AuthorDTO: Codable {
    var authorId: String?
    var authorImage: String?
    var authorName: String?
    
    func toDomain() -> Author {
        return Author(authorId: authorId, authorImage: authorImage, authorName: authorName)
    }
}

struct CategoryDTO: Codable {
    var categoryId: String?
    var categoryName: String?
    
    func toDomain() -> Category {
        return Category(categoryId: categoryId, categoryName: categoryName)
    }
}
