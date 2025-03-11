//
//  ArticleModel.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 07/03/25.
//

import Foundation

//{
//   "status":1,
//   "message":"success",
//   "data":{
//      "page":1,
//      "categoryId":null,
//      "tag":"technology",
//      "authorName":"Anonymous",
//      "articles":[
//         {
//            "title":"GitHub Copilot - About, Features and Use Cases",
//            "hero":"https://www.freecodecamp.org/news/content/images/size/w2000/2023/06/Screenshot-2023-06-14-at-12.42.04-PM.png",
//            "articleId":"a2b448sq",
//            "categoryId":"r4wd2u8",
//            "authorId":"y7w3w242",
//            "articleType":1,
//            "tags":[
//               "Science",
//               "Technology"
//            ]
//         }
//      ]
//   }
//}

struct ArticleModel: Codable {
    let status: Int?
    let message: String?
    let data: ArticleDataModel?
}

struct ArticleDataModel: Codable {
    let page: Int?
    let categoryId: String?
    let tag: String?
    let authorName: String?
    let articles: [ArticleItemModel]?
}

struct ArticleItemModel: Codable {
    let title: String?
    let Subtitle: String?
    let hero: String?
    let articleId: String?
    let categoryId: String?
    let authorId: String?
    let articleType: Int?
    let tags: [String]?
}
