//
//  TransactionListViewController.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

class TransactionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var transactionManager = TransactionManager.shared
    
    /// The transaction list currently presented by the tableView
    var transactionList: [BudAPITransaction]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /// Register obesrver for the TransactionManager.transactionListUpdateNotification
        NotificationCenter.default.addObserver(forName: TransactionManager.transactionListUpdateNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            if let transactionList = notification.object as? [BudAPITransaction] {
                self?.transactionList = transactionList
                self?.navigationItem.title = self?.transactionManager.transactionListTitle
                self?.tableView.reloadData()
            } else if let _ = notification.object as? Error {
                let alertController = UIAlertController(title: "Error", message: "Can't get transaction data. Please try again later", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// This event happen when view will apper on the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// We will request the latest transaction list each time we present this View Controller to the user
        transactionManager.requestLatestTransactionList()
    }

}

extension TransactionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let transactionCell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell {
            if let transactionList = transactionList, indexPath.row < transactionList.count {
                transactionCell.transaction = transactionList[indexPath.row]
            }
            return transactionCell
        } else {
            return UITableViewCell()
        }
    }
}
