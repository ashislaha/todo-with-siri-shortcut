//
//  TODOIntentsHandler.swift
//  TODOKit
//
//  Created by Ashis Laha on 28/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import Foundation
import Intents

public class TODOIntentsHandler: NSObject, TODOIntentHandling {
	
	//MARK:- 1. Resolve
	public func resolvePrimaryTask(for intent: TODOIntent, with completion: @escaping (PrimaryTaskResolutionResult) -> Void) {
		
		// if primary task is not defined, then ask the user to provide it
		guard intent.primaryTask != .unknown else {
			completion(PrimaryTaskResolutionResult.needsValue())
			return
		}
		
		// if primary task is available, proceed further
		completion(PrimaryTaskResolutionResult.success(with: intent.primaryTask))
	}
	
	public func resolveListening(for intent: TODOIntent, with completion: @escaping (AlbumResolutionResult) -> Void) {
		
		if intent.listening == .unknown {
			completion(AlbumResolutionResult.needsValue())
		} else {
			completion(AlbumResolutionResult.success(with: intent.listening))
		}
	}
	
	public func resolvePlaying(for intent: TODOIntent, with completion: @escaping (GameResolutionResult) -> Void) {
		if intent.playing == .unknown {
			completion(GameResolutionResult.needsValue())
		} else {
			completion(GameResolutionResult.success(with: intent.playing))
		}
	}
	
	public func resolveStudying(for intent: TODOIntent, with completion: @escaping (BookAuthorResolutionResult) -> Void) {
		if intent.studying == .unknown {
			completion(BookAuthorResolutionResult.needsValue())
		} else {
			completion(BookAuthorResolutionResult.success(with: intent.studying))
		}
	}
	
	public func resolveCoding(for intent: TODOIntent, with completion: @escaping (CodingLanguageResolutionResult) -> Void) {
		if intent.coding == .unknown {
			completion(CodingLanguageResolutionResult.needsValue())
		} else {
			completion(CodingLanguageResolutionResult.success(with: intent.coding))
		}
	}
	
	//MARK:- 2. confirm intent
	public func confirm(intent: TODOIntent, completion: @escaping (TODOIntentResponse) -> Void) {
		
		guard let task = Task.createTask(from: intent) else {
			print("intent does not contains all the necessary information to create a task")
			completion(TODOIntentResponse(code: .failure, userActivity: nil))
			return
		}
		guard task.primary != .none else {
			print("primary task must be present")
			completion(TODOIntentResponse(code: .unspecified, userActivity: nil))
			return
		}
		
		completion(TODOIntentResponse(code: .ready, userActivity: nil))
	}
	
	//MARK:- 3. Handle Intent (once it is resolved & confirmed)
	public func handle(intent: TODOIntent, completion: @escaping (TODOIntentResponse) -> Void) {
		
		// the user confirmed the primary and secondary task, let's create the "Task" object and add to TaskManager list
		if let task = Task.createTask(from: intent) {
			TaskManager.shared.addTask(task: task)
			
			// update useractivity
			let userActivity = NSUserActivity(activityType: Constants.UserActivity.createTaskByIntent)
			userActivity.addUserInfoEntries(from: ["DidCreatedTask": true])
			
			//let response = TODOIntentResponse(code: .continueInApp, userActivity: userActivity) // if we want to open the app
			let response = TODOIntentResponse.success(primary: intent.primaryTask)
			response.userActivity = userActivity
			completion(response)
			
		} else {
			// there is some error to create a task
			let userActivity = NSUserActivity(activityType: Constants.UserActivity.createTaskByIntent)
			userActivity.addUserInfoEntries(from: ["DidCreatedTask": false])
			
			let response = TODOIntentResponse.failure(primary: intent.primaryTask)
			response.userActivity = userActivity
			completion(response)
		}
	}
}
