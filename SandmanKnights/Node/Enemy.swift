//
//  Enemy.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    // Textures
    let textureIdle = SKTexture(imageNamed: "nightmare")
    var enemies: [SKSpriteNode] = []
    
    // Movement
    var enemyVelocity = CGPoint.zero
    var enemyRotateRadiansPerSec: CGFloat = 4.0 * π
    let enemyMovePointsPerSec: CGFloat = 5.0
    
    init() {
        super.init(texture: textureIdle, color: .clear, size: SpriteSize.enemy)
        self.name = "enemy"
        
        // Physics
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = PhysicsMask.enemy
        self.physicsBody!.contactTestBitMask = PhysicsMask.bullet
        self.physicsBody!.collisionBitMask = 0
    }
    
    func updateEnemy(player: Player, deltaTime: TimeInterval) {
        
        let targetPosition = player.position
        
        for enemy in enemies {
            let actionDuration = 0.3
            let offset = targetPosition - enemy.position
            let direction = offset.normalized()
            let amountToMovePerSec = direction * self.enemyMovePointsPerSec
            let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
            let rotateSprite = SKAction.run { [weak self] in
                self?.enemyRotate(deltaTime: deltaTime)
            }
            let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
            let actions = [moveAction, rotateSprite]
            enemy.run(SKAction.sequence(actions))
        }
       
    }
    
    func enemyRotate(deltaTime: TimeInterval) {
        let shortest = shortestAngleBetween(angle1: self.zRotation, angle2: enemyVelocity.angle)
        let amountToRotate = min(enemyRotateRadiansPerSec * CGFloat(deltaTime), abs(shortest))
        self.zRotation += shortest.sign() * amountToRotate
        let newVelocity = CGVector(dx: enemyVelocity.x, dy: enemyVelocity.y)
        physicsBody!.velocity = newVelocity
    }
    
    func enemyMove(deltaTime: TimeInterval) {
        let amountToMove = enemyVelocity * CGFloat(deltaTime)
        self.position += amountToMove
    }
    
    // Swift requires this initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
