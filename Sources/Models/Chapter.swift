//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

// 章
class Chapter {
    
    /// ID
    var id: String!
    
    /// 章の名前
    var name: String!
    
    /// ソート番号
    var sort: Int!
    
    /// 節(文章)の配列
    var sentences = [Sentence]()
    
    /// 親となる書籍
    weak var book: Book?
}
