# voicememosutil

A command-line utility to manage Apple Voice Memos recordings.

## Requirements

- macOS 15+

## Installation

Build from source using Swift 6.2+:

```bash
swift build -c release
cp .build/release/voicememosutil /usr/local/bin/
```

## Usage

```bash
voicememosutil get-transcript [--format <format>] <file>
```

### Arguments

- `<file>`: Path to the `.m4a` Voice Memos file.

Voice Memos recordings are stored at:

```
~/Library/Group Containers/group.com.apple.VoiceMemos.shared/Recordings
```

(Only available if iCloud sync is enabled for Voice Memos)

### Options

- `--format <format>`: Output format. One of:
    - `text`: Plain text transcript (default)
    - `json`: Transcript data as JSON
    - `raw`: Raw binary transcript data

### JSON output format

Returns the full transcript metadata including timing information. Two formats are used depending on the source:

**Interleaved format:**

```json
{
  "attributedString": [
    "This is",
    { "timeRange": [0, 0.42] },
    " the transcript text",
    { "timeRange": [0.42, 1.23] },
    " interleaved with attributes.",
    { "timeRange": [1.23, 2.00] }
  ],
  "locale": { "identifier": "en_US", "current": 0 }
}
```

**Separated format:**

```json
{
  "attributedString": {
    "attributeTable": [
      { "timeRange": [0, 0.42] },
      { "timeRange": [0.42, 1.23] },
      { "timeRange": [1.23, 2.00] }
    ],
    "runs": [
      "In this format",
      0,
      " text is interleaved with",
      1,
      " indices of attributes.",
      2
    ]
  },
  "locale": { "identifier": "en_US", "current": 0 }
}
```

### Raw output format

Outputs the raw binary transcript data from the audio file. While typically identical to the JSON output, the raw format is unvalidated and may contain malformed JSON.
