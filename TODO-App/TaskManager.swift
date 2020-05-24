//
//  TaskManager.swift
//  TODO-App
//
//  Created by Ashis Laha on 24/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import Foundation
import Intents

// Model

enum PrimaryTaskType {
	case none
	case listening
	case playing
	case studying
	case coding
	
	func getTitle() -> String {
		var title = ""
		switch self {
		case .none: title = ""
		case .listening: title = "Listening"
		case .playing: title = "Playing"
		case .studying: title = "Studying"
		case .coding: title = "Coding"
		}
		return title
	}
	
	func getSubTaskTitle() -> String {
		// this could be array of enum
		var title = ""
		switch self {
		case .none: title = ""
		case .listening: title = "Album Name"
		case .playing: title = "Game Name"
		case .studying: title = "Book Name"
		case .coding: title = "Language Name"
		}
		return title
	}
	
	func mappedToSubTask() -> SecondaryTaskType {
		var SecondaryTaskType: SecondaryTaskType = .none
		switch self {
		case .none: SecondaryTaskType = .none
		case .listening: SecondaryTaskType = .albums(colletion: ["hindi movie songs", "bengali songs", "romantic songs", "stories"])
		case .playing: SecondaryTaskType = .games(list: ["counter strike", "need for speed", "pokemon", "PUBG"])
		case .studying: SecondaryTaskType = .books(names: ["chetan bhagat", "simon sinek", "Robert Kiyosaki"])
		case .coding: SecondaryTaskType = .coding(languages: ["swift", "objc", "c++", "python", "node.js"])
		}
		return SecondaryTaskType
	}
}

enum SecondaryTaskType {
	case none
	case albums(colletion:[String])
	case games(list:[String])
	case books(names:[String])
	case coding(languages: [String])
}

enum TaskType {
	case primary
	case secondary
}

// define Task
struct Task {
	let primaryDescription: String
	let secondaryDescription: String
	let createdTime: Date // can be treated as unique identifier to delete it
	let performTime: Date
	
	// define intent here
	// every task should be associated with an TaskIntent - will be created later.
	var intent: INIntent {
		return INIntent()
	}
}

class TaskManager {
	static let shared = TaskManager()
	
	var tasks: [Task] = []
	
	public func addTask(task: Task) {
		tasks.append(task)
	}
	public func removeTask(taskCreatedTime: Date) {
		
		// we can optimise it using hash-table // not doing right now
		let tempTasks = tasks
		for (index, each) in tempTasks.enumerated() {
			if each.createdTime == taskCreatedTime {
				tasks.remove(at: index)
				break
			}
		}
	}
}
