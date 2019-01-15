//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ShelfPresenterProtocol: class {
    
    var view: ShelfViewProtocol! { get set }
    
    var bookInteractor: BookInteractorInput! { get set }
    
    
}

protocol ShelfViewProtocol: class {
    
    func showMain()
    func showTerms()
    func showTutorial()
}

class ShelfPresenter: ShelfPresenterProtocol {

    weak var view: ShelfViewProtocol!
    
    var bookInteractor: BookInteractorInput!
    
    
}

extension ShelfPresenter: BookInteractorOutput {
    
    func created(newBook: Book) {
        
    }
    
    func loaded(shelf: [Book]) {
        
    }
    
    func loaded(book: Book) {
        
    }
}
