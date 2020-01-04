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
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
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
    lazy var gameOverLabel: SKLabelNode = {
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 40
        gameOverLabel.text = "Game Over !"
        gameOverLabel.zPosition = 5
        gameOverLabel.position = CGPoint(x: size.width/2+15, y: size.height/2)
        gameOverLabel.fontColor = UIColor.red
        return gameOverLabel
    }()
    lazy var restartLabel: SKLabelNode = {
        let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.fontSize = 40
        restartLabel.text = "Restart"
        restartLabel.zPosition = 5
        restartLabel.position = CGPoint(x: size.width/2+15, y: size.height/2 - 50)
        restartLabel.fontColor = UIColor.red
        
        let introAction = SKAction.fadeAlpha(to: 0.5, duration: 0.6)
        let introAction2 = SKAction.fadeAlpha(to: 1, duration: 0.6)
        let sequenceAction = SKAction.sequence([introAction, introAction2])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        restartLabel.run(repeatAction)
        return restartLabel
    }()
    lazy var background: SKSpriteNode = {
           let background = SKSpriteNode(imageNamed: "background")
           background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
           background.zPosition = 0
           return background
       }()
    lazy var scoreSound: SKAction = {
        let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
        return scoreSound
    }()
    lazy var gameOverSound: SKAction = {
        let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
        return gameOverSound
    }()
    lazy var timer: Timer = {
        return Timer()
    }()
    lazy var velocity: Double = {
        return 100.0
    }()
    lazy var gameArea: CGFloat = {
        return 410.0
    }()
    lazy var gameFinished: Bool = {
        return false
    }()
    lazy var gameStarted: Bool = {
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
    lazy var playerCategory: UInt32 = {
        return 1
    }()
    lazy var enemyCategory: UInt32 = {
        return 2
    }()
    lazy var scoreCategory: UInt32 = {
        return 4
    }()
    
    weak var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
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
        enemyTop.physicsBody?.categoryBitMask = enemyCategory
        enemyTop.physicsBody?.contactTestBitMask = playerCategory
        
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemynumber)")
        enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemiesDistance)
        enemyBottom.zPosition = 1
        enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
        enemyBottom.physicsBody?.isDynamic = false
        enemyBottom.physicsBody?.categoryBitMask = enemyCategory
        enemyBottom.physicsBody?.contactTestBitMask = playerCategory
        
        let distance = size.width + enemyWidth
        let duration = Double(distance)/velocity
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction,removeAction])
        
        let laser = SKNode()
        laser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2, y: enemyTop.position.y - enemyHeigth/2 - enemiesDistance/2)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemiesDistance))
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.categoryBitMask = scoreCategory
        
        enemyTop.run(sequenceAction)
        enemyBottom.run(sequenceAction)
        laser.run(sequenceAction)
        
        addChild(enemyTop)
        addChild(enemyBottom)
        addChild(laser)

    }
    
    func gameOver() {
        timer.invalidate()
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "playerDead")
        player.physicsBody?.isDynamic = false
        for node in self.children {
            node.removeAllActions()
        }
        gameFinished = true
        gameStarted = false
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.addChild(self.gameOverLabel)
            self.addChild(self.restartLabel)
            self.restart = true
        }
        
        
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !gameFinished {
            if !gameStarted {
                intro.removeFromParent()
                addChild(scoreLabel)
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10) // corpo físico redondo e mais simples para evitar gasto excessivo de processamento
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                player.physicsBody?.categoryBitMask = playerCategory
                player.physicsBody?.contactTestBitMask = scoreCategory
                player.physicsBody?.collisionBitMask = enemyCategory
                
                gameStarted = true
                
                timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { (tiemr) in
                    self.spawnEnimeis()
                }
            } else {
                player.physicsBody?.velocity = CGVector.zero // zerando a velocidade para que ele não sofra a força gerada pela acelaração da gravidade e seja aplicada apenas a flyForce como resultante
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
        } else {
            if restart {
                gameViewController?.presentScene()
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted {
            let yVelocity = player.physicsBody!.velocity.dy  * 0.001 as CGFloat
// a rotação acontece em radianos, por isso diminuimos bastante o valor da velocidade para compensar a rotação
            player.zRotation = yVelocity
            
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted {
            
            if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
                score += 1
                scoreLabel.text = "\(score)"
                run(scoreSound)
            } else if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory{
                run(gameOverSound)
                gameOver()
                
            }
        }
    }
    
    
}
