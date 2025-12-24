import Testing

@testable import voicememosutil

struct TranscriptTests {
    @Test("text(): interleaved format")
    func textInterleaved() throws {
        let data = try loadResource("transcript_interleaved.json")
        let text = try Transcript(data: data).text()
        #expect(text == "This is the transcript text interleaved with attributes.")
    }

    @Test("text(): separated format")
    func textSeparated() throws {
        let data = try loadResource("transcript_separated.json")
        let text = try Transcript(data: data).text()
        #expect(text == "In this format text is interleaved with indices of attributes.")
    }
}
