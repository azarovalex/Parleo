//
//  NetworkExtension.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import ObjectMapper

struct NetworkError: AppError {

    var message: String

    init(message: String) {
        self.message = message
    }

    init(response: Response) {
        self.init(message: "Failed to map data to JSON. JSON: \((try? response.mapString()) ?? "")")
    }
}

enum ServiceMockType {
    case immediate, delayed(TimeInterval), none
}

enum Result<Value> {
    case success(Value)
    case failure(Error)

    var value: Value? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    var error: Error? {
        guard case .failure(let error) = self else { return nil }
        return error
    }

    func nulify() -> Result<Void> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            return .success(())
        }
    }
}

extension Array where Element: BaseMappable {

    init?(response: Response) {
        guard let json = try? response.mapJSON() as? [[String: Any]], let unwrappedData = json else { return nil }
        self.init(JSONArray: unwrappedData)
    }
}

extension Mappable {

    init?(response: Response) {
        guard let json = response.json else { return nil }
        self.init(JSON: json)
    }
}

extension BaseMappable {

    init?(response: Response) {
        guard let json = response.json else { return nil }
        self.init(JSON: json)
    }
}

extension Response {

    var json: [String: Any]? {
        return (try? mapJSON()) as? [String: Any]
    }
}

