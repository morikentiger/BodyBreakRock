//
//  GameScene.swift
//  BodyBreakRock
//
//  Created by 森田健太 on 2022/12/24.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    let base = SKSpriteNode(imageNamed: "JoystickBase")
    let pad = SKSpriteNode(imageNamed: "JoystickPad")
    let jumpButton = SKSpriteNode(imageNamed: "JumpButton")
    let breakButton = SKSpriteNode(imageNamed: "BreakButton")
    let darkThunder = SKSpriteNode(imageNamed: "DarkThunder")
    
    var sticActive: Bool = false
    
    var player:AVAudioPlayer!
    
//    let player = AVQueuePlayer()
//    //BGM用のパラメーターを作成。
//    var backgroundMusic = SKAudioNode()
//    //BGMで流れるゲーム音楽。
////    let musicURL = Bundle.main.url(forResource: "BecomingTense", withExtension: "m4a")
//
//    if let url = Bundle.main.url(forResource: "SomeAudioFile", withExtension: "m4a") {
//        player.removeAllItems()
//        player.insert(AVPlayerItem(url: url), after: nil)
//        player.play()
//    }
//    //laserを発射するときの効果音。
//    let laserSound = SKAction.playSoundFileNamed("LaserSoundEffect.mp3", waitForCompletion: false)
//
//    //playerやenemyが爆発したときの効果音。
//    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
//    var entities = [GKEntity]()
//    var graphs = [String : GKGraph]()
//
//    private var lastUpdateTime : TimeInterval = 0
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        self.backgroundColor = SKColor.yellow
        
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.addChild(base)
        base.position = CGPointMake(-100, -250)
        
        self.addChild(pad)
        pad.position = base.position
        
        self.addChild(jumpButton)
        jumpButton.position = CGPointMake(75, -275)
        
        self.addChild(breakButton)
        breakButton.position = CGPointMake(125, -225)
        
        self.addChild(darkThunder)
        darkThunder.position = CGPointMake(0, 200)
        
        pad.alpha = 0.4
        base.alpha = 0.4
        jumpButton.alpha = 0.4
        breakButton.alpha = 0.4
        
        let url = Bundle.main.bundleURL.appendingPathComponent("BecomingTense.mp3")
        do {
            try player = AVAudioPlayer(contentsOf:url)
            
            //音楽を再生する。
            player.play()
            //ループさせる
            player.numberOfLoops = -1
            
        } catch {
            print(error)
        }
        
//        addChild(SKAudioNode(fileNamed: "BecomingTense.m4a"))
//        //BGM用の音楽をセットする
//        backgroundMusic = SKAudioNode(url: musicURL!)
//        //GameSceneに追加する。
//        self.addChild(backgroundMusic)

//        self.lastUpdateTime = 0
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (CGRectContainsPoint(pad.frame, location)) {
                sticActive = true
            } else {
                sticActive = false
            }
        }
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (sticActive == true) {
                
                let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                let deg = angle * CGFloat( 180 / M_PI)
                //            print( deg + 180)
                
                let length: CGFloat = base.frame.size.height / 2
                //let length: CGFloat = 40
                
                let xDist:CGFloat = sin(angle - 1.57079633) * length
                let yDist:CGFloat = cos(angle - 1.57079633) * length
                
                if (CGRectContainsPoint(base.frame, location)) {
                    pad.position = location
                } else {
                    pad.position = CGPointMake(base.position.x - xDist, base.position.y + yDist)
                }
                
//                darkThunder.zRotation = angle - 1.57079633
                darkThunder.position.x -= xDist/10
                darkThunder.position.y += yDist/10
                
            }
        }
        
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (sticActive == true) {
            let move:SKAction = SKAction.move(to: base.position, duration: 0.2)
            move.timingMode = .easeOut
            
            pad.run(move)
        }
        
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//
//        // Initialize _lastUpdateTime if it has not already been
//        if (self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//
//        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
//
//        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
//
//        self.lastUpdateTime = currentTime
    }
}
