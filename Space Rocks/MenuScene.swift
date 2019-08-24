//
//  MenuScene.swift
//  Space Rocks
//
//  Created by Taron Rogers on 4/10/19.
//  Copyright © 2019 CozCon. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {

    //var starfield:SKEmitterNode!
    var newGameButtonNode:SKSpriteNode!
    //var difficultyButtonNode:SKSpriteNode!
    //var difficultyLabelNode:SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let starFieldEmmiter = SKEmitterNode(fileNamed: "starfield.sks")!
        starFieldEmmiter.position = CGPoint(x: screenWidth,y: screenHeight)
        starFieldEmmiter.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
        starFieldEmmiter.zPosition = -1
    starFieldEmmiter.advanceSimulationTime(TimeInterval(starFieldEmmiter.particleLifetime))
    self.addChild(starFieldEmmiter)
        
        
        newGameButtonNode = (self.childNode(withName:"NewGameButton") as! SKSpriteNode)
        //self.addChild(newGameButtonNode)
       // difficultyButtonNode = (self.childNode(withName: "DifficultyButton") as! SKSpriteNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "NewGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(fileNamed: "GameScene")
                let skView = self.view as SKView!
                gameScene?.scaleMode = .aspectFill
                skView?.presentScene(gameScene!, transition: transition)
                
            }
        }
    }

}
