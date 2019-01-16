//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ShelfInteractorInput: class {
    
    var output: ShelfInteractorOutput! { get set }
}

protocol ShelfInteractorOutput: class {
    
}

class ShelfRepository: ShelfInteractorInput {
    
    weak var output: ShelfInteractorOutput!    
}
