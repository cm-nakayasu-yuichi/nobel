//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class Book {
    
    /// ID
    var id = ""
    
    /// 作品名
    var name = "新しい作品"
    
    /// 作者名
    var author = ""
    
    /// あらすじタイトル
    var outlineTitle = ""
    
    /// あらすじ
    var outline = ""
    
    /// しおりをしたチャプタのインデックス
    var bookmarkedChapterIndex = 0
    
    /// しおりをしたページのインデックス
    var bookmarkedPageIndex = 0
    
    /// 編集不可かどうか
    var isLocked = false
    
    /// カラーテーマ
    var colorTheme = ColorTheme.standard
    
    /// 文字サイズ
    var textSize = TextSize.standard
    
    /// フォント
    var fontType = FontType.standard
    
    /// 章リスト
    var chapters = [Chapter]()
}
