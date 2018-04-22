//
//  HUD.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let scoreLabel = SKLabelNode(fontNamed:"Courier")
    let timerLabel = SKLabelNode(fontNamed:"Courier")
    let buttonFire = SKSpriteNode(imageNamed: "buttonFire-normal")
    
    var score: Int {
        get {
            return GameManager.shared.score
        }
        set {
            GameManager.shared.score += newValue
            scoreLabel.text = "Score: \(GameManager.shared.score)"
        }
    }
    
    override init() {
        super.init()
        self.name = "HUD"
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.zPosition = Z.HUD
        
        timerLabel.text = "Timer: 30"
        timerLabel.fontSize = 20
        timerLabel.zPosition = Z.HUD
        
        buttonFire.name = "buttonFire"
        buttonFire.anchorPoint = CGPoint.zero
        buttonFire.zPosition = Z.HUD
    }
    
    func setup(size: CGSize) {
        let spacing: CGFloat = 10
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: spacing, y: size.height - scoreLabel.frame.height - spacing)
        addChild(scoreLabel)
        
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width - spacing, y: size.height - timerLabel.frame.height - spacing - 100)
        addChild(timerLabel)
        
        buttonFire.position = CGPoint(x: size.width/2 + CGFloat(20), y: size.height/2 + CGFloat(20))
        buttonFire.size = SpriteSize.button
        buttonFire.setScale(2.5)
        addChild(buttonFire)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


