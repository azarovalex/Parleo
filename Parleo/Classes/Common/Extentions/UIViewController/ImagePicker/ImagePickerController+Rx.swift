//
//  ImagePickerController+Rx.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

class RxUIImagePickerControllerDelegateProxy: DelegateProxy<UIImagePickerController, ImagePickerDelegate>, DelegateProxyType, ImagePickerDelegate {

    static func currentDelegate(for object: UIImagePickerController) -> ImagePickerDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: ImagePickerDelegate?, to object: UIImagePickerController) {
        object.delegate = delegate
    }

    weak private(set) var imagePicker: UIImagePickerController?

    init(imagePicker: ParentObject) {
        self.imagePicker = imagePicker
        super.init(parentObject: imagePicker, delegateProxy: RxUIImagePickerControllerDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxUIImagePickerControllerDelegateProxy(imagePicker: $0) }
    }
}

extension Reactive where Base: UIImagePickerController {

    var delegate: DelegateProxy<UIImagePickerController, ImagePickerDelegate> {
        return RxUIImagePickerControllerDelegateProxy.proxy(for: base)
    }

    var didFinishPickingMedia: Observable<[String: Any]?> {
        let selector = #selector(ImagePickerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        let delegate: DelegateProxy<UIImagePickerController, ImagePickerDelegate> = self.delegate
        return delegate.methodInvoked(selector)
            .do(onNext: { parameters in
                (parameters[0] as? UIImagePickerController)?.dismiss(animated: true)
            })
            .map { parameters in
                return parameters[1] as? [String: Any]
        }
    }

    var didFinishPickingImage: Observable<UIImage?> {
        let key: UIImagePickerController.InfoKey = base.allowsEditing ? .editedImage : .originalImage
        return didFinishPickingMedia.unwrap().map { info in info[key.rawValue] as? UIImage }
    }
}
