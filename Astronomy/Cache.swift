//
//  Cache.swift
//  Astronomy
//
//  Created by Lambda_School_Loaner_34 on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var items: [Key: Value] = [:]
    
    //Implement cache(value:, for:) and value(for:) methods to add items to the cache and remove them, respectively.
    //I don't really understand this.
    //add
    func cache(value: Value, for key: Key) {
        items[key] = value
    }
    //remove
    func value(for key: Key) -> Value?{
        return items[key]
    }
}
