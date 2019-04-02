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
            tableView.allowsMultipleSelection = true
        }
    }
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.Font.title
            titleLabel.textColor = R.color.black()?.withAlphaComponent(0.5)
        }
    }
    @IBOutlet private var searchTextField: SearchTextField!
    @IBOutlet private var doneButton: RoundedButton! {
        didSet {
            doneButton.roundAllCornersWithMaximumRadius()
            doneButton.backgroundColor = R.color.blue()
            doneButton.setTitleColor(R.color.white(), for: .normal)
        }
    }
    @IBOutlet var containerScrollView: UIScrollView!
    
    var viewModel = ItemsListViewModel(title: "title", items: [], selectedItems: [])
    
    override func bindData() {
        
        
        
        let input = ItemsListViewModel.Input(offsetDriver: containerScrollView.rx.contentOffset.asDriver(),
                                             saveSignal: doneButton.rx.tap.asSignal(),
                                             filterDriver: searchTextField.rx.text.orEmpty.asDriver(),
                                             selectedDriver: tableView.rx.itemSelected.asDriver(),
                                             deselectedDriver: tableView.rx.itemDeselected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.cellsDriver
            .drive(tableView.rx.items) { [weak self] _, index, cellViewModel in
                guard let cell = self?.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemsListTableCell,
                                                                     for: IndexPath(row: index, section: 0)) else {
                                                                        return UITableViewCell()
                                                                     }
                cell.viewModel = cellViewModel
                return cell
            }
            .disposed(by: disposeBag)
                
        output.dissmissSignal
            .emit(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
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
