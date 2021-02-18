import Foundation
import HTTPLinkHeader

extension Requests.API {
    public enum V1 {
        public static func apps(
            name: String,
            redirectURI: String = "urn:ietf:wg:oauth:2.0:oob",
            scopes: [Scope] = [.read],
            website: String? = nil
        ) -> Request<Responses.Application> {
            struct Parameters: Encodable {
                private enum CodingKeys: String, CodingKey {
                    case name = "client_name"
                    case redirectURI = "redirect_uris"
                    case scopes
                    case website
                }

                let name: String
                let redirectURI: String
                let scopes: String
                let website: String?
            }

            let parameters = Parameters(
                name: name,
                redirectURI: redirectURI,
                scopes: scopes.map(\.rawValue).joined(separator: " "),
                website: website
            )
            let httpBody = try? JSONEncoder().encode(parameters)
            return Request(path: "/api/v1/apps", httpMethod: .post(httpBody))
        }

        public static func notifications(pagination: HTTPLinkHeader? = nil) -> Request<Paged<[Responses.Notification]>> {
            let queryItems: [URLQueryItem]?
            if let pagination = pagination, let urlComponents = URLComponents(string: pagination.uriReference) {
                queryItems = urlComponents.queryItems
            } else {
                queryItems = nil
            }

            return Request(path: "/api/v1/notifications", httpMethod: .get(queryItems))
        }
    }
}