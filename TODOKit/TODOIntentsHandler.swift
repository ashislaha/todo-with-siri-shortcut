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
	
	// Resolve & confirm
	public func resolvePrimaryTask(for intent: TODOIntent, with completion: @escaping (PrimaryTaskResolutionResult) -> Void) {
		
	}
	
	public func resolveListening(for intent: TODOIntent, with completion: @escaping (AlbumResolutionResult) -> Void) {
		
	}
	
	public func resolvePlaying(for intent: TODOIntent, with completion: @escaping (GameResolutionResult) -> Void) {
		
	}
	
	public func resolveStudying(for intent: TODOIntent, with completion: @escaping (BookAuthorResolutionResult) -> Void) {
		
	}
	
	public func resolveCoding(for intent: TODOIntent, with completion: @escaping (CodingLanguageResolutionResult) -> Void) {
		
	}
	
	
	// Handle
	public func handle(intent: TODOIntent, completion: @escaping (TODOIntentResponse) -> Void) {
		
	}
}
