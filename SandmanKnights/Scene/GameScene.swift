//
//  GameScene.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Actors
    var teddyBear = Player()
    var nightmares: [Enemy] = []
    var hud = HUD()
    
    // background
    let background = SKSpriteNode(imageNamed: "background")
    
    // Update Timer
    var lastTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    
    // Gesture
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    let triggerDistance: CGFloat = 20
    var initialTouch: CGPoint = CGPoint.zero
    
    // Rectangle that represents the world
    let playableRect: CGRect
    
    // camera
    let cameraNode = SKCameraNode()
    
    // Before the Scene
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    
    // MARK: Init
    override init(size: CGSize) {
        
        // Creating the size of the world
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        super.init(size: size)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // Creating background
        backgroundColor = .black
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = Z.background
        addChild(background)
        
        // Creating the player
        teddyBear.setup(view: self.view!)
        teddyBear.size.height = 145
        teddyBear.size.width = 145
        teddyBear.position = CGPoint(x: ((scene?.size.width)! / 2), y: ((scene?.size.height)! / 2))
        teddyBear.setScale(0.7) // SKNode method
        addChild(teddyBear)
        
        // HUD
        hud.setup(size: size)
        addChild(hud)
        
        // Creating the boundries of the map
        setupWorldPhysics()
        
        // Enemies
        run(SKAction.repeatForever( SKAction.sequence([SKAction.run() { [weak self] in
            self?.spawnEnemies()
            }, SKAction.wait(forDuration: 1.0)])))
    }
    
    // Functions for the touch commands
    func touchDown(atPoint pos: CGPoint) {
        
        // Gesture Start Detect
        initialTouch = pos
        deltaX = 0
        deltaY = 0
        
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "buttonFire" {
            let button = touchedNode as? SKSpriteNode
            button?.texture = SKTexture(imageNamed: "buttonFire-pressed")
            return
        }
        
        teddyBear.setDestination(destination: pos)
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        // Delta Saving
        deltaX = pos.x - initialTouch.x
        deltaY = pos.y - initialTouch.y
    }
    
    func touchUp(atPoint pos: CGPoint) {
        
        // Gesture Trigger
        if fabs(deltaX) > triggerDistance {
            if deltaX < 0 {
                // Left Swipe
            } else {
                // Right Swipe
            }
        } else if fabs(deltaY) > triggerDistance {
            if deltaY < 0 {
                // Down Swipe
            } else {
                // Up Swipe
                //        perna.jump()
            }
        }
        
        // With childNode
        if let button = hud.childNode(withName: "buttonFire") as? SKSpriteNode {
            button.texture = SKTexture(imageNamed: "buttonFire-normal")
        }
        
        // With atPoint
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "buttonFire" {
            //teddyBear.fire()
            return
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchDown(atPoint: touch.location(in: self))
        let touchLocation = touch.location(in: self)
        teddyBear.sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchMoved(toPoint: touch.location(in: self))
        let touchLocation = touch.location(in: self)
        teddyBear.sceneTouched(touchLocation: touchLocation)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchUp(atPoint: touch.location(in: self))
        let touchLocation = touch.location(in: self)
        teddyBear.sceneTouched(touchLocation: touchLocation)
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval) {
        
        // If we don't have a last frame time value, this is the first frame, so delta time will be zero.
        if lastTime <= 0 { lastTime = currentTime }
        
        // Update delta time
        deltaTime = currentTime - lastTime
        
        // Set last frame time to current time
        lastTime = currentTime
        
        // Move
        teddyBear.update(deltaTime: deltaTime)
        for nightmare in nightmares {
            nightmare.updateEnemy(player: teddyBear, deltaTime: deltaTime)
        }
        
        
    }
    
    // Creating the enemies
    func spawnEnemies() {
        let nightmare = Enemy()
        nightmare.enemies.append(nightmare)
        nightmares.append(nightmare)
        nightmare.position = CGPoint(
            x: CGFloat.random(min: playableRect.minX,
                              max: playableRect.maxX),
            y: CGFloat.random(min: playableRect.minY,
                              max: playableRect.maxY))
        nightmare.setScale(3)
        addChild(nightmare)
        
        //let appear = SKAction.scale(to: 1.0, duration: 0.5)
        let move = SKAction.run { [weak self] in
            nightmare.updateEnemy(player: (self?.teddyBear)!, deltaTime: (self?.deltaTime)!)
        }
        nightmare.run(move)
        //print(enemy.enemies)
        
    }
    
    func setupWorldPhysics() {
        // giving an edge loop physics body to the background tile map node, you make sure the player will never leave the map.
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
    }
}

