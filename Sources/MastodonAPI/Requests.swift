import Foundation
import HTTPLinkHeader

public enum Requests {
    public static func registerApplication(
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

    public static func obtainToken(
        clientID: String,
        clientSecret: String,
        redirectURI: String,
        scopes: [Scope] = [.read],
        code: String
    ) -> Request<Responses.Token> {
        struct Parameters: Encodable {
            private enum CodingKeys: String, CodingKey {
                case clientID = "client_id"
                case clientSecret = "client_secret"
                case redirectURI = "redirect_uri"
                case scopes = "scope"
                case code
                case grantType = "grant_type"
            }

            let clientID: String
            let clientSecret: String
            let redirectURI: String
            let scopes: String
            let code: String
            let grantType: String
        }

        let parameters = Parameters(
            clientID: clientID,
            clientSecret: clientSecret,
            redirectURI: redirectURI,
            scopes: scopes.map(\.rawValue).joined(separator: " "),
            code: code,
            grantType: "authorization_code"
        )
        let httpBody = try? JSONEncoder().encode(parameters)
        return Request(path: "/oauth/token", httpMethod: .post(httpBody))
    }

    public static func verifyCredentials() -> Request<Responses.Account> {
        Request(path: "/api/v1/accounts/verify_credentials", httpMethod: .get(nil))
    }

    public static func homeTimeline(pagination: HTTPLinkHeader? = nil) -> Request<Paged<[Responses.Toot]>> {
        let queryItems: [URLQueryItem]?
        if let pagination = pagination, let urlComponents = URLComponents(string: pagination.uriReference) {
            queryItems = urlComponents.queryItems
        } else {
            queryItems = nil
        }

        return Request(path: "/api/v1/timelines/home", httpMethod: .get(queryItems))
    }

    public static func publicTimeline(
        isLocal: Bool = false,
        pagination: HTTPLinkHeader? = nil
    ) -> Request<Paged<[Responses.Toot]>> {
        let queryItems: [URLQueryItem]?
        if let pagination = pagination, let urlComponents = URLComponents(string: pagination.uriReference) {
            queryItems = urlComponents.queryItems
        } else {
            queryItems = [URLQueryItem(name: "local", value: "\(isLocal)")]
        }

        return Request(path: "/api/v1/timelines/public", httpMethod: .get(queryItems))
    }
}