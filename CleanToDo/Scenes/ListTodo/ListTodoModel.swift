//
//  ListTodoModel.swift
//  CleanToDo
//
//  Created by Park on 2021/01/19.
//

import Foundation

enum ListTodoModel {
    enum FetchTodos {
        struct Response {
            var todos: [Todo]?
            var errorMessage: String?
        }
        struct ViewModel {
            struct DisplayedTodo {
                var title: String
                var contents: String
                var createdDate: String
            }
            var displayedTodos: [DisplayedTodo]?
            var errorMessage: String?
        }
    }
}
