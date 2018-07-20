//
//  TransactionManager.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 20/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

class TransactionManager {
    
    /// Shared instance
    static let shared = TransactionManager()
    
    /// BudAPI instance. You can set mock up instance during UnitTest
    var budAPI = BudAPI.shared
    
    /// Notification name for category list update event
    static let transactionListUpdateNotification = Notification.Name("TransactionManager_TransactionListUpdateNotification")
    
    /// Latest full transaction list
    private var transactionList: [BudAPITransaction]?
    
    /// TransactionListViewController NavigationTitle text
    var transactionListTitle = ""
    
    /// Request lates transaction list
    func requestLatestTransactionList() {
        budAPI.getTransactionList { [weak self] (transactionListResponse, error) in
            if let transactionListResponse = transactionListResponse {
                self?.transactionList = transactionListResponse.data
                self?.transactionListTitle = "All transactions (\(transactionListResponse.data.count))"
                NotificationCenter.default.post(name: TransactionManager.transactionListUpdateNotification, object: self?.transactionList)
                return
            }
            NotificationCenter.default.post(name: TransactionManager.transactionListUpdateNotification, object: error ?? BudAPIErrors.responseDataIsNil)
        }
    }
}
