/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit
import CoreText

/// 縦書文章を表示するビュー
class VerticalView: UIView {
    
    /// 全体文字列
    var text = ""
    
    /// 縦書表示設定オプション
    var options = VerticalViewOptions()
    
    /// レンダリングを行うかどうか
    var isRendering = true
    
    /// 文字列解析から描画までを行った時に呼ばれる
    var analyzed: (() -> ())?
    
    /// ビューに表示されている文字列
    private(set) var visibleText = ""
    
    /// ビューに表示されている文字列の属性付与前の原文
    private(set) var visibleRawText = ""
    
    /// ビューに表示されている文字列数
    private(set) var visibleLength = 0
    
    /// ビューに表示されている文字列の属性付与前の原文文字列数
    private(set) var visibleRawLength = 0
    
    private var rawOffset = 0
    private var rawAttrRanges = [NSRange]()
    private var dstOffset = 0
    private var dstAttrRanges = [NSRange]()
    
    // MARK: - 描画
    
    override func draw(_ rect: CGRect) {
        self.reset()
        let attributed = self.createAttributedString(string: self.text)
        self.visibleLength = self.render(attributed, rect)
        self.calculate()
        self.analyzed?()
        self.analyzed = nil
    }
    
    /// 各値のリセット
    private func reset() {
        self.rawOffset = 0
        self.rawAttrRanges = [NSRange]()
        self.dstOffset = 0
        self.dstAttrRanges = [NSRange]()
        self.visibleText = ""
        self.visibleRawText = ""
        self.visibleLength = 0
        self.visibleRawLength = 0
    }
    
    // MARK: - 文字列解析
    
    /// 文字列を解析して属性付文字列を生成する
    /// - parameter text: 対象の文字列
    /// - returns: 属性付文字列
    private func createAttributedString(string: String) -> NSMutableAttributedString {
        return self.separate(string)
            .map { v -> NSMutableAttributedString in
                let ret = NSMutableAttributedString(string: v, attributes: nil)
                self.addAttribute(attributed: ret)
                self.updateOffsetAndRanges(rawString: v, dstString: ret.string)
                return ret
            }
            .reduce(NSMutableAttributedString()) { $0.append($1); return $0 }
    }
    
    /// 属性付文字列の生成のために文字列を分割する
    /// - parameter string: 対象の文字列
    /// - returns: 分割された文字列配列
    private func separate(_ string: String) -> [String] {
        var ret = [string]
        ret = self.separateForRubyPattern(ret)
        ret = self.separateForCenteringPattern(ret)
        ret = self.separateForLinePattern(ret)
        return ret
    }
    
    /// ルビ振り属性設定のために文字列を分割する
    /// - parameter strings: 対象の文字列配列
    /// - returns: ルビ振り用に分割した文字列配列
    private func separateForRubyPattern(_ strings: [String]) -> [String] {
        return self.separate(pattern: "(｜.+?《.+?》)", strings)
    }
    
    /// センタリングのために文字列を分割する
    /// - parameter strings: 対象の文字列配列
    /// - returns: ルビ振り用に分割した文字列配列
    private func separateForCenteringPattern(_ strings: [String]) -> [String] {
        return self.separate(pattern: "(｜＊.+?＊｜)", strings)
    }
    
    /// 文章線のために文字列を分割する
    /// - parameter strings: 対象の文字列配列
    /// - returns: ルビ振り用に分割した文字列配列
    private func separateForLinePattern(_ strings: [String]) -> [String] {
        return self.separate(pattern: "(---+)", strings)
    }
    
    /// 文字列配列を指定したパターンで更に分割する
    /// - parameter strings: 対象の文字列配列
    /// - returns: 分割された文字列配列
    private func separate(pattern: String, _ strings: [String]) -> [String] {
        let sp = "@+@"
        var ret = [String]()
        for string in strings {
            let array = self.replace(string, pattern: pattern, template: sp + "$1" + sp).components(separatedBy: sp)
            ret.append(contentsOf: array)
        }
        return ret
    }
    
    // MARK: - レンダリング
    
