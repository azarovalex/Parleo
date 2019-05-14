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

protocol FilterViewControllerDelegate {
    func updateFilter(filter: UsersFilter)
}

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

    var delegate: FilterViewControllerDelegate!
    var filter: UsersFilter!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    @IBAction func save(_ sender: Any) {
        guard filter.isFemale || filter.isMale else {
            show(error: SimpleError(message: "Choose at lease one gender"))
            return
        }
        delegate.updateFilter(filter: filter)
        navigationController?.popViewController(animated: true)
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
        case is CheckboxCellModel:
            let controller = CheckboxSectionController()
            controller.filter = filter
            controller.updateClosure = { [weak self] isMale, isFemale in
                guard let self = self else { return }
                self.filter.isFemale = isFemale
                self.filter.isMale = isMale
            }
            return controller
        case is SliderCellModel:
            let controller = SliderSectionController()
            controller.updateClosure = { [weak self] minAge, maxAge in
                guard let self = self else { return }
                self.filter.minAge = minAge
                self.filter.maxAge = maxAge
            }
            controller.filter = filter
            return controller
        default:
            let controller = LanguagePickerSectionController()
            controller.filter = filter
            controller.updateClosure = { [weak self] languages in
                guard let self = self else { return }
                self.filter.languages = languages
            }
            return controller
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}
