//
//  Project.swift
//  Assignment2
//
//  Created by Ryan Grabham (Student) on 26/04/2023.
//

import Foundation

struct Project: Codable, Equatable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var start_date: String
    var end_date: String
    var user_id: Int
    var isComplete: Bool = false

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        start_date = try container.decode(String.self, forKey: .start_date)
        end_date = try container.decode(String.self, forKey: .end_date)
        user_id = try container.decode(Int.self, forKey: .user_id)

        let isCompleteInt = try container.decodeIfPresent(Int.self, forKey: .isComplete) ?? 0
        isComplete = isCompleteInt == 1
    }

}

extension [Project] {
    func indexOfProject(withId id: Project.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}
