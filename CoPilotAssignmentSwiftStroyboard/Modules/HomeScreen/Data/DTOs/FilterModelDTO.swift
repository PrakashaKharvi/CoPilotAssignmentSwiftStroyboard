//
//  FilterModelDTO.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import Foundation

// Create a DTO for the FilterModelDTO
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

// MARK: - FilterModelDTO
struct FilterModelDTO: Codable {
    var status: Int
    var message: String
    var data: [FilterDataModelDTO]
    
    func toDomain() -> FilterModel {
        return FilterModel(status: status, message: message, data: data.map { $0.toDomain() })
    }
}

// MARK: - FilterTypeModelDTO
struct FilterDataModelDTO: Codable {
    var title, id: String
    var list: [FilterItemModelDTO]
    
    func toDomain() -> FilterCategoryModel {
        return FilterCategoryModel(title: title, id: id, list: list.map { $0.toDomain() })
    }
}

// MARK: - FilterListModelDTO
struct FilterItemModelDTO: Codable {
    var id, name: String
    var selected: String
    
    func toDomain() -> FilterItemModel {
        return FilterItemModel(id: id, name: name, selected: selected)
    }
}

