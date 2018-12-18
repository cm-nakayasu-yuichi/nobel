//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class Chapter {
    
    /// 章の名前
    var name = "第一章 新しい章"
    
    /// 節(文章)の配列
    var sentences = [Sentence]()
    
    /// 親となる書籍
    weak var parentBook: Book!
}
