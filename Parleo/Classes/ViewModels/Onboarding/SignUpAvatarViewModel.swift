//
//  SignUpAvatarViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import CoreLocation

class SignUpAvatarViewModel: ViewModelType {

    private let locationManager = CLLocationManager()
    private let navigationRelay = PublishRelay<Void>()
    private let userService = UserService()
    private let bag = DisposeBag()

    struct Input {
        let avatarImage: Driver<UIImage?>
        let nextTap: Signal<Void>
    }

    struct Output {
        let registerAction: CocoaAction
        let isLoading: Driver<Bool>
        let errors: Signal<Error>
        let navigate: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let action = getRegistrationAction(image: input.avatarImage)
        input.nextTap.emit(to: action.inputs).disposed(by: bag)
        return Output(registerAction: action,
                      isLoading: action.executing.asDriver { _ in .never() },
                      errors: action.underlyingError.asSignal { _ in .never() },
                      navigate: navigationRelay.asSignal())
    }
}

// MARK: - Private
private extension SignUpAvatarViewModel {

    func getRegistrationAction(image: Driver<UIImage?>) -> CocoaAction {
        return CocoaAction { [unowned self] in
            return image.asObservable().flatMap { image -> Observable<Void> in
                guard let image = image else { self.navigationRelay.accept(()); return .just(()) }
                return unwrapResult(self.userService.uploadImage(image: image))
                    .do(onNext: { [unowned self] in self.navigationRelay.accept(()) })
            }.take(1)
        }
    }
}
