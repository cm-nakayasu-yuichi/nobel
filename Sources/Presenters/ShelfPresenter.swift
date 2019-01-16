//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ShelfPresenterProtocol: class {
    
    var view: ShelfViewProtocol! { get set }
    var interactor: ShelfInteractorInput! { get set }
}

protocol ShelfViewProtocol: class {
    
}

class ShelfPresenter: ShelfPresenterProtocol {
    
    weak var view: ShelfViewProtocol!
    
    var interactor: ShelfInteractorInput!
}

extension ShelfPresenter: ShelfInteractorOutput {
	
}
