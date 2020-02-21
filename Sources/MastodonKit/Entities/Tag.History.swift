import Foundation

extension Tag {
    /// Represents daily usage history of a hashtag.
    public struct History: Codable {
        /// UNIX timestamp on midnight of the given day.
        ///
        /// Added in 2.4.1
        public var day: TimeInterval

        /// The counted usage of the tag within that day.
        ///
        /// Added in 2.4.1
        public var uses: Int

        /// The total of accounts using the tag within that day.
        ///
        /// Added in 2.4.1
        public var accounts: Int

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            day = TimeInterval(try container.decode(String.self, forKey: .day))!
            uses = Int(try container.decode(String.self, forKey: .uses))!
            accounts = Int(try container.decode(String.self, forKey: .accounts))!
        }
    }
}

extension Tag.History {
    private enum CodingKeys: String, CodingKey {
        case day
        case uses
        case accounts
    }
}
