//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol TranslateProtocol {
    
    associatedtype Input
    
    associatedtype Output
}

protocol Translator: TranslateProtocol {

    func translate(_ input: Input) -> Output
}

protocol Detranslator: TranslateProtocol {
    
    func detranslate(_ output: Output) -> Input
}

protocol MultiTranslator: Translator {
    
    func translate(_ inputs: [Input]) -> [Output]
}

protocol MultiDetranslator: Detranslator {
    
    func detranslate(_ outputs: [Output]) -> [Input]
}

// MARK: extensions -

extension Translator {
    
    func translateOrNil(_ inputOrNil: Input?) -> Output? {
        guard let input = inputOrNil else {
            return nil
        }
        return translate(input)
    }
}

extension Detranslator {
    
    func detranslateOrNil(_ outputOrNil: Output?) -> Input? {
        guard let output = outputOrNil else {
            return nil
        }
        return detranslate(output)
    }
}

extension MultiTranslator {
    
    func translate(_ inputs: [Input]) -> [Output] {
        return inputs.map { input -> Output in
            return translate(input)
        }
    }
    
    func translateOrNil(_ inputsOrNil: [Input]?) -> [Output]? {
        guard let inputs = inputsOrNil else {
            return nil
        }
        return translate(inputs)
    }
}

extension MultiDetranslator {
    
    func detranslate(_ outputs: [Output]) -> [Input] {
        return outputs.map { output -> Input in
            return detranslate(output)
        }
    }
    
    func detranslateOrNil(_ outputsOrNil: [Output]?) -> [Input]? {
        guard let outputs = outputsOrNil else {
            return nil
        }
        return detranslate(outputs)
    }
}


