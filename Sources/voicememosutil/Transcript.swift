// SPDX-License-Identifier: 0BSD

import AVFoundation
import Foundation

private let isoUserDataKeyTranscript = AVMetadataKey("tsrp")

struct Transcript {
    let data: Data

    init(audioURL: URL) async throws {
        self.data = try await extractTranscript(audioURL: audioURL)
    }

    init(data: Data) {
        self.data = data
    }

    func jsonObject() throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data)
        } catch {
            throw Error.invalidFormat
        }
    }

    func formattedJSONData() throws -> Data {
        let jsonObject = try jsonObject()
        return try JSONSerialization.data(
            withJSONObject: jsonObject,
            options: [.sortedKeys, .withoutEscapingSlashes])
    }

    func text() throws -> String {
        let json = try jsonObject()

        guard let root = json as? [String: Any],
            let attributedString = root["attributedString"]
        else {
            throw Error.invalidFormat
        }

        if let interleaved = attributedString as? [Any] {
            let strings = interleaved.compactMap { $0 as? String }
            guard !strings.isEmpty else {
                throw Error.invalidFormat
            }
            return strings.joined()
        }

        if let separated = attributedString as? [String: Any],
            let runs = separated["runs"] as? [Any]
        {
            let strings = runs.compactMap { $0 as? String }
            guard !strings.isEmpty else {
                throw Error.invalidFormat
            }
            return strings.joined()
        }

        throw Error.invalidData
    }
}

extension Transcript {
    enum Error: Swift.Error, CustomStringConvertible {
        case failedToLoadFile
        case failedToLoadMetadata
        case invalidData
        case invalidFormat
        case noTrackFound
        case noTranscriptFound

        var description: String {
            switch self {
            case .failedToLoadFile:
                return "Failed to load file"
            case .failedToLoadMetadata:
                return "Failed to load metadata from track"
            case .invalidData:
                return "Invalid transcript data"
            case .invalidFormat:
                return "Invalid transcript format"
            case .noTrackFound:
                return "No track found in the audio"
            case .noTranscriptFound:
                return "No transcript metadata found in the track"
            }
        }
    }
}

private func extractTranscript(audioURL: URL) async throws -> Data {
    let asset = AVURLAsset(url: audioURL)

    guard (try? await asset.load(.isReadable)) == true else {
        throw Transcript.Error.failedToLoadFile
    }

    guard let track = (try? await asset.load(.tracks))?.first else {
        throw Transcript.Error.noTrackFound
    }

    guard let metadata = try? await track.load(.metadata) else {
        throw Transcript.Error.failedToLoadMetadata
    }

    let transcripts = AVMetadataItem.metadataItems(
        from: metadata, withKey: isoUserDataKeyTranscript, keySpace: .isoUserData)

    guard let transcript = transcripts.first else {
        throw Transcript.Error.noTranscriptFound
    }

    guard let data = (try? await transcript.load(.value)) as? Data else {
        throw Transcript.Error.invalidData
    }

    return data
}
