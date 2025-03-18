//
//  Task.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation

/// Model representing a task
struct Task: Identifiable, Codable {
    /// Unique identifier for the task (Firestore document ID)
    var id: String? // ✅ Make 'id' optional
    
    /// Title of the task
    var title: String
    
    /// Detailed description of what the task involves
    var description: String
    
    /// Date when the task was created
    var createdAt: Date
    
    /// Date by which the task should be completed
    var dueDate: Date
    
    /// Current status of the task (Todo/In Progress/Done)
    var status: String

    /// Custom coding keys to match Firestore API response
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case createdAt
        case dueDate
        case status
    }
    
    /// Custom decoding for Firestore timestamps
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        status = try container.decode(String.self, forKey: .status)

        // Decode Firestore timestamp (_seconds + _nanoseconds) into Date
        createdAt = try Self.decodeTimestamp(from: container, key: .createdAt)
        dueDate = try Self.decodeTimestamp(from: container, key: .dueDate)
    }
    
    /// Helper function to decode Firestore timestamps
    private static func decodeTimestamp(from container: KeyedDecodingContainer<CodingKeys>, key: CodingKeys) throws -> Date {
        let timestampContainer = try container.nestedContainer(keyedBy: TimestampKeys.self, forKey: key)
        let seconds = try timestampContainer.decode(Double.self, forKey: ._seconds)
        let nanoseconds = try timestampContainer.decode(Double.self, forKey: ._nanoseconds)
        return Date(timeIntervalSince1970: seconds + (nanoseconds / 1_000_000_000))
    }
    
    /// Custom keys for Firestore timestamps (_seconds and _nanoseconds)
    private enum TimestampKeys: String, CodingKey {
        case _seconds, _nanoseconds
    }
}
