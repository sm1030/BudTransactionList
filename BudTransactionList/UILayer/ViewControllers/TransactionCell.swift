//
//  TransactionCell.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productImageActivityIndicator: UIActivityIndicatorView!
    
    var observingImageNotification = false
    var productImageURL: String?
    
    let productImageTargetSize = CGSize(width: 100, height: 100)
    
    var transaction: BudAPITransaction? {
        didSet {
            
            /// Set text data
            descriptionLabel.text = transaction?.description
            dateLabel.text = transaction?.date?.budDateString
            categoryLabel.text = transaction?.categoryId == nil ? "None" : "\(transaction!.categoryId!)"
            amountLabel.text = String(format: "%.2f %@", transaction?.amount?.value ?? 0, transaction?.amount?.currencyIso ?? String())
            productTitleLabel.text = transaction?.product?.title
            
            /// Request image
            if let imageURL = transaction?.product?.icon {
                subscribeForImageUpdatesIfNeeded()
                productImageActivityIndicator.startAnimating()
                productImageURL = imageURL
                _ = CacheAPI.shared.requestImage(imageURL: imageURL, targetSize: productImageTargetSize)
            } else {
                productImageView.image = #imageLiteral(resourceName: "NoImageAvailable")
            }
        }
    }
    
    /**
     Cancel image request
     */
    override func prepareForReuse() {
        productImageURL = nil
        productImageView.image = nil
    }
    
    /**
     This will handle image update notification
     */
    func subscribeForImageUpdatesIfNeeded() {
        if observingImageNotification == false {
            observingImageNotification = true
            NotificationCenter.default.addObserver(forName: CacheAPI.imageNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
                if let imageResponse = notification.object as? CacheAPIImageResponse {
                    if let requestedImageURL = self?.productImageURL, requestedImageURL == imageResponse.imageURL {
                        self?.productImageActivityIndicator.stopAnimating()
                        if let image = imageResponse.image {
                            self?.productImageView?.image = image
                        }
                    }
                }
            }
        }
    }
    
    /**
     Unsubscribing from notifications
     */
    deinit {
        observingImageNotification = false
        NotificationCenter.default.removeObserver(self)
    }
}
