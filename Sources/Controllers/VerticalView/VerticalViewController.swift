/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - VerticalViewOptions -

/// 縦書表示設定オプション
class VerticalViewOptions {
    
    /// フォント
    var font = UIFont(name: "HiraMinProN-W3", size: 16)!
    
    /// 文字色
    var textColor = UIColor.black
    
    /// 背景色
    var backgroundColor = UIColor.white
    
    /// フォントに対する行間の大きさ
    var lineHeightCoefficient: CGFloat = 1.4
}

// MARK: - VerticalViewControllerDelegate -

/// VerticalViewControllerのデリゲートプロトコル
@objc protocol VerticalViewControllerDelegate: NSObjectProtocol {
    
    /// リロードが完了した時
    /// - parameter vertical: 縦書きビューコントローラ
    @objc optional func verticalDidReload(_ vertical: VerticalViewController)
    
    /// ページを変更する時
    /// - parameter vertical: 縦書きビューコントローラ
    /// - parameter pageIndex: ページインデックス
    @objc optional func vertical(_ vertical: VerticalViewController, willMoveFrom pageIndex: Int)
    
    /// ページを変更した時
    /// - parameter vertical: 縦書きビューコントローラ
    /// - parameter pageIndex: ページインデックス
    @objc optional func vertical(_ vertical: VerticalViewController, didMoveFrom pageIndex: Int)
}

// MARK: - VerticalViewController -

/// 縦書表示ビューコントローラ
class VerticalViewController: UIViewController, UIScrollViewDelegate {
    
    /// 全体文字列
    var text = ""
    
    /// 縦書表示設定オプション
    var options = VerticalViewOptions()
    
    /// デリゲート
    weak var delegate: VerticalViewControllerDelegate?
    
    /// 各ページの文字列配列
    private(set) var texts = [String]()
    
    /// スクロールビュー
    var scrollView : UIScrollView { return self.view as! UIScrollView }
    
    /// 先頭ページのインデックス(原則として0になる)
    var firstPageIndex : Int { return (self.texts.indices.first!) }
    
    /// 最終ページのインデックス
    var lastPageIndex : Int { return (self.texts.indices.last!) }
    
    /// 現在選択されているページのインデックス
    var currentPageIndex = 0
    
    /// 現在表示中のページビューのインデックス(currentPageIndexの逆になる)
    var currentViewIndex: Int {
        get {
            return self.reversedIndex(of: self.currentPageIndex)
        }
        set {
            self.currentPageIndex = self.reversedIndex(of: newValue)
        }
    }
    
    /// 現在選択されているページの文字列(原文)
    var currentRawText: String {
        return self.texts[self.currentPageIndex]
    }
    
    // MARK: - リロード
    
    /// リロードを行う
    func reload() {
        self.reset()
        self.analyze() { texts in
            self.texts = texts
            self.setupPageViews()
            self.moveQuietly(to: self.currentPageIndex)
            self.delegate?.verticalDidReload?(self)
        }
    }
    
    /// 配置中のビューの全削除と文字配列の初期化を行う
    func reset() {
        self.scrollView.removeAllSubviews()
        self.scrollView.contentSize = CGSize.zero
        self.scrollView.contentOffset = CGPoint.zero
        //self.texts.removeAll()
    }
    
    /// 全体文字列を解析して文字列配列を取得する
    /// - parameter analyzed: 解析が完了した時のコールバック
    func analyze(analyzed: @escaping ([String]) -> ()) {
        var texts = [String]()
        
        func analyzeUsingVerticalView(_ text: String) {
            let verticalView = VerticalView(frame: self.view.bounds)
            verticalView.text    = text
            verticalView.options = self.options
            verticalView.isRendering = false
            verticalView.analyzed = {
                texts.append(verticalView.visibleRawText)
                let next = (text as NSString).replacingCharacters(in: NSMakeRange(0, verticalView.visibleRawLength), with: "")
                
                verticalView.removeFromSuperview()
                
                if next.isEmpty {
                    analyzed(texts)
                } else {
                    analyzeUsingVerticalView(next)
                }
            }
            self.view.addSubview(verticalView)
        }
        analyzeUsingVerticalView(self.text)
    }
    
    /// スクロールビュー内にページビュー(縦書きビュー)を配置する
    private func setupPageViews() {
        var frame = self.view.bounds
        self.scrollView.contentSize = CGSize(width: frame.width * CGFloat(self.texts.count), height: frame.height)
        
        for (i, text) in self.texts.enumerated() {
            frame.origin.x = frame.width * CGFloat(self.reversedIndex(of: i))
            
            let verticalView = VerticalView(frame: frame)
            verticalView.text            = text
            verticalView.options         = self.options
            verticalView.backgroundColor = self.options.backgroundColor
            self.scrollView.addSubview(verticalView)
        }
    }
    
