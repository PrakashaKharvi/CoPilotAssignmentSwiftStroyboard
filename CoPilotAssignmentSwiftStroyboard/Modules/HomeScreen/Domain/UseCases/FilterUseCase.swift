//
//  FilterUseCase.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import Foundation

class FilterUseCase {
    
    private let filterRepository: FilterRepositoryProtocol
    
    init(filterRepository: FilterRepositoryProtocol = FilterRepository()) {
        self.filterRepository = filterRepository
    }
    
    func execute(completion: @escaping (Result<FilterModel, Error>) -> Void) {
        filterRepository.fetchFilterList { filterModel in
            completion(filterModel)
        }
    }
    
    // Function to apply filters
    func filterFor(
        originalList: [ArticleItemModel],
        authorId: String? = nil,
        categoryId: String? = nil,
        articleId: String? = nil,
        tags: [String]? = nil
    ) -> [ArticleItemModel] {
        
        return originalList.filter { articleModel in
            if let authorId = authorId, articleModel.authorId != authorId { return false }
            if let categoryId = categoryId, articleModel.categoryId != categoryId { return false }
            if let articleId = articleId, articleModel.articleId != articleId { return false }
            if let tags = tags, !tags.allSatisfy({ articleModel.tags?.contains($0) ?? false }) { return false }
            return true
        }
    }
}
