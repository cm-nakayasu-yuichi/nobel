//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

enum ConfigureRow {
    case bookName
    case bookAuthor
    case colorTheme
    case fontType
    case textSize
    case cover
    case chapter
    case discard
    
    static func items(scenario: ConfigureScenario) -> [[ConfigureRow]] {
        switch scenario {
        case .global:
            return [
                [.colorTheme, .fontType, .textSize],
                [.bookAuthor],
            ]
        case .initialize:
            return [
                [.bookName, .bookAuthor],
                [.colorTheme, .fontType, .textSize],
                [.cover],
                [.discard],
            ]
        case .update:
            return [
                [.chapter],
                [.colorTheme, .fontType, .textSize],
                [.bookName, .bookAuthor],
                [.cover],
            ]
        }
    }
    
    var textColor: UIColor {
        return isDestructive ? #colorLiteral(red: 0.9882352941, green: 0.2392156863, blue: 0.2235294118, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        return isDestructive ? .none : .disclosureIndicator
    }
    
    private var isDestructive: Bool {
        switch self { case .discard: return true default: return false }
    }
}
    
    /*
    func transfer(from vc: ConfigureViewController) {
        switch self {
        case .bookName:
//            vc.pushConfigure(ConfigureTextFieldViewController.create(type: .bookName, initialText: vc.owner.configuredBook.name) { _, text in
//                vc.owner.configuredBook.name = text
//            })
            return
        case .bookAuthor:
//            vc.pushConfigure(ConfigureTextFieldViewController.create(type: .bookName, initialText: vc.owner.configuredBook.author) { _, text in
//                vc.owner.configuredBook.author = text
//            })
            return
        case .colorTheme:
//            vc.pushConfigure(ConfigureThemeSelectViewController.create(type: .colorTheme) { _, rawValue in
//                vc.owner.configuredBook.colorTheme = ColorTheme(rawValue: rawValue)!
//            })
            return
        case .fontType:
//            vc.pushConfigure(ConfigureThemeSelectViewController.create(type: .fontType) { _, rawValue in
//                vc.owner.configuredBook.fontType = FontType(rawValue: rawValue)!
//            })
            return
        case .textSize:
//            vc.pushConfigure(ConfigureThemeSelectViewController.create(type: .textSize) { _, rawValue in
//                vc.owner.configuredBook.textSize = TextSize(rawValue: rawValue)!
//            })
            return
        case .chapter:
//            vc.pushConfigure(ConfigureChapterViewController.create())
            return
        case .discard:
//            vc.configuredBook.delete()
//            vc.dismiss()
            return
        default: break
        }
    }
    */
