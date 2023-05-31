//
//  File.swift
//  
//
//  Created by nikola.stojanovic.ext on 1.6.23..
//

import Foundation

struct QuizClient {
    var load: (_ inputPath: String) -> [Quiz]

    static var production: Self {
        .init { inputPath in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dataFiles = getAllData(in: inputPath)
            let quizes = dataFiles.compactMap { try? decoder.decode(Quiz.self, from: $0) }
            return quizes
        }
    }
}

private func getAllData(in folder: String) -> [Data] {
    let fileManager = FileManager.default
    var dataFiles = [Data]()

    do {
        // Get the folder's URL
        let directoryURL = URL(fileURLWithPath: folder, isDirectory: true)

        // Get the contents of the directory
        let contentOfFolder = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)

        for url in contentOfFolder {
            var isDir: ObjCBool = false

            if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
                if isDir.boolValue {
                    // This url is a directory
                    let subfolderData = getAllData(in: url.path)
                    dataFiles.append(contentsOf: subfolderData)
                } else {
                    // This url is a file
                    if url.pathExtension == "json" {
                        if let data = fileManager.contents(atPath: url.path) {
                            dataFiles.append(data)
                        }
                    }
                }
            }
        }
    } catch {
        print("Error while enumerating files \(folder): \(error.localizedDescription)")
    }

    return dataFiles
}
