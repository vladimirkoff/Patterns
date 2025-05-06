//
//  Options+Extensions.swift
//

extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return !isNil
    }
}
