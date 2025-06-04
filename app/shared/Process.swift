
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension Process {

    enum ShellExitStatus {
        case ok
        case error(Int32)
        case fatal
    }

    static func shell(path: String = "/bin/zsh", args: [String] = []) -> (ShellExitStatus, String?, String?) {
        let task = Process()
        let pipeOut = Pipe()
        let pipeErr = Pipe()
        task.standardInput = nil
        task.standardOutput = pipeOut
        task.standardError = pipeErr
        task.executableURL = URL(fileURLWithPath: path)
        task.arguments = args
        do {
            try task.run()
            task.waitUntilExit()
            let dataOut = pipeOut.fileHandleForReading.readDataToEndOfFile()
            let dataErr = pipeErr.fileHandleForReading.readDataToEndOfFile()
            return (
                task.terminationStatus == 0 ?
                    ShellExitStatus.ok :
                    ShellExitStatus.error(task.terminationStatus),
                dataOut.isEmpty ? nil : String(data: dataOut, encoding: .utf8),
                dataErr.isEmpty ? nil : String(data: dataErr, encoding: .utf8)
            )
        } catch {
            return (
                ShellExitStatus.fatal,
                nil,
                nil
            )
        }
    }

    static func getGroups() -> [String] {
        var result: [String] = []

        let (status, output, error) = Process.shell(
            path: "/usr/bin/env",
            args: ["zsh", "-c", "groups"]
        )

        switch status {
            case .fatal:
                #if DEBUG
                    print("Shell fatal")
                #endif
                return []
            case .error(let code):
                #if DEBUG
                    print("Shell error code: \(code)")
                    print("Shell error: \(String(describing: error))")
                #endif
                return []
            case .ok:
                guard let output else {
                    #if DEBUG
                        print("shell output result == nil")
                    #endif
                    return []
                }
                output.split(separator: " ").forEach { value in
                    result.append(String(value))
                }
        }

        return result
    }

}
