//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 書籍
class Book {
    
    /// ID
    var id: String!
    
    /// 作品名
    var name: String!
    
    /// 作者名
    var author: String!
    
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
    
    /// ソート番号
    var sort: Int!
    
    /// 章リスト
    var chapters: [Chapter]!
}
