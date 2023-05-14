import Foundation

public enum AuthenticationType {
    case header(HTTPHeader)
    case bearer(String)
}

extension AuthenticationType {
    var header: HTTPHeader {
        switch self {
        case let .header(header):
            return header
        case let .bearer(token):
            return HTTPHeader(key: "authorization", value: "Bearer \(token)")
        }
    }
}
