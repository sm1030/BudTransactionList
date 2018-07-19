//
//  BudAPITransactionProduct.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

struct BudAPITransactionProduct: Decodable {
    
    /// Transaction product id
    var id: Int?
    
    /// Transaction product title
    var title: String?
    
    /// Transaction product icon url
    var icon: String?
}
