//
//  APIService.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation

class APIService {
  static let shared = APIService()
  private let baseURL = "http://localhost:3000" // Replace with your API URL

  // Fetch tasks for a user
  func fetchTasks(userId: String, completion: @escaping ([Task]?) -> Void) {
    guard let url = URL(string: "\(baseURL)/tasks/\(userId)") else { return }
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let data = data {
        let tasks = try? JSONDecoder().decode([Task].self, from: data)
        completion(tasks)
      }
    }.resume()
  }
  // Add methods for create/update/delete tasks
}
