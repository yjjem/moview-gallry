//
//  Review.swift
//  remy-movie
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct Review: Decodable {
    let author: String?
    let authorDetails: AuthorDetails?
    let contents: String?
    let createdAt: Date?
    let id: Int?
    let updatedAt: Date?
    let url: String?
}

struct AuthorDetails: Decodable {
    let name: String?
    let userName: String?
    let avatarPath: String?
    let rating: Int?
}