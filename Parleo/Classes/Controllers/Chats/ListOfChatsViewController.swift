//
//  ListOfChatsViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import IGListKit

class ListOfChatsViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!

    private lazy var openSearchButton = UIBarButtonItem(image: R.image.searchNavBarIcon()!, style: .plain, target: self, action: #selector(openSearch))
    private lazy var closeSearchButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeSearch))

    private let searchBar = UISearchBar()
    private var isSearchOpened = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension ListOfChatsViewController {

    func setup() {
        navigationItem.rightBarButtonItem = openSearchButton
    }
}

// MARK: - Search
private extension ListOfChatsViewController {

    @objc func openSearch() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = closeSearchButton
        searchBar.becomeFirstResponder()
    }

    @objc func closeSearch() {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = openSearchButton
        searchBar.resignFirstResponder()
    }
}
