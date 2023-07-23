//
//  Model.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
