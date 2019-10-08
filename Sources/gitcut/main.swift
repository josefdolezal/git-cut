import Foundation

func process(path: String, arguments: [String]) throws -> String {
    let process = Process()
    let output = Pipe()

    process.currentDirectoryPath = FileManager.default.currentDirectoryPath
    process.executableURL = URL(fileURLWithPath: "/usr/bin/" + path)
    process.arguments = arguments
    process.standardOutput = output
    try process.run()
    process.waitUntilExit()

    let outputData = output.fileHandleForReading.readDataToEndOfFile()
    return String(data: outputData, encoding: .utf8) ?? ""
}

@discardableResult
func git(_ cmd: String, arguments: [String] = []) throws -> String {
    try process(path: "git", arguments: [cmd] + arguments)
}

let branches = try git("branch")
    // List branches
    .split(separator: "\n")
    // Filter out current branch
    .filter { !$0.starts(with: "*") }
    // Remove white spaces
    .map { $0.trimmingCharacters(in: .whitespaces) }

for branch in branches {
    var command: String?

    while true {
        print("Do you want to remove branch '\(branch)'? [N/y]")
        command = readLine(strippingNewline: true)?.lowercased()

        guard let command = command else {
            break
        }

        if command == "y" {
            try git("branch", arguments: ["-D", branch])
            break
        } else if command == "n" || command == "" {
            print("skipping")
            break
        }
    }
}

