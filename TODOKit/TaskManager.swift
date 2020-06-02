//
//  TaskManager.swift
//  TODO-App
//
//  Created by Ashis Laha on 24/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import Foundation
import Intents

public struct Constants {
	
	public struct Task {
		static let primary = "primary"
		static let secondary = "secondary"
		static let createTime = "createTime"
		static let performTime = "performTime"
		static let primaryTaskDescription = "primaryTaskDescription"
		static let secondaryTaskDescription = "secondaryTaskDescription"
	}
}

// Model

public enum TaskType: Equatable {
	case primary
	case secondary
}

/// Primary Task type
public enum PrimaryTaskType: Equatable {
	case none
	case listening([Album])
	case playing([Game])
	case studying([BookAuthor])
	case coding([CodingLanguage])
	
	public func getTitle() -> String {
		var title = ""
		switch self {
		case .none: title = ""
		case .listening(_): title = "Listening"
		case .playing(_): title = "Playing"
		case .studying(_): title = "Studying"
		case .coding(_): title = "Coding"
		}
		return title
	}
	
	public func getSubTaskTitle() -> String {
		var title = ""
		switch self {
		case .none: title = ""
		case .listening(_): title = "Album Name"
		case .playing(_): title = "Game Name"
		case .studying(_): title = "Book Author"
		case .coding(_): title = "Language Name"
		}
		return title
	}
}

/// As secondary task types are heterogenous, define a protocol to make a relationship among them
/// use this protocol as a type in outside world for all secondary task.
public protocol SecondaryTaskType {
	func getTitle() -> String
	var raw: Int {get}
}

extension Album: SecondaryTaskType {
	
	public var raw: Int {
		return self.rawValue
	}
	
	public func getTitle() -> String {
		var title = ""
		switch self {
		case .hindiSongs: title = "hindi movie songs"
		case .bengaliSongs: title = "bengali songs"
		case .romanticSongs: title = "romantic songs"
		case .stories: title = "stories"
		case .unknown: title = "NA"
		}
		return title
	}
}

extension Game: SecondaryTaskType {
	
	public var raw: Int {
		return self.rawValue
	}
	
	public func getTitle() -> String {
		var title = ""
		switch self {
		case .counterStrike: title = "counter strike"
		case .needForSpeed: title = "need for speed"
		case .pokemon: title = "pokemon"
		case .pUBG: title = "PUBG"
		case .unknown: title = "NA"
		}
		return title
	}
}

extension BookAuthor: SecondaryTaskType {
	
	public var raw: Int {
		return self.rawValue
	}
	
	public func getTitle() -> String {
		var title = ""
		switch self {
		case .chetanBhagat: title = "Chetan Bhagat"
		case .simonSinek: title = "Simon Sinek"
		case .robert: title = "Robert Kiyosak"
		case .unknown: title = "NA"
		}
		return title
	}
}

extension CodingLanguage: SecondaryTaskType {
	
	public var raw: Int {
		return self.rawValue
	}
	
	public func getTitle() -> String {
		var title = ""
		switch self {
		case .swift: title = "swift"
		case .cpp: title = "c++"
		case .objectiveC: title = "Objective C"
		case .nodejs: title = "node.js"
		case .python: title = "python"
		case .unknown: title = "NA"
		}
		return title
	}
}



//MARK:- Task
public struct Task {
	
	public let primary: PrimaryTaskType
	public let secondary: SecondaryTaskType // protocol type
	public let createdTime: Date // can be treated as unique identifier to delete it
	public let performTime: Date
	
	// TODO:- remove these two properties
	// TODO:- solve how to save custom enum with associated values into Data.
	// As JSONSerialization converts an Array or Dictionary into Data when the elements inside the collection will be Int/String/Double types.
	
	public let primaryTaskDescription: String // this is used to save the data into file system, not necessary if we use core data
	public let secondaryTaskDescription: String // this is used to save the data into file system, not necessary if we use core data

	public init(primary: PrimaryTaskType,
				secondary: SecondaryTaskType,
				createTime: Date,
				performTime: Date,
				primaryDescription: String,
				secondaryDescription: String) {
		
		self.primary = primary
		self.secondary = secondary
		self.createdTime = createTime
		self.performTime = performTime
		
		self.primaryTaskDescription = primaryDescription
		self.secondaryTaskDescription = secondaryDescription
	}
	
