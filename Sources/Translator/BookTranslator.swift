//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
/*
class CalendarSettingTranslator: Translator {
    typealias Input = CalendarSetting
    typealias Output = CalendarSettingModel
    
    func translate(_ input: CalendarSetting) -> CalendarSettingModel {
        let model = CalendarSettingModel()
        let def = loadDefaultEntity()
        model.themes = translateThemes(input, default: def)
        return model
    }
    
    private func translateThemes(_ input: CalendarSetting, default def: CalendarSetting) -> CalendarSettingModel.Themes {
        let themes = CalendarSettingModel.Themes()
        themes.event = CalendarThemeModel(entity: input.eventTheme ?? def.eventTheme!)
        
        
        return themes
    }
    
    private func loadDefaultEntity() -> CalendarSetting {
        return Json().decode(
            path: File.defaultCalendarSetting.path,
            to: CalendarSetting.self
        )!
    }
}
*/
