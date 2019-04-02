//
//  FilterViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/23/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IGListKit

class FilterViewController: UIViewController {

    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)

    enum ScreenConfiguration {
        case filterUsers
        case filterEvents

        var cells: [ListDiffable] {
            switch self {
            case .filterEvents:
                return [
                    CheckboxCellModel(title: "Number of members", items: ["2", "3+"]),
                    SliderCellModel(title: "Distance from me (km)", minValue: 0, maxValue: 50, step: 1),
                    LanguagePickerModel(languages: [])
                ]
            case .filterUsers:
                return [
                    CheckboxCellModel(title: "Gender", items: ["Female", "Male"]),
                    SliderCellModel(title: "Age", minValue: 16, maxValue: 65, step: 1),
                    LanguagePickerModel(languages: [])
                ]
            }
        }
    }

    @IBOutlet private var collectionView: UICollectionView!

    var screenConfiguration: ScreenConfiguration!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension FilterViewController {

    func setup() {
        adapter.collectionView = collectionView
        adapter.dataSource = self

    }
}

// MARK: - ListAdapterDataSource
extension FilterViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return screenConfiguration.cells
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is CheckboxCellModel: return CheckboxSectionController()
        case is SliderCellModel: return SliderSectionController()
        default: return LanguagePickerSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}
