//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ShelfPresenterProtocol: class {
    
    var view: ShelfViewProtocol! { get set }
    
    var shelfInteractor: ShelfInteractorInput! { get set }
    var bookInteractor: BookInteractorInput! { get set }
    
    func loadShelf()
    func addNewBook()
}

protocol ShelfViewProtocol: class {
    
    func loaded(shelf: [Book])
}

class ShelfPresenter: ShelfPresenterProtocol {
    
    weak var view: ShelfViewProtocol!
    
    var shelfInteractor: ShelfInteractorInput!
    var bookInteractor: BookInteractorInput!
    
    func loadShelf() {
        shelfInteractor.load()
    }
    
    func addNewBook() {
        shelfInteractor.addNewBook()
    }
}

extension ShelfPresenter: ShelfInteractorOutput {
    
    func loaded(shelf: [Book]) {
        view.loaded(shelf: shelf)
    }
    
    func added(newBook: Book) {
        bookInteractor.addNewChapter(to: newBook)
    }
}

extension ShelfPresenter: BookInteractorOutput {
    
    func added(newChapter: Chapter) {
        loadShelf()
    }
    
    func added(newSentence: Sentence) {
        
    }
    
    func loaded(chapters: [Chapter]) {
        
    }
    
    func loaded(sentences: [Sentence]) {
        
    }
}
