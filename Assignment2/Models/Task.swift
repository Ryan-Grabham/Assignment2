import Foundation

struct Task: Codable, Identifiable {
    let id : Int
    let name : String
    let description: String
    let due_date : String
    let status : String
    let project_id: Int
}
