//
//  Cache.swift
//  Astronomy
//
//  Created by Isaac Lyons on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "CacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return dictionary[key]
        }
    }
}
