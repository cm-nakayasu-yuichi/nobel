//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ShelfBook {
    
    /// ID
    var id: String!
    
    /// 作品タイトル
    var title: String!
    
    /// 作者名
    var author: String!
}

class Book: ShelfBook {
    
    /// あらすじタイトル
    var outlineTitle: String!
    
    /// あらすじ
    var outline: String!
    
    /// しおりをしたチャプタのインデックス
    var bookmarkedChapterIndex: Int!
    
    /// しおりをしたページのインデックス
    var bookmarkedPageIndex: Int!
    
    /// 編集不可かどうか
    var isLocked: Bool!
    
    /// カラーテーマ
    var colorTheme: ColorTheme!
    
    /// 文字サイズ
    var textSize: TextSize!
    
    /// フォント
    var fontType: FontType!
    
    /// 章リスト
    var chapters: [Chapter]!
}
