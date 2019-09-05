//
//  Cache.swift
//  Astronomy
//
//  Created by Marlon Raskin on 9/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

	private(set) var cachedItems: [Key: Value] = [:]

	func cache(value: Value, for key: Key) {
		cachedItems[key] = value
	}

	func value(for key: Key) -> Value? {
		return cachedItems[key]
	}
}
