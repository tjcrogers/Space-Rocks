//
//  GameElements.swift
//  Space Rocks
//
//  Created by Taron Rogers on 8/13/19.
//  Copyright © 2019 CozCon. All rights reserved.
//

import SpriteKit


struct CollisionBitMask {
    //PhysicsCategories
   
}

extension GameScene {
    
    func createShip() -> SKSpriteNode {
        
        let shipCategory:UInt32 = 0x1 << 0
        let alienCategory:UInt32 = 0x1 << 1
        let pointsCategory:UInt32 = 0x1 << 2
        
        
        
     //   var wallPair = SKNode()
     //   var moveAndRemove = SKAction()
      //  var isGameStarted = Bool(false)
      //  var isDied = Bool(false)
        //let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
        var player:SKSpriteNode!
        player = SKSpriteNode(imageNamed: "spaceship")
        player.position = CGPoint(x: 20, y: self.frame.size.height / 2 + 20)
        
    
        // 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        // 2
        player.physicsBody?.isDynamic = true
        // 3
        player.physicsBody?.allowsRotation = false
        // 4
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.friction = 0.0
        player.physicsBody?.angularDamping = 0.0
        player.physicsBody?.categoryBitMask = shipCategory
        player.physicsBody?.collisionBitMask = alienCategory | pointsCategory
        player.physicsBody?.linearDamping = 0.0
        
    return player
    }


//1
func createRestartBtn() {
    var restartBtn = SKSpriteNode()
    restartBtn = SKSpriteNode(imageNamed: "restart")
    restartBtn.size = CGSize(width:100, height:100)
    restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    restartBtn.zPosition = 6
    restartBtn.setScale(0)
    self.addChild(restartBtn)
    restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
}
//2
func createPauseBtn() {
    var pauseBtn = SKSpriteNode()
    pauseBtn = SKSpriteNode(imageNamed: "pauseButton2")
    pauseBtn.size = CGSize(width:40, height:40)
    pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
    pauseBtn.zPosition = 6
    self.addChild(pauseBtn)
}
//3
func createScoreLabel() -> SKLabelNode {
    let scoreLbl = SKLabelNode()
    scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
    scoreLbl.text = "\(score)"
    scoreLbl.zPosition = 5
    scoreLbl.fontSize = 50
    scoreLbl.fontName = "HelveticaNeue-Bold"
    
    let scoreBg = SKShapeNode()
    scoreBg.position = CGPoint(x: 0, y: 0)
    scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
    let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
    scoreBg.strokeColor = UIColor.clear
    scoreBg.fillColor = scoreBgColor
    scoreBg.zPosition = -1
    scoreLbl.addChild(scoreBg)
    return scoreLbl
}
//4
func createHighscoreLabel() -> SKLabelNode {
    let highscoreLbl = SKLabelNode()
    highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
    if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
        highscoreLbl.text = "Highest Score: \(highestScore)"
    } else {
        highscoreLbl.text = "Highest Score: 0"
    }
    highscoreLbl.zPosition = 5
    highscoreLbl.fontSize = 26
    highscoreLbl.fontName = "Helvetica-Bold"
    return highscoreLbl
}
//5
func createLogo() {
    var logoImg = SKSpriteNode()
    logoImg = SKSpriteNode()
    logoImg = SKSpriteNode(imageNamed: "logo")
    logoImg.size = CGSize(width: 272, height: 65)
    logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
    logoImg.setScale(0.5)
    self.addChild(logoImg)
    logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
}
//6
func createTaptoplayLabel() -> SKLabelNode {
    let taptoplayLbl = SKLabelNode()
    taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
    taptoplayLbl.text = "Tap anywhere to play"
    taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
    taptoplayLbl.zPosition = 5
    taptoplayLbl.fontSize = 20
    taptoplayLbl.fontName = "HelveticaNeue"
    return taptoplayLbl
}
}
