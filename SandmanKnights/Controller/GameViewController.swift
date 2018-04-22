//
//  GameViewController.swift
//  MorpheusKnights
//
//  Created by Bernardo Sarto de Lucena on 3/11/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create view
        if let skView = self.view as! SKView? {
            
            // Create Scene
            let scene = MenuScene(size:CGSize(width: 2048, height: 1536))
            scene.scaleMode = .aspectFill // Fit the window
            
            // Debug
            skView.ignoresSiblingOrder = false
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            
            // Load TextureAtlas
            let playerAtlas = SKTextureAtlas(named: "Sprites")
            
            // Get the list of texture names, and sort them
            let textureNames = playerAtlas.textureNames.sorted { (first, second) -> Bool in
                return first < second
            }
            
            // Load all textures
            GameManager.shared.allTextures = textureNames.map {
                return playerAtlas.textureNamed($0)
            }
            
            // Show Screen
            skView.presentScene(scene)
            
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