	// define intent here
	public var intent: TODOIntent {
		let taskIntent = TODOIntent()
		
		// mapped the primaryTask to intent Int enum
		switch primary {
		case .coding(_):
			taskIntent.primaryTask = .coding
			taskIntent.setImage(INImage(named: "coding"), forParameterNamed: \TODOIntent.coding)
		case .listening(_):
			taskIntent.primaryTask = .listening
			taskIntent.setImage(INImage(named: "listening"), forParameterNamed: \TODOIntent.listening)
		case .studying(_):
			taskIntent.primaryTask = .studying
			taskIntent.setImage(INImage(named: "studying"), forParameterNamed: \TODOIntent.studying)
		case .playing(_):
			taskIntent.primaryTask = .playing
			taskIntent.setImage(INImage(named: "game"), forParameterNamed: \TODOIntent.playing)
		case .none:
			taskIntent.primaryTask = .unknown
		}
		
		switch secondary {
		case is Album:
			taskIntent.listening = Album(rawValue: secondary.raw) ?? Album.unknown
		case is Game:
			taskIntent.playing = Game(rawValue: secondary.raw) ?? Game.unknown
		case is BookAuthor:
			taskIntent.studying = BookAuthor(rawValue: secondary.raw) ?? BookAuthor.unknown
		case is CodingLanguage:
			taskIntent.coding = CodingLanguage(rawValue: secondary.raw) ?? CodingLanguage.unknown
		default: break
		}
		return taskIntent
	}
}



open class TaskManager {
	public static let shared = TaskManager()
	
	public let taskList: [PrimaryTaskType] = [
		.listening([.hindiSongs, .bengaliSongs, .romanticSongs, .stories]),
		.playing([.counterStrike, .needForSpeed, .pokemon, .pUBG]),
		.studying([.chetanBhagat, .robert, .simonSinek]),
		.coding([.swift, .objectiveC, .cpp, .nodejs, .python])
	]
	
	public lazy var tasks: [Task] = {
		return retrieveTasksFromFileSystem()
	}()
	
	public func addTask(task: Task) {
		tasks.append(task)
		saveTasksToFileSystem()
	}
	public func removeTask(taskCreatedTime: Date) {
		
		// we can optimise it using hash-table // not doing right now
		let tempTasks = tasks
		for (index, each) in tempTasks.enumerated() {
			if each.createdTime == taskCreatedTime {
				tasks.remove(at: index)
				saveTasksToFileSystem()
				break
			}
		}
	}
	public func saveTasksToFileSystem() {
		
		// save the data into file system
		guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
		let filePath = url.appendingPathComponent("tasks.txt")
		print("filePath: \(filePath.absoluteString)")
		
		do {
			// convert into data
			let dictionaries = tasks.map { convertTaskIntoDictionary($0) }
			let data = try JSONSerialization.data(withJSONObject: dictionaries, options: .prettyPrinted)
			try data.write(to: filePath)
		} catch let error {
			print("could not write to data: \(error)")
		}
	}
	
	public func retrieveTasksFromFileSystem() -> [Task] {
		
		// retrieve the data
		guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return [] }
			let filePath = url.appendingPathComponent("tasks.txt")
			print("filePath: \(filePath.absoluteString)")
		
		do {
			// convert into data
			let data = try Data(contentsOf: filePath, options: [])
			if let dictionaries = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
				let tasks = dictionaries.map { convertDictionaryToObject($0) }
				return tasks
			}
		} catch let error {
			print("could not write to data: \(error)")
		}
		return []
	}
	
	// this is needed to save a custom struct into Data
	private func convertTaskIntoDictionary(_ task: Task) -> [String: Any] {
		return [
			Constants.Task.primaryTaskDescription: task.primaryTaskDescription,
			Constants.Task.secondaryTaskDescription: task.secondaryTaskDescription,
			Constants.Task.createTime: task.createdTime.timeIntervalSince1970,
			Constants.Task.performTime: task.performTime.timeIntervalSince1970
		]
	}
	
	private func convertDictionaryToObject(_ dict: [String: Any]) -> Task {
		return Task(primary: PrimaryTaskType.none, // as we are not saving the primary, assigning a random value
			secondary: Album.unknown, // as we are not saving the primary, assigning a random value
			createTime: Date(timeIntervalSince1970: (dict[Constants.Task.createTime] as? Double ?? 0.0)),
			performTime: Date(timeIntervalSince1970: dict[Constants.Task.performTime] as? Double ?? 0.0),
			primaryDescription: dict[Constants.Task.primaryTaskDescription] as? String ?? "",
			secondaryDescription: dict[Constants.Task.secondaryTaskDescription] as? String ?? "")
	}
}
