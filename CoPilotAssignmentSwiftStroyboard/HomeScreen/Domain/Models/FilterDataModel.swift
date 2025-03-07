//
//  FilterDataModel.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import Foundation

//{
// "status": 1,
//  "message": "success",
//  "data": [
//      {
//          "title": "author",
//          "id": "1",
//          "list": [
//              {
//                 "id": "0",
//                 "name": "Author"
//              }
//          ]
//      }
//  ]
//}

// MARK: - FilterDataModel
struct FilterModel: Codable {
    var status: Int
    var message: String
    var data: [FilterCategoryModel]
}

// MARK: - FilterTypeModel
struct FilterCategoryModel: Codable {
    var title, id: String
    var list: [FilterItemModel]
}

// MARK: - FilterModel
struct FilterItemModel: Codable {
    var id, name: String
    var selected: String
}

