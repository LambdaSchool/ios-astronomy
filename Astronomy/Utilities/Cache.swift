//
//  Cache.swift
//  Astronomy
//
//  Created by Wyatt Harrell on 4/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    var dict: [Key : Value] = [:]
    
    func cache(value: Value, for key: Key) {
        dict[key] = value
    }
    
    func value(for key: Key) -> Value? {
        return dict[key] ?? nil
    }
    
}
