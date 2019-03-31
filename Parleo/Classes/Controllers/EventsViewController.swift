//
//  EventsViewController.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class EventsViewController: UIViewController {
    @IBOutlet private var eventsSegmentControl: UISegmentedControl!
    @IBOutlet private var filterBarButton: UIBarButtonItem!
    @IBOutlet private var addEventBarButton: UIBarButtonItem!
    @IBOutlet private var eventsTableView: UITableView! {
        didSet {
            eventsTableView.register(R.nib.eventTableViewCell)
        }
    }
    
    private let viewModel = EventsViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        let input = EventsViewModel.Input(addEvent: addEventBarButton.rx.tap.asSignal(),
                                          viewEvent: eventsTableView.rx.itemSelected.asSignal(),
                                          filter: filterBarButton.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)
        
        output.cells.drive(eventsTableView.rx.items) { [weak self] _, index, model in
            guard let cell = self?.eventsTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.eventTableViewCell, for: IndexPath(row: index, section: 0)) else {
                return UITableViewCell()
            }
            return cell
            }
        .disposed(by: disposeBag)
        
        output.addEvent.emit(onNext: { [weak self] in
            self?.performSegue(withIdentifier: R.segue.eventsViewController.eventsToAddEvent, sender: self)
        }).disposed(by: disposeBag)
    }
}
