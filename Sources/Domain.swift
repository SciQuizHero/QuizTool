//
//  File.swift
//  
//
//  Created by nikola.stojanovic.ext on 1.6.23..
//

import Foundation

struct Quiz: Codable, Identifiable {
    struct Question: Codable {
        var id: UUID
        var question: String
        var options: [String]
        var correctAnswer: String

        enum CodingKeys: CodingKey {
            case id
            case question
            case options
            case correctAnswer
        }

        init(id: UUID, question: String, options: [String], correctAnswer: String) {
            self.id = id
            self.question = question
            self.options = options
            self.correctAnswer = correctAnswer
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let id = try container.decode(String.self, forKey: .id)
            guard let uuid = UUID(uuidString: id)
            else {
                throw RuntimeError("Invalid UUID with id: \(id)")
            }
            self.id = uuid
            self.question = try container.decode(String.self, forKey: .question)
            self.options = try container.decode([String].self, forKey: .options)
            self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        }
    }
    var id = UUID()
    var category: String
    var difficulty: String
    var questions: [Question]

    enum CodingKeys: CodingKey {
        case category
        case difficulty
        case questions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(String.self, forKey: .category)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.questions = try container.decode([Quiz.Question].self, forKey: .questions)
    }

    init(id: UUID = UUID(), category: String, difficulty: String, questions: [Quiz.Question]) {
        self.id = id
        self.category = category
        self.difficulty = difficulty
        self.questions = questions
    }
}

enum Category: String, CaseIterable, Identifiable {
    // Astronomy
    case solarSystems = "solar-systems"
    case cosmology
    // Biology
    case anatomyPhysiology = "anatomy-physiology"
    case botany
    case cellBiology = "cell-biology"
    case genetics
    case microbiology
    case zoology
    // Chemistry
    case analyticalChemistry = "analytical-chemistry"
    case biochemistry
    case organicChemistry = "organic-chemistry"
    case inorganicChemistry = "inorganic-chemistry"
    // Computer Science
    case artificialIntelligence = "artificial-intelligence"
    case dataStructures = "data-structures"
    case networking
    case programmingLanguages = "programming-languages"
    // Earth Science
    case meteorology
    case paleontology
    // Engineering
    case civilEngineering = "civil-engineering"
    case electricalEngineering = "electrical-engineering"
    case mechanicalEngineering = "mechanical-engineering"
    // Environmental Science
    case ecosystems
    case pollution
    // Mathematics
    case algebra
    case calculus
    case geometry
    case numberTheory = "number-theory"
    case statisticsProbability = "statistics-probability"
    case trigonometry
    // Medicine
    case pharmacology
    case medicalTerminology = "medical-terminology"
    case publicHealth = "public-health"
    // Physics
    case mechanics
    case thermodynamics
    case quantumMechanics = "quantum-mechanics"

    var id: Self {
        self
    }
}

enum Difficulty: String, CaseIterable {
    case easy, medium, hard
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }
}
