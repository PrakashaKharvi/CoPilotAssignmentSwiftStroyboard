//
//  HomeViewModel.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import Foundation

class HomeViewModel: BaseViewModel {
    
    private let fetchArticleUseCase: FetchArticleUseCase
    var articles: [ArticleModel] = []
    var onArticleFetched: (() -> Void)?
    
    init(fetchArticleUseCase: FetchArticleUseCase = FetchArticleUseCase()) {
        self.fetchArticleUseCase = fetchArticleUseCase
    }
    
    func fetchUsers() {
        fetchArticleUseCase.execute { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.onArticleFetched?()
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
}
