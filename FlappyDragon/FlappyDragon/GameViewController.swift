//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Anderson Alencar on 30/12/19.
//  Copyright © 2019 Anderson Alencar. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation


class GameViewController: UIViewController {

    var stage: SKView!
    lazy var musicPlayer: AVAudioPlayer = {
        var musicPlayer = AVAudioPlayer()
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.numberOfLoops = -1 // rodar indefinidamente
            
        }
        musicPlayer.volume = 0.01
        
        return musicPlayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stage = view as? SKView
        stage.ignoresSiblingOrder = true
        presentScene()
        musicPlayer.play()
        
    }
    

    func presentScene() {
        
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.gameViewController = self
        scene.scaleMode = SKSceneScaleMode.aspectFill
        stage.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.5))
    }
    
    func playMusic() {
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
