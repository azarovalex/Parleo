//
//  UIViewController+ImagePicker.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices

extension Reactive where Base: UIViewController {

    func pickImage(title: String, allowsEditing: Bool) -> Observable<UIImage?> {
        return base.showImageActionSheet(title: title, allowsEditing: allowsEditing).asObservable()
            .do(onNext: { self.base.present($0, animated: true) })
            .flatMap { result in result.rx.didFinishPickingImage }
    }
}

extension UIViewController {

    enum ImagePickerActionTypes: Equatable {
        case camera, photoLibrary
    }

    private func getImagePicker(for type: UIImagePickerController.SourceType, allowsEditing: Bool) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.sourceType = type
        imagePicker.allowsEditing = allowsEditing
        return imagePicker
    }

    fileprivate func showImageActionSheet(title: String, allowsEditing: Bool) -> Single<UIImagePickerController> {
        return Single.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                guard let picker = self?.getImagePicker(for: .camera, allowsEditing: allowsEditing) else { return }
                observer(.success(picker))
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
                guard let picker = self?.getImagePicker(for: .photoLibrary, allowsEditing: allowsEditing) else { return }
                observer(.success(picker))
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
            return Disposables.create()
        }
    }
}


