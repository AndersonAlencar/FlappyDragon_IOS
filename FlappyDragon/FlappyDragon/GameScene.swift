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
        floor.position = CGPoint(x: floor.size.width/2, y: self.size.height - gameArea - floor.size.height/2)
        floor.zPosition = 2
        
        let duration = Double(floor.size.width/2)/velocity // tem haver com física tempo = espaço/velocidade
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        let sequenceActions = SKAction.sequence([moveFloorAction,resetXAction])
        let repeatAction = SKAction.repeatForever(sequenceActions)
        floor.run(repeatAction)
        return floor
    }()
    lazy var invisibleFloor: SKNode = {
        let invisibleFloor = SKNode()
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.position = CGPoint(x: self.size.width/2, y: self.size.height - gameArea)
        invisibleFloor.zPosition = 2
        return invisibleFloor
    }()
    lazy var invisibleRoof: SKNode = {
        let invisibleRoof = SKNode()
        invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        invisibleRoof.physicsBody?.isDynamic = false
        invisibleRoof.position = CGPoint(x: self.size.width/2, y: self.size.height)
        invisibleRoof.zPosition = 2
        return invisibleRoof
    }()
    lazy var intro: SKSpriteNode = {
        var intro = SKSpriteNode(imageNamed: "intro")
        intro.alpha = 0.5
        intro.position = CGPoint(x: self.size.width/2, y: self.size.height - 210)
        intro.zPosition = 3
        
        let introAction = SKAction.fadeAlpha(to: 0.5, duration: 0.6)
        let introAction2 = SKAction.fadeAlpha(to: 1, duration: 0.6)
        let sequenceAction = SKAction.sequence([introAction, introAction2])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        intro.run(repeatAction)
        return intro
    }()
    lazy var player: SKSpriteNode = {
        var player = SKSpriteNode(imageNamed: "player1")
        player.zPosition = 4
        player.position = CGPoint(x: 65, y: self.size.height - gameArea/2)
        
        var playerTextures = [SKTexture]()
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let moveDragonAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09)
        let repeatAction = SKAction.repeatForever(moveDragonAction)
        player.run(repeatAction)
        return player
    }()
    lazy var scoreLabel: SKLabelNode = {
        var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 94
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height - 100)
        scoreLabel.color = .white
        scoreLabel.alpha = 0.8
        return scoreLabel
    }()
    lazy var background: SKSpriteNode = {
           let background = SKSpriteNode(imageNamed: "background")
           background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
           background.zPosition = 0
           return background
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
        
        addChild(background)
        addChild(floor)
        addChild(invisibleFloor)
        addChild(invisibleRoof)
        addChild(intro)
        addChild(player)
        
    }
    
    func spawnEnimeis() {
        let initialPosition =  CGFloat.random(in: 1...131) + 74
        let enemynumber = Int.random(in: 1...4)
        let enemiesDistance = player.size.height * 2.5
        
        let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemynumber)")
        let enemyWidth = enemyTop.size.width
        let enemyHeigth = enemyTop.size.height
        enemyTop.position = CGPoint(x: size.width + enemyWidth/2, y: size.height - initialPosition + enemyHeigth/2)
        enemyTop.zPosition = 1
        enemyTop.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
        enemyTop.physicsBody?.isDynamic = false
        
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemynumber)")
        enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemiesDistance)
        enemyBottom.zPosition = 1
        enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
        enemyBottom.physicsBody?.isDynamic = false
        
        let distance = size.width + enemyWidth
        let duration = Double(distance)/velocity
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction,removeAction])
        
        enemyTop.run(sequenceAction)
        enemyBottom.run(sequenceAction)
        addChild(enemyTop)
        addChild(enemyBottom)

    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !gameFinish {
            if !gameStart {
                intro.removeFromParent()
                addChild(scoreLabel)
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10) // corpo físico redondo e mais simples para evitar gasto excessivo de processamento
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                
                gameStart = true
                
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (tiemr) in
                    self.spawnEnimeis()
                }
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
