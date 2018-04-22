//
//  GameManager.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import SpriteKit

class GameManager {
    static let shared = GameManager()
    
    var score: Int = 0
    var appCounted: Bool = false
    var monstersKills: Int = 0
    var timerCounter: Int = 30
    
    // Textures
    var allTextures: [SKTexture] = []
    
}
