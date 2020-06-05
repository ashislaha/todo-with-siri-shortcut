//
//  SceneDelegate.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let _ = (scene as? UIWindowScene) else { return }
		
		// activity with unique_id
		let userActivities = connectionOptions.userActivities
		for each in userActivities {
			if each.activityType == "com.myapp.name.todo-task-activity" {
				
				// retrieve info dictionary
				print("here")
				print(each.userInfo ?? [:])
			}
		}
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}

	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		if userActivity.activityType == "com.myapp.name.todo-task-activity",
			let _ = userActivity.userInfo as? [String: String] {
			print(userActivity.userInfo ?? [:])
			//return true
		}
		else if userActivity.activityType == "TODOIntent", let _ = userActivity.interaction?.intent as? TODOIntent{
			print(userActivity.activityType)
			
		}
		print(userActivity.userInfo ?? [:])
		
		guard let intent = userActivity.interaction?.intent as? TODOIntent,
			let task = Task.createTask(from: intent) else { return }
		
		// this will add a new task and override the existing tasks
		// it should be append, instead of overriding the existing tasks
		// TODO:- fix it later
		TaskManager.shared.addTask(task: task)
		
		// show an alert that a new task is created
		/*
		let alert = UIAlertController(title: "New Task Created", message: nil, preferredStyle: .alert)
		let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
			alert.dismiss(animated: true, completion: nil)
		}
		alert.addAction(okayAction)
		*/
//>>>>>>> 966d0cfeb7a00e5dab9f8147219eded0601460bb
	}
}

