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
		guard let _ = (scene as? UIWindowScene) else { return }
	}
	
	
	/// this method is getting called when we support multi-window feature 
	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
	
		guard let windowScene = scene as? UIWindowScene,
		let navigationVC = windowScene.windows.first?.rootViewController as? UINavigationController,
			let historyVC = navigationVC.viewControllers.first as? HistoryViewController else { return }
		
		// intent
		if let intent = userActivity.interaction?.intent as? TODOIntent,
			let task = Task.createTask(from: intent) {
			
			TaskManager.shared.addTask(task: task)
			historyVC.showTask(task: task)
		}
		
		// useractivity
		if userActivity.activityType == Constants.UserActivity.createTaskByUserActivity {
			historyVC.gotoNewTaskPage()
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
}

