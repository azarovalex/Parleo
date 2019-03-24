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

class FilterViewController: UIViewController {

    enum CellType {
        case checkboxes(model: CheckboxCellModel)
        case rangeSlider(model: SliderCellModel)
        case languagePicker
    }

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension FilterViewController {

    func setup() {
        tableView.register(R.nib.checkboxesCell)
        tableView.register(R.nib.sliderCell)
        Driver<[CellType]>.just([
            .checkboxes(model: CheckboxCellModel(title: "Gender", items: ["Male", "Female", "Apache Helicopter"])),
            .rangeSlider(model: SliderCellModel(title: "Age", minValue: 16, maxValue: 65, step: 1))
            ]).drive(tableView.rx.items) { _, row, cellType in
                switch cellType {
                case .checkboxes(let model):
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.checkboxesCell, for: IndexPath(row: row, section: 0))!
                    cell.configure(with: model)
                    return cell
                case .rangeSlider(let model):
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sliderCell, for: IndexPath(row: row, section: 0))!
                    cell.configure(with: model)
                    return cell
                default:
                    return UITableViewCell()
                }
        }
    }
}
