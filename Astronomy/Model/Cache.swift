//
//  Cache.swift
//  Astronomy
//
//  Created by Enrique Gongora on 3/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var storage = [Key: Value]()
    private let queue = DispatchQueue(label: "CacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            self.storage[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return storage[key] ?? nil
        }
    }
}
