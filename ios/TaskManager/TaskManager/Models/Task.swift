//
//  Task.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import Foundation

/// Model representing a task
struct Task: Identifiable, Codable {
    var id: String?  // Firestore auto-generated ID (optional)
    var title: String
    var description: String
    var createdAt: Date
    var dueDate: Date
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
        
        id = try container.decodeIfPresent(String.self, forKey: .id) // ID can be nil
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        status = try container.decode(String.self, forKey: .status)

        // Decode Firestore timestamp (_seconds + _nanoseconds) into Date
        createdAt = try Self.decodeTimestamp(from: container, key: .createdAt)
        dueDate = try Self.decodeTimestamp(from: container, key: .dueDate)
    }

    /// Custom initializer for creating new tasks
    init(id: String? = nil, title: String, description: String, createdAt: Date, dueDate: Date, status: String) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.status = status
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
