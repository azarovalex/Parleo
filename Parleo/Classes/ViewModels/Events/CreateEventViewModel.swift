//
//  CreateEventViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 5/13/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift

class CreateEventViewModel: ViewModelType {
    struct Input {
        let imageRelay: BehaviorRelay<UIImage?>
        let titleObservable: Observable<String?>
        let descriptionObservable: Observable<String?>
//        let iviteFriendsButtonClickedObservable: Ob
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
