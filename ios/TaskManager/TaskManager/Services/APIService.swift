//
//  APIService.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation
import FirebaseFirestore

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
    
    // DECODE THE DATA INTO JSON USING JSON SERILISER FOR TESTING
    fileprivate func jsonExtractor(_ data: Data) {
        let jsonData = data
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options:JSONSerialization.ReadingOptions(rawValue: 0))
            guard let dictionary = jsonObject as? Dictionary<String, Any> else {
                print("Not a Dictionary")
                // put in function
                return
            }
            print("JSON Dictionary! \(dictionary)")
        }
        catch let error as NSError {
            print("Found an error - \(error)")
        }
    }
    
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
                // Decode the JSON data into an array of Task objects using the Task struct's CodingKeys
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970 // Ensure this matches Firestore timestamp format
                let tasks = try decoder.decode([Task].self, from: data)
                completion(.success(tasks))
            } catch {
                print("Error decoding tasks:", error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    /// Creates a new task
    /// - Parameters:
    ///   - task: The task to create
    ///   - completion: Closure called with the result containing created task or error
    func createTask(for userId: String, _ task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        let endpoint = "\(baseURL)/tasks/\(userId)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601 // Add a fix to update date format to the server
            let jsonData = try encoder.encode(task)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                // Decode response as a dictionary
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let taskId = jsonResponse["id"] {
                    
                    // Construct a new Task object with the returned ID
                    let createdTask = Task(
                        id: taskId,
                        title: task.title,
                        description: task.description,
                        createdAt: task.createdAt,
                        dueDate: task.dueDate,
                        status: task.status
                    )
                    
                    completion(.success(createdTask))
                } else {
                    completion(.failure(APIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    /// Updates an existing task
    /// - Parameters:
    ///   - task: The task with updated values
    ///   - completion: Closure called with the result containing updated task or error
    func updateTask(_ task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        // Ensure the task has an ID
            guard let taskId = task.id else {
                completion(.failure(APIError.invalidRequest))
                return
            }
            
            // Construct URL with task ID
            let endpoint = "\(baseURL)/tasks/\(taskId)"
            guard let url = URL(string: endpoint) else {
                completion(.failure(APIError.invalidURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
    case invalidResponse
    case invalidRequest
}
