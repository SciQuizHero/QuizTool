import ArgumentParser
import TabularData
import Foundation


@main
struct QuizTool: ParsableCommand {
    @Option(name: [.short, .customLong("input")], help: "The path to the directory which contains the quiz in json format.")
    var inputPath: String?
    @Flag(name: [.short, .customLong("pretty")], help: "Pretty prints the json in tabular data format.")
    var prettyPrint: Bool = false
    @Flag(name: [.short, .customLong("verbose")], help: "Prints all quiz data.")
    var verbose: Bool = false

    mutating func run() throws {
        guard let inputPath else {
            throw RuntimeError("Couldn't read from provided input!")
        }
        let quizes = QuizClient.production.load(inputPath)

        guard prettyPrint else {
            print("Number of total quizes: \(quizes.count)")
            print("Total questions count: \(quizes.map(\.questions).map(\.count).reduce(0, +))")
            return
        }

        if verbose {
            struct QuizDetails: Encodable {
                var category: String, difficulty: String, questions: Int
            }
            let counters = quizes.map { quiz in
                QuizDetails(
                    category: quiz.category,
                    difficulty: quiz.difficulty,
                    questions: quiz.questions.count
                )
            }
            let data = try JSONEncoder().encode(counters)
            let dataFrame = try DataFrame(jsonData: data)
            print(dataFrame.description(options: .init(maximumLineWidth: 400)))
        } else {
            struct QuizCounter: Encodable {
                var quizes: Int, questions: Int
            }
            let counter = QuizCounter(
                quizes: quizes.count,
                questions: quizes.map(\.questions).map(\.count).reduce(0, +)
            )
            let data = try JSONEncoder().encode([counter])
            let dataFrame = try DataFrame(jsonData: data)
            print(dataFrame.description(options: .init(maximumLineWidth: 400)))
        }
    }
}
