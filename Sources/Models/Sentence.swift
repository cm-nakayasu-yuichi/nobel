//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class Sentence {
    /// ID
    var id = ""
    
    /// 節(文章)名
    var name = "第一幕 新しい文章"
    
    /// 親となる章
    weak var parentChapter: Chapter!
}
