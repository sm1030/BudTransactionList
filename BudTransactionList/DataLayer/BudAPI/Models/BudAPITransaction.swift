//
//  BudAPITransaction.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/// Transaction list item
struct BudAPITransaction: Decodable {
    
    /// Transaction id
    var id: String?
    
    /// Transaction date
    var date: Date?
    
    /// Transaction description
    var description: String?
    
    /// Transaction category ID
    var categoryId: Int?
    
    /// Transaction currency
    var currency: String?
    
    
    /// Transaction amount
    var amount: BudAPITransactionAmount?
    
    /// Transaction product
    var product: BudAPITransactionProduct?
}