    /// 属性付文字列に各属性を追加する
    /// - parameter attributed: 対象の属性付文字列
    /// - returns: 各属性を追加した属性付文字列
    private func addAttribute(attributed: NSMutableAttributedString) {
        
        // ルビ振り
        if let rubyResult = self.find(attributed.string, pattern: "｜(.+?)《(.+?)》") {
            let string = attributed.string.ns.substring(with: rubyResult.range(at: 1))
            let ruby   = attributed.string.ns.substring(with: rubyResult.range(at: 2))
            
            self.replace(attributed: attributed, string: string)
            
            self.addBasicAttribute(to: attributed)
            
            let annotation = self.createRubyAnnotation(ruby)
            attributed.addAttribute(NSAttributedString.Key(rawValue: kCTRubyAnnotationAttributeName as String as String), value: annotation, range: self.range(attributed))
        }
            // センター寄せ
        else if let centeringResult = self.find(attributed.string, pattern: "｜＊(.+?)＊｜") {
            let string = attributed.string.ns.substring(with: centeringResult.range(at: 1))
            
            self.replace(attributed: attributed, string: string)
            self.addBasicAttribute(to: attributed, centering: true)
        }
            // 文章線
        else if let _ = self.find(attributed.string, pattern: "---+") {
            self.addBasicAttribute(to: attributed)
            let additionalAttributes: [NSAttributedString.Key : Any] = [
                .underlineStyle: CTUnderlineStyle.single.rawValue,
                .underlineColor: self.options.textColor.cgColor,
                .foregroundColor: self.options.backgroundColor.cgColor,
            ]
            attributed.addAttributes(additionalAttributes, range: self.range(attributed))
        }
            // その他すべて
        else {
            self.addBasicAttribute(to: attributed)
        }
    }
    
    private func updateOffsetAndRanges(rawString: String, dstString: String) {
        let rawLength = rawString.count
        let dstLength = dstString.count
        
        if rawLength != dstLength {
            let rawAttrRange = NSMakeRange(self.rawOffset, rawLength)
            self.rawAttrRanges.append(rawAttrRange)
            
            let dstAttrRange = NSMakeRange(self.dstOffset, dstLength)
            self.dstAttrRanges.append(dstAttrRange)
        }
        
        self.rawOffset += rawLength
        self.dstOffset += dstLength
        
        self.visibleText += dstString
    }
    
    /// 共通の属性を追加する
    /// - parameter attributed: 属性付文字列
    /// - parameter centering: 中央寄せするかどうか
    private func addBasicAttribute(to attributed: NSMutableAttributedString, centering: Bool = false) {
        var settings = [CTParagraphStyleSetting]()
        
        if centering {
            var alignCenter = CTTextAlignment.center
            let valueSize = MemoryLayout<CTTextAlignment>.size(ofValue: alignCenter)
            settings.append(CTParagraphStyleSetting(spec: .alignment, valueSize: valueSize, value: &alignCenter))
        }
        
        let style = CTParagraphStyleCreate(settings, settings.count)
        let additionalAttributes : [NSAttributedString.Key : Any] = [
            .font:              self.options.font,
            .foregroundColor:   self.options.textColor.cgColor,
            .verticalGlyphForm: true,
            .paragraphStyle:    style,
            ]
        
        attributed.addAttributes(additionalAttributes, range: self.range(attributed))
    }
    
    /// ルビ振りのアノテーションを作成する
    /// - parameter ruby: ルビ文字列
    /// - returns: 中央寄せするかどうか
    private func createRubyAnnotation(_ ruby: String) -> CTRubyAnnotation {
        let text = UnsafeMutablePointer<Unmanaged<CFString>?>.allocate(capacity: 4)
        text.advanced(by: 0).pointee = self.unmanagedPointer(ruby)
        text.advanced(by: 1).pointee = self.unmanagedPointer("")
        text.advanced(by: 2).pointee = self.unmanagedPointer("")
        text.advanced(by: 3).pointee = self.unmanagedPointer("")
        return CTRubyAnnotationCreate(.auto, .auto, 0.5, text)
    }
    
