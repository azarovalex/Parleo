//
//  LanguagePickerViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 5/8/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class LanguagePickerViewModel: ViewModelType {

    private let cellsRelay = BehaviorRelay<[Language]>(value: [])
    private let selectedLanguages = BehaviorRelay<[Language]>(value: [Language(code: "gb", level: .advanced)])

    struct Input {
        let searchQuery: Driver<String>
        let selectionChanges: Signal<(Language, LanguageLevel?)>
    }

    struct Output {
        let cells: Driver<[Language]>
        let isLoading: Driver<Bool>
        let error: Signal<Error>
        let reloadAction: CocoaAction
    }

    func transform(input: Input) -> Output {
        let reloadAction = getReloadAction()
        reloadAction.execute()

        let filteredCells = Driver.combineLatest(input.searchQuery, cellsRelay.asDriver()) { query, cells in
            query == "" ? cells : cells.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
        return Output(cells: filteredCells,
                      isLoading: reloadAction.executingDriver,
                      error: reloadAction.errorSignal,
                      reloadAction: reloadAction)
    }
}

// MARK: - Private
private extension LanguagePickerViewModel {

    func getReloadAction() -> CocoaAction {
        let utilitiesService = UtilitiesService()
        return CocoaAction(workFactory: {
            unwrapResult(utilitiesService.getLanguages())
                .map { [unowned self] cells in self.cellsRelay.accept(cells) }
        })
    }
}