    // MARK: - ページ移動
    
    /// 指定したインデックスのページへ移動する
    /// - parameter pageIndex: 移動先のインデックス
    /// - parameter animated: アニメーションするかどうか
    func move(to pageIndex: Int, animated: Bool) {
        let index = self.adjustIndex(pageIndex)
        if self.currentPageIndex == index { return }
        
        self.scrollView.setContentOffset(self.point(ofPageIndex: index), animated: animated)
        if !animated {
            self.delegate?.vertical?(self, willMoveFrom: self.currentPageIndex)
            self.currentPageIndex = index
            self.delegate?.vertical?(self, didMoveFrom: self.currentPageIndex)
        }
    }
    
    /// 指定したインデックスのページへ移動する(コールバックとアニメーションはしない)
    /// - parameter pageIndex: 移動先のインデックス
    func moveQuietly(to pageIndex: Int) {
        let index = self.adjustIndex(pageIndex)
        self.scrollView.contentOffset = self.point(ofPageIndex: index)
        self.currentPageIndex = index
    }
    
    /// ページの範囲を超えないように調整したインデックス値を取得する
    /// - parameter pageIndex: インデックス
    /// - return: 調整したインデックス
    private func adjustIndex(_ pageIndex: Int) -> Int {
        if pageIndex < 0 {
            return 0
        } else if pageIndex > self.lastPageIndex {
            return self.lastPageIndex
        } else {
            return pageIndex
        }
    }
    
    // MARK: - UIScrollViewDelegate実装
    
    /// スクロールを検知中かどうか
    private var recognizedScrolling = false
    
    /// スクロールされる毎に呼ばれる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.recognizedScrolling) {
            self.delegate?.vertical?(self, willMoveFrom: self.currentPageIndex)
            self.recognizedScrolling = true
        }
    }
    
    /// setContentOffset()等でアニメーションされた時に呼ばれる
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = calculatePageIndex()
        if self.currentPageIndex != index {
            self.currentPageIndex = index
            self.delegate?.vertical?(self, didMoveFrom: self.currentPageIndex)
        }
        self.recognizedScrolling = false
    }
    
    /// ユーザの指動作でのスクロールが終わった時に呼ばれる
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // MARK: - 文字の更新
    
    func replace(text: String, at pageIndex: Int? = nil) -> String {
        let index = pageIndex ?? self.currentPageIndex
        self.texts[index] = text
        return self.texts.reduce("") { return $0 + $1 }
    }
    
    /// 指定したインデックスのページへ移動する
    /// - parameter text: 移動先のインデックス
    /// - parameter pageIndex: アニメーションするかどうか
    func modify(text: String, at pageIndex: Int? = nil) {
        let index = pageIndex ?? self.currentPageIndex
        self.texts[index] = text
        self.text = self.texts.reduce("") { return $0 + $1 }
    }
    
    // MARK: - 汎用処理
    
    /// 最終ページからのインデックスを取得する(逆インデックス取得)
    /// - parameter index: インデックス
    /// - return: 最終ページからのインデックス
    func reversedIndex(of index: Int) -> Int {
        return self.lastPageIndex - index
    }
    
    /// スクロールのオフセット位置から現在のページインデックスを計算する
    /// - returns: 現在のページインデックス
    private func calculatePageIndex() -> Int {
        let dval = Double(self.scrollView.contentOffset.x / self.scrollView.frame.width)
        let viewIndex = lround(dval)
        return self.reversedIndex(of: viewIndex)
    }
    
    /// 指定したページのX位置を取得する
    /// - parameter index: インデックス
    /// - return: X位置
    private func xposition(ofPageIndex index: Int) -> CGFloat {
        return CGFloat(self.reversedIndex(of: index)) * self.scrollView.bounds.width
    }
    
    /// 指定したページの座標位置を取得する
    /// - parameter index: インデックス
    /// - return: 最終ページからのインデックス
    private func point(ofPageIndex index: Int) -> CGPoint {
        return CGPoint(x: self.xposition(ofPageIndex: index), y: 0)
    }
    
    // MARK: - 初期処理
    
    private var layoutedRect = CGRect.zero
    
    override func loadView() {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.backgroundColor = self.options.backgroundColor
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.isUserInteractionEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        self.view = scroll
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.layoutedRect.equalTo(self.view.frame) {
            self.reload()
            self.layoutedRect = self.view.frame
        }
    }
}
