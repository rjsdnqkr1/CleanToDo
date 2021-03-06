//
//  AddTodoViewController.swift
//  CleanToDo
//
//  Created by Park on 2021/01/19.
//

import Foundation
import UIKit

protocol AddTodoDisplayLogic: class {
    func displayAddedTodo(viewModel: AddTodoModel.AddTodo.ViewModel)
    func displayAddedTodoError(viewModel: AddTodoModel.AddTodo.ViewModel)
    
    func displayModifiedTodo(viewModel: AddTodoModel.ModifyTodo.ViewModel)
    func displayModifiedTodoError(viewModel: AddTodoModel.ModifyTodo.ViewModel)
    
    func displayedFetchedTodo(viewModel: AddTodoModel.FetchTodo.ViewModel)
}

/**
   todo 작성(Add) 및 수정(Modify)을 담당하는 화면
*/
class AddTodoViewController: CleanToDo.ViewController, SetupLogic, AddTodoDisplayLogic {
    var interactor: AddTodoBusinessLogic?
    var router: (NSObject & AddTodoRoutingLogic & AddTodoDataPassing)?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextField: UITextView!
    
    @IBAction func clickAddTodo(_ sender: Any) {
        let title = titleTextField.text!
        let contents = contentsTextField.text!
        
        interactor?.addTodo(request: AddTodoModel.AddTodo.Request(
            todoFormFields: AddTodoModel.TodoFormFields(title: title, contents: contents)))
    }
    
    func setup() {
        let viewController = self
        let interactor = AddTodoInteractor()
        let presenter = AddTodoPresenter()
        let router = AddTodoRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchTodo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    func displayAddedTodo(viewModel: AddTodoModel.AddTodo.ViewModel) {
        router?.routeToListTodo(segue: nil)
    }
    
    func displayAddedTodoError(viewModel: AddTodoModel.AddTodo.ViewModel) {
        displayErrorMessage(errorMessage: viewModel.errorMessage!)
    }
    
    func displayModifiedTodo(viewModel: AddTodoModel.ModifyTodo.ViewModel) {
        router?.routeToDetailTodo(segue: nil)
    }
    
    func displayModifiedTodoError(viewModel: AddTodoModel.ModifyTodo.ViewModel) {
        displayErrorMessage(errorMessage: viewModel.errorMessage!)
    }
    
    func displayedFetchedTodo(viewModel: AddTodoModel.FetchTodo.ViewModel) {
        titleTextField.text = viewModel.displayedTodo?.title
        contentsTextField.text = viewModel.displayedTodo?.contents
    }
}
