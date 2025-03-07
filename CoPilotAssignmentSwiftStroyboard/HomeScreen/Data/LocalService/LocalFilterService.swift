//
//  LocalFilterData.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import Foundation

protocol FilterServiceProtocol {
    func fetchFilters(completion: @escaping (Result<FilterModel, Error>) -> Void)
}

class LocalFilterService: FilterServiceProtocol {
    func fetchFilters(completion: @escaping (Result<FilterModel, any Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "FilterDataJson", withExtension: "json") else {
            completion(.failure(NSError(domain: "File Not Found", code: 404, userInfo: nil)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let filterDTOs = try JSONDecoder().decode(FilterModelDTO.self, from: data)
            let filters = filterDTOs.toDomain()
            completion(.success(filters))
        } catch {
            completion(.failure(error))
        }
    }
}
