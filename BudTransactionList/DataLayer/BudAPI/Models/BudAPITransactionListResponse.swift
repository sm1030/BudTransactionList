//
//  BudAPITransactionListResponse.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 This struct contains transaction list response body
 */
struct BudAPITransactionListResponse: Decodable {
    
    /// Collection of category objects
    var data: [BudAPITransaction]
}

extension BudAPI {
    
    /**
     Get all available transactions
     - parameter completion: This completion closure will be called as soon operation is completed, sucessfully or not. If it was sucessfull it will return BudAPITransactionListResponse. Otherwise it will return NIL
     */
    func getTransactionList(completion: (( BudAPITransactionListResponse?, Error?) -> Void)? ) {
        
        /// Make URL object
        let urlString = apiBase + BudAPIRestMethods.transactionsList.rawValue
        guard let url = URL(string: urlString) else {
            print("ERROR: getEmbededPage() can't create URL object based on url string \"\(urlString)\"")
            completion?(nil, BudAPIErrors.badUrlObject)
            return
        }
        
        /// Make URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        /// Run dataTask with web response preparsing
        runDataTaskAndHandleErrors(urlRequest: urlRequest) { (data, error) in
            if let data = data {
                let transactionListResponse: BudAPITransactionListResponse? = self.decode(data: data)
                DispatchQueue.main.async { completion?(transactionListResponse, nil) }
            } else {
                DispatchQueue.main.async { completion?(nil, error) }
            }
        }
    }
}
