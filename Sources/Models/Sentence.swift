//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

/// 節(文章)
class Sentence {
    
    /// ID
    var id: String!
    
    /// 節(文章)名
    var name: String!
    
    /// ソート番号
    var sort: Int!
    
    /// 親となる章
    weak var chapter: Chapter!
}
