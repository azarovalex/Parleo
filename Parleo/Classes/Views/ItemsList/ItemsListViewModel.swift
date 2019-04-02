//
//  ItemsListViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ItemsListComformable: StringRepresentable, ImageRepresentable { }

class ItemsListViewModel: ViewModelType {
    private let cellViewModels: BehaviorRelay<[ItemsListTableCellViewModel]>
    private let title: BehaviorRelay<String>
    private let items: BehaviorRelay<[ItemsListComformable]>
    private var selectedItems = [ItemsListComformable]()
    
    var saveSelectedClosure: VoidClosure?
    
    struct Input {
        let offsetDriver: Driver<CGPoint>
        let saveSignal: Signal<Void>
        let filterDriver: Driver<String>
        let selectedDriver: Driver<IndexPath>
        let deselectedDriver: Driver<IndexPath>
    }
    
    struct Output {
        let titleDriver: Driver<String>
        let cellsDriver: Driver<[ItemsListTableCellViewModel]>
        let dissmissSignal: Signal<Void>
    }
    
    struct Test: ItemsListComformable {
        var text: String
        
        var image: UIImage
    }
    
    var disposeBag = DisposeBag()
    
    init(title: String, items: [ItemsListComformable], selectedItems: [ItemsListComformable]) {
        let tempItems = [Test(text: "asdf", image: UIImage()),
                         Test(text: "qwer", image: UIImage()),
                         Test(text: "zxvc", image: UIImage()),
                         Test(text: "tyui", image: UIImage()),
                         Test(text: "ghjk", image: UIImage())]
        
        self.items = BehaviorRelay(value: tempItems)
        self.cellViewModels = BehaviorRelay(value: [])
        
        self.title = BehaviorRelay(value: title)
        
        self.cellViewModels.accept(self.getCellViewModels(from: tempItems))
    }
    
    func transform(input: Input) -> Output {
        let closeSignal = input.offsetDriver
            .flatMap { offset -> SharedSequence<SignalSharingStrategy, Void> in
                offset.y < Constants.dismissContentOffset ? Signal.just({}()) : Signal.never()
            }.asSignal()
        
        let saveSignal = input.saveSignal.do(onNext: saveSelectedClosure ?? {})
        
        items.asDriver()
            .drive(onNext: { [weak self] items in
                self?.cellViewModels.accept(self?.getCellViewModels(from: items) ?? [])
            })
            .disposed(by: disposeBag)
        
        input.selectedDriver
            .drive(onNext: { [weak self] indexPath in
                guard let self = self, let item = self.items.value.first(where: { $0.text == self.cellViewModels.value[indexPath.row].title }) else {
                    return
                }
                self.selectedItems.append(item)
            })
            .disposed(by: disposeBag)
        
//        input.deselectedDriver.drive(onNext: {
//            
//        })
        
        input.filterDriver
            .drive(onNext: { [weak self] filter in
                guard let self = self else { return }

                let filteredItems = filter.isEmpty ? self.items.value : self.items.value.filter{ $0.text.contains(filter)}
                self.cellViewModels.accept(self.getCellViewModels(from: filteredItems))
            })
            .disposed(by: disposeBag)
        
        return Output(titleDriver: title.asDriver(),
                      cellsDriver: cellViewModels.asDriver(),
                      dissmissSignal: Signal.merge(saveSignal, closeSignal))
    }
    
    private func getCellViewModels(from items: [ItemsListComformable]) -> [ItemsListTableCellViewModel] {
        return items.map { item in
            ItemsListTableCellViewModel(title: item.text,
                                        image: item.image,
                                        isSelected: selectedItems.contains { $0.text == item.text })
        }
    }
}

private extension ItemsListViewModel {
    enum Constants {
        static let dismissContentOffset: CGFloat = -100
    }
}
