//
//  FilterRepository.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import Foundation

protocol FilterRepositoryProtocol {
    func fetchFilterList(completion: @escaping (Result<FilterModel, Error>) -> Void)
}

class FilterRepository: FilterRepositoryProtocol {
    private let service: FilterServiceProtocol
    
    init(service: FilterServiceProtocol = LocalFilterService()) {
        self.service = service
    }
    
    func fetchFilterList(completion: @escaping (Result<FilterModel, Error>) -> Void) {
        service.fetchFilters { result in
            completion(result)
        }
    }
}
