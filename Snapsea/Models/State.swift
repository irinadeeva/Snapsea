//
//  State.swift
//  Snapsea
//
//  Created by Irina Deeva on 12/09/24.
//

import Foundation

enum State<T> {
    case initial
    case loading
    case failed(Error)
    case data(T)
}
