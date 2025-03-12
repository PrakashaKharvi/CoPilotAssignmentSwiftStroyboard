//
//  HomeViewModel.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import UIKit

class HomeViewModel: BaseViewModel {
    
    private let coordinator: HomeScreenCoordinator
    
    private var filterUseCase: FilterUseCase
    var filterModel: FilterModel?
    var onFilterFetched: (() -> Void)?
    
    private var articleUseCase: ArticleUseCase
    var articleListModelOriginal: [ArticleItemModel] = []
    var articleListModelToDisplay: [ArticleItemModel] = []
    var onArticleListFetched: (() -> Void)?
    var filterDic: [String: String] = [:]
    
    var onTagBasedArticleListFetched: (() -> Void)?
    
    init(filterUseCase: FilterUseCase, articleUseCase: ArticleUseCase, coordinator: HomeScreenCoordinator) {
        self.filterUseCase = filterUseCase
        self.articleUseCase = articleUseCase
        self.coordinator = coordinator
    }
    
    func fetchFilters() {
        filterUseCase.execute { [weak self] result in
            switch result {
            case .success(let filterModel):
                self?.filterModel = filterModel
                self?.onFilterFetched?()
            case .failure(let error):
                print("Error fetching filter catregories: \(error)")
            }
        }
    }
    
    func numberOfFilters() -> Int {
        return filterModel?.data.count ?? 0
    }
    
    func getFilterCategoryFor(index: Int) -> FilterCategoryModel? {
        return filterModel?.data[index]
    }
    
    // MARK: get title from model
    func getAllTitle(data: FilterCategoryModel) -> String {
        switch data.id {
        case "1":
            return "All Authors"
        case "2":
            return "All Categories"
        case "3":
            return "All Article Types"
        case "4":
            return "All Tags"
        default:
            return ""
        }
    }
    
    func centerCellSmoothly(collectionView: UICollectionView, indexPath: IndexPath) {
        guard let _ = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        
        let collectionViewCenter = collectionView.bounds.size.width / 2
        let cellCenter = attributes.center.x
        let contentOffsetX = cellCenter - collectionViewCenter
        
        let minOffsetX = -collectionView.contentInset.left
        let maxOffsetX = collectionView.contentSize.width - collectionView.bounds.width + collectionView.contentInset.right
        
        let targetOffsetX = max(min(contentOffsetX, maxOffsetX), minOffsetX)
        
        collectionView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
    }
    
    
    // MARK: - Fetch Articles
    func fetchArticleList() {
        articleUseCase.fetchArticleList { [weak self] result in
            switch result {
            case .success(let data):
                self?.articleListModelOriginal = data.data?.articles ?? []
                self?.articleListModelToDisplay = self?.articleListModelOriginal ?? []
                self?.onArticleListFetched?()
            case .failure(let error):
                print("Error fetching Article List: \(error)")
            }
        }
    }
    
    func numberOfArticles() -> Int {
        return self.articleListModelToDisplay.count
    }
    
    func getArticleFor(index: Int) -> ArticleItemModel? {
        return self.articleListModelToDisplay[index]
    }
    
    // MARK: - Update Filter
    func updateSelectedItem(categoryId: String, itemId: String) {
        guard let filterModelTemp = filterModel else { return }
        if let categoryIndex = filterModelTemp.data.firstIndex(where: { $0.id == categoryId }) {
            for index in filterModelTemp.data[categoryIndex].list.indices {
                filterModel?.data[categoryIndex].list[index].selected = filterModelTemp.data[categoryIndex].list[index].id == itemId ? "true" : "false"
                
                // Need to add the selected categoryID and itemID for filter dictionary
                if filterModel?.data[categoryIndex].list[index].selected == "true" {
                    if itemId == "0" {
                        filterDic.removeValue(forKey: categoryId)
                    } else if categoryId == "4" {
                        filterDic.updateValue(filterModelTemp.data[categoryIndex].list[index].name, forKey: categoryId)
                    } else{
                        filterDic.updateValue(itemId, forKey: categoryId)
                    }
                }
            }
            self.applyFilterOnArticleList()
        }
    }
    
    // MARK: - Apply Filter
    private func applyFilterOnArticleList() {
        let tags = filterDic["4"] != nil ? [filterDic["4"]!] : nil
        self.articleListModelToDisplay = filterUseCase.filterFor(
            originalList: articleListModelOriginal,
            authorId: filterDic["1"],
            categoryId: filterDic["2"],
            articleId: filterDic["3"],
            tags: tags
        )
        self.onArticleListFetched?()
    }
    
    func fetchTagBasedArticleList(tags: [String]) {
        self.articleListModelToDisplay = filterUseCase.filterFor(originalList: articleListModelOriginal, tags: tags)
        self.onTagBasedArticleListFetched?()
    }
    
    // MARK: Navigate to Detail Screen
    func didSelectArticle(at index: Int) {
        let article = articleListModelToDisplay[index]
        coordinator.navigateToArticleDetail(article: article)
    }
}
