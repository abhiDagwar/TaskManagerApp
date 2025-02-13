//
//  Task.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation

struct Task: Identifiable, Codable {
  let id: String?
  var title: String
  var description: String
  var dueDate: Date
  var status: String // Todo/In Progress/Done
  var userId: String
}
