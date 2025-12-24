import Foundation

func loadResource(_ name: String) throws -> Data {
    guard
        let url = Bundle.module.url(
            forResource: name, withExtension: nil, subdirectory: "Resources")
    else {
        throw ResourceError.notFound(name)
    }
    return try Data(contentsOf: url)
}

enum ResourceError: Error {
    case notFound(String)
}
