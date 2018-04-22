//
//  Constants.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import SpriteKit

enum PhysicsMask {
    
    static let player: UInt32 = 0x1 << 1    // 2
    static let bullet: UInt32 = 0x1 << 2    // 4
    static let enemy: UInt32 = 0x1 << 3     // 8

}

enum Z {
    static let background: CGFloat = -1.0
    static let sprites: CGFloat = 10.0
    static let HUD: CGFloat = 100.0
    
}

enum SpriteSize {
    static let player = CGSize(width: 36, height: 64)
    static let enemy = CGSize(width: 30, height: 30)
    static let bullet = CGSize(width: 10, height: 10)
    static let button = CGSize(width: 50, height: 50)
    
}


