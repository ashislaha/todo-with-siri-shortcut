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
	
	public func handle(intent: TODOIntent, completion: @escaping (TODOIntentResponse) -> Void) {
		
	}
	
	public func resolvePrimaryTask(for intent: TODOIntent, with completion: @escaping (PrimaryTaskResolutionResult) -> Void) {
		
	}
	
	public func resolveListening(for intent: TODOIntent, with completion: @escaping (ListeningSubTaskResolutionResult) -> Void) {
		
	}
	
	public func resolvePlaying(for intent: TODOIntent, with completion: @escaping (PlayingSubTaskResolutionResult) -> Void) {
		
	}
	
	public func resolveStudying(for intent: TODOIntent, with completion: @escaping (StudyingSubTaskResolutionResult) -> Void) {
		
	}
	
	public func resolveCoding(for intent: TODOIntent, with completion: @escaping (CodingSubTaskResolutionResult) -> Void) {
		
	}
}
