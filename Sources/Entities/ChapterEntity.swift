//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

struct ChapterEntity: Codable {
    let id: String
    let title: String
    let sentences: [SentenceEntity]
}
