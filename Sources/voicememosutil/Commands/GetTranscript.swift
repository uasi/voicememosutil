// SPDX-License-Identifier: 0BSD

import AVFoundation
import ArgumentParser
import Foundation

struct GetTranscript: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Get transcript from a Voice Memos recording."
    )

    @Option(name: .shortAndLong, help: "Output format.")
    var format: Format = .text

    @Argument(help: "Path to the .m4a Voice Memos file.")
    var file: String

    mutating func run() async throws {
        let transcript = try await Transcript(audioURL: URL(fileURLWithPath: file))

        switch format {
        case .json:
            let jsonData = try transcript.formattedJSONData()
            FileHandle.standardOutput.write(jsonData)
            print("")
        case .raw:
            FileHandle.standardOutput.write(transcript.data)
        case .text:
            let text = try transcript.text()
            print(text)
        }
    }
}

extension GetTranscript {
    enum Format: String, ExpressibleByArgument, CaseIterable {
        case json
        case raw
        case text
    }
}
