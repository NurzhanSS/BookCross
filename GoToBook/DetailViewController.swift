//
//  DetailViewController.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 01.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var bookImageView: UIImageView!

    var detailBook: Book? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailBook = detailBook{
            if let detailDescriptionLabel = detailDescriptionLabel, bookImageView = bookImageView {
                detailDescriptionLabel.text = detailBook.name
                bookImageView.image = UIImage(named: detailBook.name)
                title = detailBook.category
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
