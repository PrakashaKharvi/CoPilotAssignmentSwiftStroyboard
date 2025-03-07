//
//  HomeViewModel.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import UIKit

class HomeViewModel: BaseViewModel {
    
    private var fetchFilterUseCase: FetchFilterUseCase
    var filterModel: FilterModel?
    var onFilterFetched: (() -> Void)?
    
    init(fetchFilterUseCase: FetchFilterUseCase) {
        self.fetchFilterUseCase = fetchFilterUseCase
    }

    // Function to update selection
    func updateSelectedItem(categoryId: String, itemId: String) {
        guard let filterModelTemp = filterModel else { return }
        if let categoryIndex = filterModelTemp.data.firstIndex(where: { $0.id == categoryId }) {
            for index in filterModelTemp.data[categoryIndex].list.indices {
                filterModel?.data[categoryIndex].list[index].selected = filterModelTemp.data[categoryIndex].list[index].id == itemId ? "true" : "false"
            }
        }
    }
    
    func fetchFilters() {
        fetchFilterUseCase.execute { [weak self] result in
            switch result {
            case .success(let filterModel):
                self?.filterModel = filterModel
                self?.onFilterFetched?()
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
    
    func numberOfFilters() -> Int {
        return filterModel?.data.count ?? 0
    }
    
    func getFilterList() -> [FilterCategoryModel] {
        return filterModel?.data ?? []
    }
    
    
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
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        
        let collectionViewCenter = collectionView.bounds.size.width / 2
        let cellCenter = attributes.center.x
        let contentOffsetX = cellCenter - collectionViewCenter
        
        let minOffsetX = -collectionView.contentInset.left
        let maxOffsetX = collectionView.contentSize.width - collectionView.bounds.width + collectionView.contentInset.right
        
        let targetOffsetX = max(min(contentOffsetX, maxOffsetX), minOffsetX)
        
        collectionView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
    }
}
