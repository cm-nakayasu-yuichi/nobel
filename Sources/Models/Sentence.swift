//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class Sentence {
        
    /// ID
    var id: String!
    
    /// 節(文章)のタイトル
    var title: String!
    
    /// 親となる章
    weak var chapter: Chapter!
}
