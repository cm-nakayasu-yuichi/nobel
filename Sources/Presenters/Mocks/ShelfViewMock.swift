//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class ShelfViewMock: ShelfViewProtocol {
    
    var presenter: ShelfPresenterProtocol
    
    init() {
        let presenter = ShelfPresenter()
        
        presenter.shelfInteractor = ShelfRepository()
        presenter.shelfInteractor.output = presenter
        
        presenter.bookInteractor = BookRepository()
        presenter.bookInteractor.output = presenter
        
        self.presenter = presenter
        self.presenter.view = self
    }
    
    func load() {
        presenter.loadShelf()
    }
    
    func add() {
        presenter.addNewBook()
    }
    
    func loaded(shelf: [Book]) {
        print(shelf)
    }
}
