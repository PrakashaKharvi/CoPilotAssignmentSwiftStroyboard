//
//  FetchFilterUseCase.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import Foundation

class FetchFilterUseCase {
    
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
