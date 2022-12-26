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
    let darkThunder = SKSpriteNode(imageNamed: "DarkThunderModeStanding")
    
    var sticActive: Bool = false
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
    
    override func sceneDidLoad() {
        
        self.backgroundColor = SKColor.brown
        
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
                sticActive = true
            } else {
                sticActive = false
            }
            
            if (CGRectContainsPoint(breakButton.frame, location)) {
                isBreakButtonPressed = true
                timerBreakButton = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerBreakButton), userInfo: nil, repeats: true)
            } else {
                isBreakButtonPressed = false
            }
            
            if (CGRectContainsPoint(jumpButton.frame, location)) {
                isJumpButtonPressed = true
                timerJumpButton = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerJumpButton), userInfo: nil, repeats: true)
            } else {
                isJumpButtonPressed = false
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (sticActive == true) {
                
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
                
                darkThunder.position.x -= xDist/5
                darkThunder.position.y += yDist/5
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (sticActive == true) {
            let move:SKAction = SKAction.move(to: base.position, duration: 0.2)
            move.timingMode = .easeOut
            
            pad.run(move)
        }
        
        darkThunder.removeAllChildren()
        
        if isBreakButtonPressed {
            darkThunder.position.x += moveBreakButton
        }
        isBreakButtonPressed = false
        timerBreakButton?.invalidate()
        timerBreakButton = nil
        elapsedTimeBreakButton = 0.0
        
        if isJumpButtonPressed {
            darkThunder.position.y += moveJumpButton
        }
        isJumpButtonPressed = false
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
    
    override func update(_ currentTime: TimeInterval) {
        updateChargeEffect()
        stayOnScreen()
    }
}
