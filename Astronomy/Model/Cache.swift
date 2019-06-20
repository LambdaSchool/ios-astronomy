//
//  Cache.swift
//  Astronomy
//
//  Created by Thomas Cacciatore on 6/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "CacheQueue")
    private var cachedImages: [Key : Value] = [:]
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedImages.updateValue(value, forKey: key)
        }
    }

    func value(for key: Key) -> Value? {
        return queue.sync {
            cachedImages[key]
        }
    }
}
