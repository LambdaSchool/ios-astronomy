//
//  Cache.swift
//  Astronomy
//
//  Created by Karen Rodriguez on 4/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cache: [Key : Value] = [ : ]
    private var queue = DispatchQueue(label: "Cache serial queue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return self.cache[key]
        }
        
    }
}
