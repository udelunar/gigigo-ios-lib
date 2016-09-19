//
//  Instantiator.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 22/8/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public enum ErrorInstantiation: Error {
	case instantiateFromIdentifier
	case instantiateIntial
}


/// Implement this protocol in order to use Instantiator
public protocol Instantiable {
	static func storyboard() -> String
	
	/// Needs to be overriden, but is recomended to use and extension in your project
	static func bundle() -> Bundle
	
	/// Override is optional. If nil, instantiateInitialViewController will be used. Nil by default
	static func identifier() -> String?	//
}

extension Instantiable {
	static func identifier() -> String? {
		return nil
	}
}


/**
Instantiate a ViewController from the Storyboard

### Usage:
Initialize an Instantiator specifying the generic ViewController class to instantiate and the call `func viewController() throws -> ViewController`

### Example:
```
let instantiator = Instantiator<LoginVC>()
let loginVC: LoginVC? = try? instantiator.viewController()
```

- important: The ViewController **must** implement Instantiable protocol
- Author: Alejandro Jiménez
- Since: 1.2.1
*/
public struct Instantiator<ViewController: Instantiable> {
	
	public init() { }
	
	/**
	Instantiate the
	
	- throws: An error of type ErrorInstantiation
	- returns: An ViewController object (already downcasted)
	- Author: Alejandro Jiménez
	- Since: 1.2.1
	*/
	public func viewController() throws -> ViewController {
		let bundle = ViewController.bundle()
		let storyboard = UIStoryboard(name: ViewController.storyboard(), bundle: bundle)
		var viewController: UIViewController?
		
		if let identifier = ViewController.identifier() {
			viewController = storyboard.instantiateViewController(withIdentifier: identifier)
		
		} else {
			guard let vc = storyboard.instantiateInitialViewController() else {
				self.logError()
				throw ErrorInstantiation.instantiateIntial
			}
			
			viewController = vc
		}
		
		guard let downcastedVC = viewController as? ViewController else {
			self.logError()
			throw ErrorInstantiation.instantiateFromIdentifier
		}
		
		return downcastedVC
	}
	
	fileprivate func logError() {
		let identifierLog = ViewController.identifier() != nil ? ViewController.identifier() : "initial view controller"
		LogWarn("Could not instantiate view controller from storyboard: \(ViewController.storyboard()), identifier: \(identifierLog)")
	}
	
}