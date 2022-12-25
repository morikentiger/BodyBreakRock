//
//  TestScene.swift
//  BodyBreakRock
//
//  Created by 森田健太 on 2022/12/25.
//

import Foundation
import SpriteKit

class TestScene: SKScene {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let action = SKAction.move(to: CGPoint(x: location.x, y: location.y + 20), duration: 0.1)
        let bird = self.childNode(withName: "bird1") as? SKSpriteNode
        bird?.run(action)
    }
    
//
//    override func sceneDidLoad() {
//
//        let backNode = SKSpriteNode(imageNamed: "mountain")
//
//        backNode.size = self.frame.size
//
//        backNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//
//        let birdNode = SKSpriteNode(imageNamed: "bird1")
//
//        birdNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//
//        self.addChild(backNode)
//        self.addChild(birdNode)
//    }
}
