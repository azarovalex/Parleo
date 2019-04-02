//
//  EventsViewController.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import SegueManager

class EventsViewController: SegueManagerViewController {

    @IBOutlet private var filterBarButton: UIBarButtonItem!
    @IBOutlet private var addEventBarButton: UIBarButtonItem!
    @IBOutlet private var eventsTableView: UITableView! {
        didSet {
            eventsTableView.register(R.nib.eventTableViewCell)
        }
    }
    
    private let viewModel = EventsViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        let input = EventsViewModel.Input(viewEvent: eventsTableView.rx.itemSelected.asSignal())
        
        let output = viewModel.transform(input: input)
        
        output.cells.drive(eventsTableView.rx.items) { [weak self] _, index, model in
            guard let cell = self?.eventsTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.eventTableViewCell, for: IndexPath(row: index, section: 0)) else {
                return UITableViewCell()
            }
            cell.viewModel = model
            return cell
            }
        .disposed(by: bag)

        eventsTableView.rx.modelSelected(EventTableCellViewModel.self)
            .bind(to: rx.navigate(with: R.segue.eventsViewController.fromEventsToDetails))
            .disposed(by: bag)

        filterBarButton.rx.tap
            .bind(to: rx.navigate(with: R.segue.eventsViewController.fromEventsToFilter,
                                                    segueHandler: { segue, _ in segue.destination.screenConfiguration = .filterEvents }))
            .disposed(by: bag)
    }
}
