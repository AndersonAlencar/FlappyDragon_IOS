//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Anderson Alencar on 30/12/19.
//  Copyright © 2019 Anderson Alencar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var floor: SKSpriteNode!
    var intro: SKSpriteNode!
    var player: SKSpriteNode!
    var velocity: Double = 100.0
    var gameArea: CGFloat = 410.0
    
    override func didMove(to view: SKView) {
        
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
        moveFloor()
        
    }
    
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func addFloor() {
        floor = SKSpriteNode(imageNamed: "floor")
        floor.position = CGPoint(x: floor.size.width/2, y: self.size.height - gameArea - floor.size.height/2)
        floor.zPosition = 2
        addChild(floor)
    }
    
    func addIntro() {
        intro = SKSpriteNode(imageNamed: "intro")
        intro.alpha = 0.5
        intro.position = CGPoint(x: self.size.width/2, y: self.size.height - 210)
        intro.zPosition = 3
        
        let introAction = SKAction.fadeAlpha(to: 0.5, duration: 0.6)
        let introAction2 = SKAction.fadeAlpha(to: 1, duration: 0.6)
        let sequenceAction = SKAction.sequence([introAction, introAction2])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        intro.run(repeatAction)

        addChild(intro)
        
    }
    
    func addPlayer() {
        player = SKSpriteNode(imageNamed: "player1")
        player.zPosition = 4
        player.position = CGPoint(x: 65, y: self.size.height - gameArea/2)
        
        var playerTextures = [SKTexture]()
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let moveDragonAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09)
        let repeatAction = SKAction.repeatForever(moveDragonAction)
        player.run(repeatAction)
        
        addChild(player)
    }
    
    func moveFloor() {
        let duration = Double(floor.size.width/2)/velocity // tem haver com física tempo = espaço/velocidade
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        let sequenceActions = SKAction.sequence([moveFloorAction,resetXAction])
        let repeatAction = SKAction.repeatForever(sequenceActions)
        floor.run(repeatAction)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
