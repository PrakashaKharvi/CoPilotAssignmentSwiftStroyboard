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
}