    /// 文字列をUnmanagedなポインタで返す
    /// - parameter value: 対象の文字列
    /// - returns: Unmanaged<CFString>の値
    private func unmanagedPointer(_ value: String) -> Unmanaged<CFString> {
        return Unmanaged<CFString>.passRetained(value as CFString)
    }
    
    // MARK: - レンダリング
    
    /// 文字列を描画する
    /// - parameter attributed: 属性付文字列
    /// - parameter rect: 描画する範囲の座標
    /// - returns: 描画した文字列数
    private func render(_ attributed: NSMutableAttributedString, _ rect: CGRect) -> Int {
        let context = UIGraphicsGetCurrentContext()!
        context.rotate(by: CGFloat(Double.pi / 2))
        context.scaleBy(x: 1.0, y: -1.0)
        
        let offset = -1 * self.options.font.pointSize * 0.35
        let framesetter = CTFramesetterCreateWithAttributedString(attributed)
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: rect.height, height: rect.width + offset), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        if self.isRendering {
            CTFrameDraw(frame, context)
        }
        
        return Int(CTFrameGetVisibleStringRange(frame).length)
    }
    
    // MARK: - 計算
    
    /// レンダリング等の結果から各情報を算出する
    private func calculate() {
        self.visibleText = self.substring(self.visibleText, range: NSMakeRange(0, self.visibleLength))
        var rawText = self.visibleText
        
        var offset = 0
        for (i, dstAttrRange) in self.dstAttrRanges.enumerated() {
            if dstAttrRange.location >= self.visibleLength { break }
            
            var range = dstAttrRange
            range.location += offset
            
            let rawAttrRange = self.rawAttrRanges[i]
            let replacement = self.text.substring(range: rawAttrRange)
            
            rawText = self.replace(rawText, replacement: replacement, range: range)
            offset += (rawAttrRange.length - dstAttrRange.length)
        }
        
        self.visibleRawText = rawText
        self.visibleRawLength = self.visibleRawText.count
    }
    
    // MARK: - プライベート
    
    /// 正規表現で文字列検索する
    /// - parameter string: 対象の文字列
    /// - parameter pattern: 検索するパターン
    /// - returns: 検索結果
    private func find(_ string: String, pattern: String) -> NSTextCheckingResult? {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.firstMatch(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
        } catch {
            return nil
        }
    }
    
    /// 正規表現で検索したパターンを文字列置換する
    /// - parameter string: 対象の文字列
    /// - parameter pattern: 検索するパターン
    /// - parameter template: 置換する文字列
    /// - returns: 置換した文字列
    private func replace(_ string: String, pattern: String, template: String) -> String {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.stringByReplacingMatches(in: string, options: [], range: NSMakeRange(0, string.utf16.count), withTemplate: template)
        } catch {
            return string
        }
    }
    
    /// 指定した範囲の文字列を置換する
    /// - parameter string: 対象の文字列
    /// - parameter replacement: 置き換える文字列
    /// - parameter range: 範囲
    /// - returns: 置換した文字列
    private func replace(_ string: String, replacement: String, range: NSRange) -> String {
        return (string as NSString).replacingCharacters(in: range, with: replacement)
    }
    
    /// 渡した属性付文字列全体を指定の文字列に置換する
    /// - parameter attributed: 属性付文字列
    /// - parameter string: 置き換える文字列
    /// - returns: 置換した文字列
    private func replace(attributed: NSMutableAttributedString, string: String) {
        attributed.replaceCharacters(in: self.range(attributed), with: string)
    }
    
    /// 文字列から指定した範囲を取得する
    /// - parameter string: 対象の文字列
    /// - parameter range: 範囲
    /// - returns: 取り出した文字列
    private func substring(_ string: String, range: NSRange) -> String {
        let st = string.startIndex
        let s = string.index(st, offsetBy: range.location)
        let e = string.index(st, offsetBy: range.location + range.length)
        return String(string[s..<e])
    }
    
    /// 渡した属性付文字列全体の範囲を取得する
    /// - parameter attributed: 属性付文字列
    /// - returns: 全体の範囲
    private func range(_ attributed: NSMutableAttributedString) -> NSRange {
        return NSMakeRange(0, attributed.string.count)
    }
}
