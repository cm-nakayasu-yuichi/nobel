//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class Chapter {
    
    /// ID
    var id: String!
    
    /// 章のタイトル
    var title: String!
    
    /// 節(文章)の配列
    var sentences: [Sentence]!
    
    /// 親となる書籍
    weak var book: Book!
}
