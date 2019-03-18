//
//  ItemsListViewController.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class ItemsListViewController: ViewController {
    // MARK: IBOutlets
    
    @IBOutlet private var tableView: UnscrolableTableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.register(R.nib.itemsListTableCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.Font.title
            titleLabel.textColor = R.color.black()?.withAlphaComponent(0.5)
            titleLabel.text = "Items"
        }
    }
    @IBOutlet private var searchTextField: UITextField! {
        didSet {
            let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: searchTextField.bounds.height))
            UIImageView(image: R.image.searchIcon()).addToView(leftViewContainer, top: 13, bottom: -13, left: 20, right: -8)
            searchTextField.leftView = leftViewContainer
            searchTextField.leftViewMode = .always
            searchTextField.font = Constants.Font.default
            searchTextField.textColor = R.color.black()
            searchTextField.backgroundColor = R.color.black()?.withAlphaComponent(0.05)
            searchTextField.placeholder = "placeholder"
        }
    }
    @IBOutlet private var doneButton: RoundedButton!
    
    private var containerScrollView: UIScrollView? {
        return tableView.superview as? UIScrollView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerScrollView?.delegate = self
    }
    
    override func bindData() {
        
    }
}

extension ItemsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "text"
        return cell
    }
}

extension ItemsListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            print(scrollView.contentOffset.y)
        }
    }
}

extension ItemsListViewController {
    enum Constants {
        enum Font {
            static let title = R.font.montserratRegular(size: 18)
            static let `default` = R.font.montserratRegular(size: 14)
        }
    }
}
