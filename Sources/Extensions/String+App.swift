//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

// MARK: - substring
extension String {
    
    // [0..<9]
    subscript(bounds: CountableRange<Int>) -> String {
        return substring(start: bounds.lowerBound, end: bounds.upperBound - 1)
    }
    
    // [0..<9]
    subscript(bounds: CountableClosedRange<Int>) -> String {
        return substring(start: bounds.lowerBound, end: bounds.upperBound)
    }
    
    // [..<9]
    subscript(bounds: PartialRangeUpTo<Int>) -> String {
        return substring(start: 0, end: bounds.upperBound - 1)
    }
    
    // [...9]
    subscript(bounds: PartialRangeThrough<Int>) -> String {
        return substring(start: 0, end: bounds.upperBound)
    }
    
    // [0...]
    subscript(bounds: CountablePartialRangeFrom<Int>) -> String {
        return substring(start: bounds.lowerBound, end: count - 1)
    }
    
    /// 文字列の部分取得
    /// - Parameters:
    ///   - start: 開始位置インデックス
    ///   - end: 終了位置インデックス
    /// - Returns: 部分取得した文字列
    func substring(start: Int, end: Int) -> String {
        let max = count - 1
        var s = start, e = end
        if max < 0 || e < s || max < s || e < 0 {
            return ""
        }
        s = s >= 0 ? s : 0
        e = max > e ? e : max
        
        let substringStart = index(startIndex, offsetBy: s)
        let substringEnd = index(startIndex, offsetBy: e)
        return String(self[substringStart...substringEnd])
    }
    
    /// 文字列の部分取得
    /// - Parameters:
    ///   - location: 開始位置インデックス
    ///   - length: 取得する長さ
    /// - Returns: 部分取得した文字列
    func substring(location: Int, length: Int) -> String {
        return substring(start: location, end: location + length - 1)
    }
    
    /// 文字列の部分取得
    /// - Parameter range: 取得範囲
    /// - Returns: 部分取得した文字列
    func substring(range: NSRange) -> String {
        return substring(location: range.location, length: range.length)
    }
    
    /// 指定した文字数分だけ後ろから削除したものを返す
    /// - Parameter length: 削除する文字数
    func removedBackword(length: Int = 1) -> String {
        return self[..<(count - length)]
    }
    
    /// 指定した文字数分だけ後ろから削除したものを返す
    /// - Parameter length: 削除する文字数
    func removedForword(length: Int = 1) -> String {
        return self[length...]
    }
}

// MARK: - localizing
extension String {
    
    /// ローカライズした文字列
    var localized: String {
        return localized(comment: "")
    }
    
