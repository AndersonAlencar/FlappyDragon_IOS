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
    
    lazy var floor: SKSpriteNode = {
        var floor = SKSpriteNode(imageNamed: "floor")
        return floor
    }()
    lazy var intro: SKSpriteNode = {
        var intro = SKSpriteNode(imageNamed: "intro")
        return intro
    }()
    lazy var player: SKSpriteNode = {
        var player = SKSpriteNode(imageNamed: "player1")
        return player
    }()
    lazy var scoreLabel: SKLabelNode = {
        var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        return scoreLabel
    }()
    lazy var velocity: Double = {
        return 100.0
    }()
    lazy var gameArea: CGFloat = {
        return 410.0
    }()
    lazy var gameFinish: Bool = {
        return false
    }()
    lazy var gameStart: Bool = {
        return false
    }()
    lazy var restart: Bool = {
        return false
    }()
    lazy var score: Int = {
        return 0
    }()
    lazy var flyForce: CGFloat = {
        return 30.0
    }()
    
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
        floor.position = CGPoint(x: floor.size.width/2, y: self.size.height - gameArea - floor.size.height/2)
        floor.zPosition = 2
        addChild(floor)
    }
    
    func addIntro() {
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
    
    func addScore() {
        scoreLabel.fontSize = 94
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height - 100)
        scoreLabel.color = .white
        scoreLabel.alpha = 0.8
        addChild(scoreLabel)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !gameFinish {
            if !gameStart {
                intro.removeFromParent()
                addScore()
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10) // corpo físico redondo e mais simples para evitar gasto excessivo de processamento
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                
                gameStart = true
            } else {
                player.physicsBody?.velocity = CGVector.zero // zerando a velocidade para que ele não sofra a força gerada pela acelaração da gravidade e seja aplicada apenas a flyForce como resultante
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStart {
            let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat // a rotação acontece em radianos, por isso diminuimos bastante o valor da velocidade para compensar a rotação 
            player.zRotation = yVelocity
            
        }
    }
}
