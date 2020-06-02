//
//  IntentHandler.swift
//  TODOIntents
//
//  Created by Ashis Laha on 28/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import Intents
import TODOKit

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
		
		guard intent is TODOIntent else {
			fatalError("unhandled intent type: \(intent)")
		}
		return TODOIntentsHandler()
    }
    
}
