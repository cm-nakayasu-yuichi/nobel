//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

struct BookEntity: Codable {
    let id: String
    let title: String
    let author: String
    let outlineTitle: String
    let outline: String
    let bookmarkedChapterIndex: Int
    let bookmarkedPageIndex: Int
    let isLocked: Bool
    let colorTheme: Int
    let textSize: Int
    let fontType: Int
}
