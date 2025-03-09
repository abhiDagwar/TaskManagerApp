//
//  APIService.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation

/// Service responsible for handling API requests and responses
class APIService {
    // MARK: - Properties
    
    /// Base URL for the API
    private let baseURL = "http://localhost:3000" // Replace with your API URL
    
    /// URL session for performing network requests
    private let session: URLSession
    
    // MARK: - Initialization
    
    /// Initializes the API service with a URL session
    /// - Parameter session: The URL session to use for requests (defaults to shared session)
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - API Methods
    
    /// Fetches tasks for a specific user
    /// - Parameters:
    ///   - userId: The ID of the user whose tasks to fetch
    ///   - completion: Closure called with the result containing tasks or error
    func fetchTasks(for userId: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        // This would typically make a network request to fetch tasks
        // For now, it's a placeholder for future implementation
        
        // Example implementation once backend is ready:
        let url = URL(string: "\(baseURL)/tasks/\(userId)")
        guard let requestUrl = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: requestUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    /// Creates a new task
    /// - Parameters:
    ///   - task: The task to create
    ///   - completion: Closure called with the result containing created task or error
    func createTask(_ task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        // This would typically make a network request to create a task
        // For now, it's a placeholder for future implementation
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            // Return the same task but with a generated ID
            var createdTask = task
            createdTask.id = UUID().uuidString
            completion(.success(createdTask))
        }
    }
    
    /// Updates an existing task
    /// - Parameters:
    ///   - task: The task with updated values
    ///   - completion: Closure called with the result containing updated task or error
    func updateTask(_ task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        // This would typically make a network request to update a task
        // For now, it's a placeholder for future implementation
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success(task))
        }
    }
    
    /// Deletes a task
    /// - Parameters:
    ///   - taskId: The ID of the task to delete
    ///   - completion: Closure called with success or error
    func deleteTask(taskId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // This would typically make a network request to delete a task
        // For now, it's a placeholder for future implementation
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success(()))
        }
    }
}

/// Custom errors for API requests
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}