    /// ローカライズした文字列を取得する
    /// - Parameter comment: コメント
    /// - Returns: ローカライズした文字列
    func localized(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

// MARK: - formatting
extension String {
    
    /// フォーマットした文字列を取得する
    /// - Parameter args: フォーマット用の引数
    /// - Returns: フォーマットした文字列
    func format(_ args: CVarArg...) -> String {
        return NSString(format: self, arguments: getVaList(args)).string
    }
}

// MARK: - objective-c relation
extension String {
    
    /// NSStringにキャストした文字列
    var ns: NSString {
        return NSString(string: self)
    }
    
    /// NSMutableStringにキャストした文字列
    var mutable: NSMutableString {
        return NSMutableString(string: self)
    }
}

extension NSString {
    
    /// Stringにキャストした文字列
    var string: String {
        return self as String
    }
}

// MARK: - empty substitution
extension String {
    
    /// 空文字列であればnilを返す
    var emptyToNil: String? {
        return isEmpty ? nil : self
    }
    
    /// 空文字列であれば指定の代替文字を返す
    /// - Parameter substitute: 代替文字列
    /// - Returns: 空文字列の場合は代替文字列、それ以外は自身を返す
    func emptyTo(_ substitute: String) -> String {
        return isEmpty ? substitute : self
    }
}

// MARK: - replace
extension String {
    
    /// 文字列置換を行う
    /// - Parameters:
    ///   - search: 検索する文字
    ///   - replacement: 置換する文字
    /// - Returns: 置換された文字列
    func replace(_ search: String, _ replacement: String) -> String {
        return replacingOccurrences(of: search, with: replacement, options: NSString.CompareOptions(), range: nil)
    }
    
    /// 指定した範囲の文字列置換を行う
    /// - Parameters:
    ///   - range: 範囲
    ///   - replacement: 置換する文字
    /// - Returns: 置換された文字列
    func replace(_ range: NSRange, _ replacement: String) -> String {
        return ns.replacingCharacters(in: range, with: replacement)
    }
}

// MARK: - split
extension String {
    
    /// 文字列をセパレータ文字列で分割して配列で取得する
    /// - Parameter separator: セパレータ文字列
    /// - Returns: 分割した文字列配列
    func split(_ separator: String) -> [String] {
        return components(separatedBy: separator)
    }
    
    /// コンマで分割
    var splitByComma: [String] {
        return split(",")
    }
    
    /// ドットで分割
    var splitByDot: [String] {
        return split(".")
    }
    
    /// スラッシュで分割
    var splitBySlash: [String] {
        return split("/")
    }
    
    /// 半角スペースで分割
    var splitByWhitespace: [String] {
        return split(" ")
    }
    
    /// 改行文字で分割
    var splitByReturn: [String] {
        return split("\n")
    }
    
    /// キャリッジリターンで分割
    var splitByCarriageReturn: [String] {
        return split("\r\n")
    }
    
    /// タブで分割
    var splitByTab: [String] {
        return split("\t")
    }
}

// MARK: - trim
extension String {
    
    /// 文字列のトリム
    /// - Parameter characterSet: トリムに使用するキャラクタセット(
    /// - Returns: トリムされた文字列
    func trim(_ characterSet: CharacterSet = .whitespaces) -> String {
        return trimmingCharacters(in: characterSet)
    }
}

// MARK: - regular expression
extension String {
    
    /// 文字列から正規表現パターンに合った文字列を配列で返す
    /// - Parameters:
    ///   - pattern: 正規表現パターン
    ///   - options: 正規表現オプション
    ///   - matchingOptions: 正規表現マッチングオプション
    /// - Returns: 正規表現パターンに合った文字列の配列
    func matchedStrings(_ pattern: String, options: NSRegularExpression.Options? = nil, matchingOptions: NSRegularExpression.MatchingOptions? = nil) -> [String] {
        let opts = options ?? NSRegularExpression.Options()
        guard let rex = try? NSRegularExpression(pattern: pattern, options: opts) else {
            return []
        }
        
        let matchOpts = matchingOptions ?? NSRegularExpression.MatchingOptions()
        return rex.matches(in: self, options: matchOpts, range: NSMakeRange(0, count)).map { result -> String in
            return substring(range: result.range(at: 0))
        }
    }
    
    /// 指定した正規表現パターンに合うかどうかを返す
    /// - Parameters:
    ///   - pattern: 正規表現パターン
    ///   - options: 正規表現オプション
    ///   - matchingOptions: 正規表現マッチングオプション
    /// - Returns: 正規表現パターンに合った最初の文字列
    func matchedString(_ pattern: String, options: NSRegularExpression.Options? = nil, matchingOptions: NSRegularExpression.MatchingOptions? = nil) -> String? {
        return matchedStrings(pattern, options: options, matchingOptions: matchingOptions).first
    }
    
    /// 指定した正規表現パターンに合うかどうかを返す
    /// - Parameter pattern: 正規表現パターン
    /// - Returns: 文字列が正規表現パターンに合うかどうか
    func isMatched(_ pattern: String) -> Bool {
        let range = ns.range(of: pattern, options: .regularExpression)
        return range.location != NSNotFound
    }
    
    /// 文字列から正規表現パターンに合った箇所を置換した文字列を返す
    /// - Parameters:
    ///   - pattern: 正規表現パターン
    ///   - replacement: 置換する文字列
    ///   - options: 正規表現オプション
    ///   - matchingOptions: 正規表現マッチングオプション
    /// - Returns: 置換した文字列
    func replaceMatched(_ pattern: String, replacement: String, options: NSRegularExpression.Options? = nil, matchingOptions: NSRegularExpression.MatchingOptions? = nil) -> String {
        let opts = options ?? NSRegularExpression.Options()
        guard let rex = try? NSRegularExpression(pattern: pattern, options: opts) else {
            return self
        }
        
        let mutableSelf = mutable
        let matchOpts = matchingOptions ?? NSRegularExpression.MatchingOptions()
        rex.replaceMatches(in: mutableSelf, options: matchOpts, range: NSMakeRange(0, count), withTemplate: replacement)
        
        return mutableSelf as String
    }
    
    /// 文字列から正規表現パターンに合った箇所を削除した文字列を返す
    /// - Parameters:
    ///   - pattern: 正規表現パターン
    ///   - options: 正規表現オプション
    ///   - matchingOptions: 正規表現マッチングオプション
    /// - Returns: 削除した文字列
    func removeMatched(_ pattern: String, options: NSRegularExpression.Options? = nil, matchingOptions: NSRegularExpression.MatchingOptions? = nil) -> String {
        return replaceMatched(pattern, replacement:"", options: options, matchingOptions: matchingOptions)
    }
}

// MARK: - transform
extension String {
    
    /// 半角文字を全角文字に変換
    var fullWidth: String {
        return applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? ""
    }
    
    /// 全角文字を半角文字
    var halfWidth: String {
        return applyingTransform(.fullwidthToHalfwidth, reverse: false) ?? ""
    }
    
    /// カタカタをひらがなに変換
    var katakanaToHiragana: String {
        return applyingTransform(.hiraganaToKatakana, reverse: true) ?? ""
    }
    
    /// ひらがなをカタカナに変換
    var hiraganaToKatakana: String {
        return applyingTransform(.hiraganaToKatakana, reverse: false) ?? ""
    }
}

// MARK: - structure check
extension String {
    
    struct Structure {
        static let number = "0123456789"
        static let lowercaseAlphabet = "abcdefghijklmnopqrstuvwxyz"
        static let uppercaseAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        static let whitespace = " "
        static let alphabet = lowercaseAlphabet + uppercaseAlphabet
        static let alphabetNumber = alphabet + number
        static let alphabetAndWhitespace = alphabet + whitespace
        static let alphabetNumberAndWhitespace = alphabetNumber + whitespace
    }
    
    /// 指定した文字のみで構成されているかどうかを返す
    /// - Parameter characters: 指定の文字
    /// - Returns: 指定した文字のみで構成されているかどうか
    func isOnly(characters: String) -> Bool {
        return trimmingCharacters(in: CharacterSet(charactersIn: characters)).isEmpty
    }
    
    /// 半角数字のみで構成されているかどうか
    var isOnlyNumber: Bool {
        return isOnly(characters: Structure.number)
    }
    
    /// 半角小文字英字のみで構成されているかどうか
    var isOnlyLowercasedAlphabet: Bool {
        return isOnly(characters: Structure.lowercaseAlphabet)
    }

    /// 半角大文字英字のみで構成されているかどうか
    var isOnlyUppercaseAlphabet: Bool {
        return isOnly(characters: Structure.uppercaseAlphabet)
    }
    
    /// 半角英字のみで構成されているかどうか
    var isOnlyAlphabet: Bool {
        return isOnly(characters: Structure.alphabet)
    }
    
    /// 半角英数字のみで構成されているかどうか
    var isOnlyAlphabetNumber: Bool {
        return isOnly(characters: Structure.alphabetNumber)
    }
    
    /// 半角英字+半角スペースのみで構成されているかどうか
    var isOnlyAlphabetAndWhitespace: Bool {
        return isOnly(characters: Structure.alphabetAndWhitespace)
    }
    
    /// 半角英数字+半角スペースのみで構成されているかどうか
    var isOnlyAlphabetNumberAndWhitespace: Bool {
        return isOnly(characters: Structure.alphabetNumberAndWhitespace)
    }
}

// MARK: - notation
extension String {
    
    /// スネーク記法をキャメル記法に変換した文字列
    var snakeToCamel: String {
        if isEmpty { return "" }
        
        let r = NSMakeRange(0, 1)
        var ret = capitalized.replacingOccurrences(of: "_", with: "")
        ret = ret.ns.replacingCharacters(in: r, with: ret.ns.substring(with: r).lowercased())
        return ret
    }
    
    /// キャメル記法をスネーク記法に変換した文字列
    var camelToSnake: String {
        if isEmpty { return "" }
        return replaceMatched("(?<=\\w)([A-Z])", replacement: "_$1").lowercased()
    }
}

// MARK: - padding
extension String {
    
    /// 不足分を文字で埋めた文字列を取得する
    /// - Parameters:
    ///   - character: 埋める文字
    ///   - length: 必要な文字数
    ///   - prefix: 前方を埋める場合はtrue 後方の場合はfalse
    /// - Returns: 不足分を文字で埋めた文字列
    func padding(_ character: String, length: Int, prefix: Bool = true) -> String {
        if count >= length {
            return self
        }
        
        let pad = (0..<length-count).reduce("") { res, _ in
            res + character
        }
        
        if prefix {
            return pad + self
        } else {
            return self + pad
        }
    }
    
    /// 0埋めした文字列を取得する
    /// - Parameters:
    ///   - length: 必要な文字数
    ///   - prefix: 前方を0で埋める場合はtrue 後方を0で埋める場合はfalse
    /// - Returns: 0埋めした文字列
    func paddingZero(length: Int, prefix: Bool = true) -> String {
        return padding("0", length: length, prefix: prefix)
    }
}

// MARK: - url encode and decode
extension String {
    
    /// URLエンコードした文字列
    var urlEncode: String {
//        let set: CharacterSet = [
//            CharacterSet.alphanumerics,
//            CharacterSet.urlHostAllowed,
//            CharacterSet.urlQueryAllowed,
//            ]
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
    
    /// URLデコードした文字列
    var urlDecode: String {
        return removingPercentEncoding ?? ""
    }
}
