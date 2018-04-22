//
//  Player.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    // Textures
    var textureIdle: [SKTexture] = []
    var textureWalk: [SKTexture] = []
    var textureFire: [SKTexture] = []
    
    // Manual Movement
    var destination = CGPoint()
    let velocity: CGFloat = 250
    let playerMovePointsPerSec: CGFloat = 480.0
    var playerVelocity = CGPoint.zero
    var lastTouchLocation: CGPoint?
    let playerRotateRadiansPerSec: CGFloat = 4.0 * π
    
    init() {
        self.textureIdle = GameManager.shared.allTextures.filter { $0.description.contains("idle") }
        self.textureWalk = GameManager.shared.allTextures.filter { $0.description.contains("walk") }
        self.textureFire = GameManager.shared.allTextures.filter { $0.description.contains("fire") }
        super.init(texture: textureIdle[0], color: .clear, size: SpriteSize.player)
        self.name = "player"
        self.texture?.filteringMode = .nearest
    }
    
    // Creating the player
    func setup(view: SKView) {
        self.position = CGPoint(x: view.frame.midX, y: self.size.height)
        destination = position
        
        // Physics
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        //    self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.mass = 4.0
        self.physicsBody!.isDynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsMask.player
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.restitution = 0.4
        
        self.animate(type: "idle")
    }
    
    // Functions for moving and animating the player
    func setDestination(destination: CGPoint) {
        self.destination = destination
        self.animate(type: "walk")
    }
    
    func update(deltaTime: TimeInterval) {
        // Calculate Distance
        let distanceX = fabs(destination.x - position.x)
        let distanceY = fabs(destination.y - position.y)
        
        // Change Orientation
        rotate(deltaTime: deltaTime)
        
        
        let deltaMove = velocity * CGFloat(deltaTime)
        if (distanceX > deltaMove) || (distanceY > deltaMove) {
            move(deltaTime: deltaTime)
        } else if distanceX > 0.1 || distanceY > 0.1 {
            position = destination
            self.animate(type: "idle")
        }
    }
    
    func move(deltaTime: TimeInterval) {
        let amountToMove = playerVelocity * CGFloat(deltaTime)
        self.position += amountToMove
    }
    
    func movePlayerToward(location: CGPoint) {
        self.animate(type: "walk")
        let offset = location - self.position
        let direction = offset.normalized()
        playerVelocity = direction * playerMovePointsPerSec
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        movePlayerToward(location: touchLocation)
        
    }
    
    func rotate(deltaTime: TimeInterval) {
        let shortest = shortestAngleBetween(angle1: self.zRotation, angle2: playerVelocity.angle)
        let amountToRotate = min(playerRotateRadiansPerSec * CGFloat(deltaTime), abs(shortest))
        self.zRotation += shortest.sign() * amountToRotate
    }
    
    func animate(type: String) {
        var textureType: [SKTexture]
        switch type {
        case "idle":
            textureType = textureIdle
        case "walk":
            textureType = textureWalk
        case "fire":
            textureType = textureFire
        default:
            textureType = textureIdle
        }
        let animation = SKAction.animate(with: textureType, timePerFrame: (1.0 / 5.0))
        self.run(SKAction.repeatForever(animation))
    }
    
    // Swift requires this initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

