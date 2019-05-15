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

    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
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
        openSearchButton.tintColor = UIColor.black.withAlphaComponent(0.8)
        adapter.collectionView = collectionView
        adapter.dataSource = self
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

extension ListOfChatsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            ListOfChatsCellModel(dialogTitle: "Tedik Tanki, 19", unreadMessages: 1)
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let configurationBlock = { (item: Any, cell: UICollectionViewCell) in
            guard let cell = cell as? ListOfChatsCell, let model = item as? ListOfChatsCellModel else { return }
            cell.configure(with: model)
        }
        let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in CGSize(width: context!.containerSize.width, height: 110) }
        let sectionController = ListSingleSectionController(nibName: R.nib.listOfChatsCell.name, bundle: R.nib.listOfChatsCell.bundle,
                                                            configureBlock: configurationBlock, sizeBlock: sizeBlock)
        sectionController.selectionDelegate = self
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel()
        label.text = "No messages!"
        return label
    }
}

// MARK: - ListSingleSectionControllerDelegate
extension ListOfChatsViewController: ListSingleSectionControllerDelegate {

    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {

    }
}
