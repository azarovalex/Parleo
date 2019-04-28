//
//  ParleoEvent.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/21/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation

struct ParleoEvent {
    let id: UUID
    let title: String
    let description: String
    let participants: [UUID]
    let startTime: Date
    let endTime: Date
    let creatorId: UUID
    let languageId: UUID
}
