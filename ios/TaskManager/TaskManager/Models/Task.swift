//
//  Task.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation

/// Model representing a task in the system
struct Task: Identifiable, Codable {
  // MARK: - Properties
  
  /// Unique identifier for the task
  var id: String?   // Changed from 'let' to 'var' to allow modification
  
  /// Title of the task
  var title: String
  
  /// Detailed description of what the task involves
  var description: String
  
  /// Date by which the task should be completed
  var dueDate: Date
  
  /// Current status of the task (Todo/In Progress/Done)
  var status: String
  
  /// Identifier of the user who owns this task
  var userId: String
}
