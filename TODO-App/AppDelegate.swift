//
//  AppDelegate.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		INPreferences.requestSiriAuthorization { (status) in
			if status == .authorized {
				print("the user allows the siri authentication request")
			}
		}
		return true
	}
	
	/// this method is getting called when we do not support multi-window feature - useful for single window feature
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		
		guard let intent = userActivity.interaction?.intent as? TODOIntent,
			let task = Task.createTask(from: intent) else { return false }
		
		TaskManager.shared.addTask(task: task)
		
		guard let keyWindow = UIApplication.shared.delegate?.window,
			let navigationController = keyWindow?.rootViewController as? UINavigationController,
			let historyVC = navigationController.visibleViewController as? HistoryViewController else { return false }
		
		historyVC.showTask(task: task)
		return true
	}
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}	
}

