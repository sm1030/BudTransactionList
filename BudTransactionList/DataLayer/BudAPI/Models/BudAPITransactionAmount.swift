//
//  BudAPITransactionAmount.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

struct BudAPITransactionAmount: Decodable {
    
    /// Transaction amount value
    var value: Double?
    
    /// Transaction currency ISO
    var currencyIso: String?
}
