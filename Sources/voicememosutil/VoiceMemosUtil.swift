// SPDX-License-Identifier: 0BSD

import ArgumentParser

@main
struct VoiceMemosUtil: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "voicememosutil",
        abstract: "A utility to manage Apple Voice Memos recordings.",
        subcommands: [GetTranscript.self]
    )
}
