//
//  LanguagePickerViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 5/8/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

protocol LanguagePickerDelegate {
    func updateSelectedLanguages(with languages: [Language])
}

class LanguagePickerViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var doneButton: RoundedButton!
    @IBOutlet private var searchBar: RoundedTextField!

    private let selectedLanguages = BehaviorRelay<[Language]>(value: [])
    private let selectionChangesRelay = PublishRelay<(Language, LanguageLevel?)>()
    private let viewModel = LanguagePickerViewModel()
    private let bag = DisposeBag()

    var delegate: LanguagePickerDelegate?

    func setInitial(_ languages: [Language]) {
        selectedLanguages.accept(languages)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension LanguagePickerViewController {

    func setup() {
        tableView.register(R.nib.languageInPickerCell)
        bindViewModel()
        setupSearchBar()
        doneButton.rx.tap.asSignal()
            .emit(onNext: { [unowned self] in
                self.delegate?.updateSelectedLanguages(with: self.selectedLanguages.value)
                self.dismiss(animated: true) })
            .disposed(by: bag)
    }

    func bindViewModel() {
        let output = viewModel.transform(input:
            LanguagePickerViewModel.Input(searchQuery: searchBar.textDriver,
                                          selectionChanges: selectionChangesRelay.asSignal()))

        output.error.emit(to: rx.error).disposed(by: bag)
        output.isLoading.drive(rx.isLoading).disposed(by: bag)
        output.cells.drive(tableView.rx.items) { [unowned self] tableView, row, language in
            return self.getLanugageCell(tableView, row: row, language: language)
        }.disposed(by: bag)
    }

    func setupSearchBar() {
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 50))
        searchBar.leftViewMode = .always
    }
}

// MARK: - Private
private extension LanguagePickerViewController {

    func getLanugageCell(_ tableView: UITableView, row: Int, language: Language) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.languageInPickerCell,
                                                 for: IndexPath(row: row, section: 0))!
        let isSelected: Bool
        let cellLanguage: Language
        if let selectedLanguage = self.selectedLanguages.value.first(where: { $0.code == language.code }) {
            isSelected = true
            cellLanguage = selectedLanguage
        } else {
            isSelected = false
            cellLanguage = language
        }
        cell.configure(with: cellLanguage, isSelected: isSelected, stateChangedClosure: { [unowned self] lang, level in
            var selectedLanguages = self.selectedLanguages.value
            selectedLanguages.removeAll(where: { $0.code == lang.code })
            if let selectedLevel = level {
                selectedLanguages.append(Language(code: lang.code, level: selectedLevel))
            }
            self.selectedLanguages.accept(selectedLanguages)
            print(selectedLanguages)
        })
        return cell
    }
}
