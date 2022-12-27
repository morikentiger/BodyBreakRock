//
//  GameScene.swift
//  BodyBreakRock
//
//  Created by 森田健太 on 2022/12/24.
//

import SpriteKit
import GameplayKit
import AVFoundation

//class BlockNode: SKSpriteNode {
//
//}
//
//extension BlockNode {
//    static let category: UInt32 = 0x1 << 0
//}
//
//class PlayerNode: SKSpriteNode {
//
//}
//
//extension PlayerNode {
//    static let category: UInt32 = 0x1 << 1
//}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let base = SKSpriteNode(imageNamed: "JoystickBase")
    let pad = SKSpriteNode(imageNamed: "JoystickPad")
    let jumpButton = SKSpriteNode(imageNamed: "JumpButton")
    let breakButton = SKSpriteNode(imageNamed: "BreakButton")
    
    let cursor = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
    
    let darkThunder = SKSpriteNode(imageNamed: "DarkThunderModeStanding")
    
    var score = 0
    
    var blocks: [SKSpriteNode] = []
    
    let stage = SKNode()
    
    struct PhysicsCategory {
        static let Player: UInt32 = 0x1 << 0
        static let Block: UInt32 = 0x1 << 1
    }

//    let block = SKSpriteNode(imageNamed: "block")
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block"),
//                 SKSpriteNode(imageNamed: "block")]
    
    var isSticActive = false
    var isBreakButtonPressed = false
    var isJumpButtonPressed = false
    
    var timerBreakButton: Timer?
    var elapsedTimeBreakButton = 0.0
    var timerJumpButton: Timer?
    var elapsedTimeJumpButton = 0.0
    
    var moveBreakButton = 10.0
    var moveJumpButton = 10.0
    
    var chargeLevel = 0
    
    var player:AVAudioPlayer!
    
    let labelIsBreakButtonPressed = SKLabelNode(fontNamed: "Chalkduster")
    let labelScore = SKLabelNode(fontNamed: "Chalkduster")

    override func sceneDidLoad() {
        
        labelIsBreakButtonPressed.text = "nil"
        labelIsBreakButtonPressed.fontSize = 39
        labelIsBreakButtonPressed.fontColor = SKColor.red
        labelIsBreakButtonPressed.position = CGPoint(x: 0 ,y: 0)
//        addChild(labelIsBreakButtonPressed)
        
        
        
        self.physicsWorld.contactDelegate = self
        
        
        self.backgroundColor = SKColor.brown
        
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        
//        for i in 0...9 {
//            self.addChild(block[i])
//            block[i].position = CGPointMake(0, CGFloat(-500+i*50))
//        }
        for y in 0..<100 {
            for x in 0..<10 {
                let block = SKSpriteNode(imageNamed: "block")
                block.position = CGPoint(x: -250+x*50, y: -250+y*50)
                blocks.append(block)
                stage.addChild(block)
                
//                let blockCopy = block.copy() as! SKSpriteNode
//                blockCopy.position = CGPoint(x: -250+x*50, y: -250+y*50)
                
//                // ブロックに物理演算を有効にする
//                blockCopy.physicsBody = SKPhysicsBody(rectangleOf: blockCopy.size)
//                blockCopy.physicsBody?.isDynamic = false // 静的なオブジェクトにする
//
//                // ブロックと衝突したときに通知を受け取るカテゴリーを設定する
//                blockCopy.physicsBody?.categoryBitMask = 0b0001 // 0001
//                blockCopy.physicsBody?.contactTestBitMask = 0b0010 // 0010
                
//                stage.addChild(blockCopy)
            }
        }
        
        self.addChild(stage)
        
        labelScore.text = "nil"
        labelScore.fontSize = 39
        labelScore.fontColor = SKColor.red
        labelScore.position = CGPoint(x: 0 ,y: 300)
        addChild(labelScore)
        
        self.addChild(base)
        base.position = CGPointMake(-100, -250)
        
        self.addChild(pad)
        pad.position = base.position
        pad.colorBlendFactor = 1.0
        pad.color = .red
        
//        self.addChild(jumpButton)
        jumpButton.position = CGPointMake(75, -275)
        
        self.addChild(breakButton)
        breakButton.position = CGPointMake(100, -250)
        breakButton.colorBlendFactor = 1.0
        breakButton.color = .red
        
        self.addChild(cursor)
        cursor.isHidden = true
        
        
        self.addChild(darkThunder)
        darkThunder.position = CGPointMake(0, 300)
        
        pad.alpha = 0.4
        base.alpha = 0.4
        jumpButton.alpha = 0.4
        breakButton.alpha = 0.4
        
        // 衝突時に呼ばれるデリゲートメソッドを設定する
        self.physicsWorld.contactDelegate = self
//        for i in 0...9 {
        
//        }
        // プレイヤーに物理演算を有効にする
        darkThunder.physicsBody = SKPhysicsBody(rectangleOf: darkThunder.size)
        darkThunder.physicsBody?.mass = 0.0
        darkThunder.physicsBody?.affectedByGravity = false // 重力を適用しない


        // プレイヤーと衝突したときに通知を受け取るカテゴリーを設定する
        darkThunder.physicsBody?.collisionBitMask = PhysicsCategory.Player
        darkThunder.physicsBody?.categoryBitMask = PhysicsCategory.Player
        darkThunder.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
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
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (CGRectContainsPoint(pad.frame, location)) {
                isSticActive = true
                
            } else {
                isSticActive = false
            }
            
            if (CGRectContainsPoint(breakButton.frame, location)) {
                isBreakButtonPressed = true
                timerBreakButton = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerBreakButton), userInfo: nil, repeats: true)
                cursor.isHidden = false
                cursor.position.x = darkThunder.position.x + 50
                cursor.position.y = darkThunder.position.y + 50
            } else {
                
            }
            
            if (CGRectContainsPoint(jumpButton.frame, location)) {
                isJumpButtonPressed = true
                timerJumpButton = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerJumpButton), userInfo: nil, repeats: true)
            } else {
                
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (isSticActive == true) {
                
                let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                let length: CGFloat = base.frame.size.height / 2
                
                let xDist:CGFloat = sin(angle - 1.57079633) * length
                let yDist:CGFloat = cos(angle - 1.57079633) * length
                
                if (CGRectContainsPoint(base.frame, location)) {
                    pad.position = location
                } else {
                    pad.position = CGPointMake(base.position.x - xDist, base.position.y + yDist)
                }
                if !isBreakButtonPressed {
                    darkThunder.position.x -= xDist/5
                    darkThunder.position.y += yDist/5
                }
                if isBreakButtonPressed {
                    cursor.position.x -= xDist/5
                    cursor.position.y += yDist/5
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSticActive {
            let movePad:SKAction = SKAction.move(to: base.position, duration: 0.2)
            movePad.timingMode = .easeOut
            
            pad.run(movePad)
        }
        
        darkThunder.removeAllChildren()
        
        if isBreakButtonPressed {
//            darkThunder.position.x += moveBreakButton
            let moveBreak:SKAction = SKAction.move(to: CGPoint(x: cursor.position.x, y: cursor.position.y), duration: 0.2)
            moveBreak.timingMode = .easeOut
            
            darkThunder.run(moveBreak)
            
            isBreakButtonPressed = false
            cursor.isHidden = true
            
        }
        
        timerBreakButton?.invalidate()
        timerBreakButton = nil
        elapsedTimeBreakButton = 0.0
        
        if isJumpButtonPressed {
            darkThunder.position.y += moveJumpButton
            isJumpButtonPressed = false
        }
        
        timerJumpButton?.invalidate()
        timerJumpButton = nil
        elapsedTimeJumpButton = 0.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    @objc func updateTimerBreakButton() {
        elapsedTimeBreakButton += 0.1
        if elapsedTimeBreakButton >= 0.1 {
            moveBreakButton = 3.0
            chargeLevel = 1
        }
        if elapsedTimeBreakButton >= 0.5 {
            moveBreakButton = 60.0
            chargeLevel = 2
        }
        if elapsedTimeBreakButton >= 1.5 {
            moveBreakButton = 210.0
            chargeLevel = 3
        }
    }
    
    func updateChargeEffect() {
        darkThunder.removeAllChildren()
        if chargeLevel >= 1 {
            guard let chargeParticleBlue = SKEmitterNode(fileNamed: "ChargeParticleBlue.sks") else {
                return
            }
            chargeParticleBlue.position = CGPointMake(0, 0)
            chargeParticleBlue.targetNode = darkThunder
            darkThunder.addChild(chargeParticleBlue)
        }
        if chargeLevel >= 2 {
            guard let chargeParticleYellow = SKEmitterNode(fileNamed: "ChargeParticleYellow.sks") else {
                return
            }
            chargeParticleYellow.position = CGPointMake(0, 0)
            chargeParticleYellow.targetNode = darkThunder
            darkThunder.addChild(chargeParticleYellow)
        }
        if chargeLevel >= 3 {
            guard let chargeParticleRed = SKEmitterNode(fileNamed: "ChargeParticleRed.sks") else {
                return
            }
            chargeParticleRed.position = CGPointMake(0, 0)
            chargeParticleRed.targetNode = darkThunder
            darkThunder.addChild(chargeParticleRed)
        }
        chargeLevel = 0
    }
    
    @objc func updateTimerJumpButton() {
        elapsedTimeJumpButton += 0.1
        if elapsedTimeJumpButton >= 0.1 {
            moveJumpButton = 3.0
        }
        if elapsedTimeJumpButton >= 0.5 {
            moveJumpButton = 60.0
        }
        if elapsedTimeJumpButton >= 1.5 {
            moveJumpButton = 210.0
        }
    }
    
    func stayOnScreen() {
        if !(darkThunder.position.x < self.size.width/2 - darkThunder.size.width/2) {
            darkThunder.position.x = self.size.width/2 - darkThunder.size.width/2
        }
        if !(darkThunder.position.x > -self.size.width/2 + darkThunder.size.width/2) {
            darkThunder.position.x = -self.size.width/2 + darkThunder.size.width/2
        }
        if !(darkThunder.position.y < self.size.height/2 - darkThunder.size.height/2) {
            darkThunder.position.y = self.size.height/2 - darkThunder.size.height/2
        }
        if !(darkThunder.position.y > -self.size.height/2 + darkThunder.size.height/2) {
            darkThunder.position.y = -self.size.height/2 + darkThunder.size.height/2
        }
    }
    
    override func didSimulatePhysics() {
        for block in blocks {
            block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
            block.physicsBody?.categoryBitMask = PhysicsCategory.Block
            block.physicsBody?.collisionBitMask = PhysicsCategory.Player
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        for block in blocks {
            let bodyA = contact.bodyA
            let bodyB = contact.bodyB
            
            
            
            if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Block || bodyA.categoryBitMask == PhysicsCategory.Block && bodyB.categoryBitMask == PhysicsCategory.Player {
//                block.removeFromParent()
                let blockA: SKSpriteNode
//                let blockB: SKSpriteNode
                
                if bodyA.categoryBitMask == PhysicsCategory.Block {
                    blockA = bodyA.node as! SKSpriteNode
//                    blockB = bodyB.node as! SKSpriteNode
                } else {
                    blockA = bodyB.node as! SKSpriteNode
//                    blockB = bodyA.node as! SKSpriteNode
                }
                
                blockA.removeFromParent()
//                blockB.removeFromParent()
                score += 100
                
            }
//        }
        // 衝突が発生したときに呼ばれるメソッド
//        // 衝突したオブジェクトを取得する
//        let objectA = contact.bodyA.node
//        let objectB = contact.bodyB.node
//
//        // ブロックとプレイヤーが衝突した場合
//        for i in 0...9 {
//            if (objectA == stage.childNode(withName: "blockCopy") && objectB == darkThunder) || (objectA == darkThunder && objectB == stage.childNode(withName: "blockCopy")) {
//                // ブロックを削除する
//                stage.childNode(withName: "blockCopy")?.removeFromParent()
//            }
//        }
        
//        if let playerNode = nodeA as? PlayerNode, let blockNode = nodeB as? BlockNode {
////            playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.frame.width)
//            playerNode.physicsBody?.contactTestBitMask = BlockNode.category
//        } else if let playerNode = nodeB as? PlayerNode, let blockNode = nodeA as? BlockNode {
//            playerNode.physicsBody?.contactTestBitMask = BlockNode.category
//            self.physicsWorld.contactTestBitMask = BlockNode.category
//            blockNode.physicsBody = nil
//        }
    }
    
    func changeButtonAlpha() {
        if isSticActive {
            pad.alpha = 1.0
        } else {
            pad.alpha = 0.4
        }
        
        if isBreakButtonPressed {
            breakButton.alpha = 1.0
        } else {
            breakButton.alpha = 0.4
        }
        
        if isJumpButtonPressed {
            jumpButton.alpha = 1.0
        } else {
            jumpButton.alpha = 0.4
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        changeButtonAlpha()
        updateChargeEffect()
        stayOnScreen()
        
//        labelIsBreakButtonPressed.text = "\(isBreakButtonPressed)"
        labelScore.text = "Score:\(score)"
    
    }
}

