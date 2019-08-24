//
//  GameScene.swift
//  Space Rocks
//
//  Created by Taron Rogers on 6/19/18.
//  Copyright © 2018 CozCon. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {


    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var jumpAction = SKAction()
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var taptoplayLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    ////
    var player:SKSpriteNode!
    var possiblePoints:SKSpriteNode!
    var possiblePoints1:SKSpriteNode!
    var possiblePoints2:SKSpriteNode!
    var gameTimer:Timer!
    //var possibleAliens = ["alien", "alien2", "alien3"]
    //var randpossiblePoints = ["points","points1","points2"]
    var possibleAliens = ["asteroid1","asteroid3"]
    
    //var possiblePointsArray:[[Any]]
    var possiblePointsArray = ["DarkMatterpoints1","DarkMatterpoints2","DarkMatterpoints3"]
    //var possiblePointsArray:[SKSpriteNode] = [SKSpriteNode]()
    
    //PhysicsCategories
    let shipCategory:UInt32 = 0x1 << 0
    let alienCategory:UInt32 = 0x1 << 1
    let pointsCategory:UInt32 = 0x1 << 2
    //let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
 
    override func didMove(to view: SKView) {
      
        self.backgroundColor = SKColor.black
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let starFieldEmmiter = SKEmitterNode(fileNamed: "starfield.sks")!
       //starFieldEmmiter.position = CGPoint(x: self.frame.width,y: self.frame.height)
        starFieldEmmiter.position = CGPoint(x: screenWidth,y: screenHeight)
        starFieldEmmiter.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
        starFieldEmmiter.zPosition = -1
 starFieldEmmiter.advanceSimulationTime(TimeInterval(starFieldEmmiter.particleLifetime))
        
        self.addChild(starFieldEmmiter)
//
      
        self.player=createShip()
        self.addChild(player)
        
        //negative number is for downward gravity force
        //self.physicsWorld.gravity = CGVector(dx: -0.5, dy: -0.5)
        self.physicsWorld.gravity = CGVector(dx: -0.3, dy: -0.0)
        self.physicsWorld.contactDelegate = self
        //self.physicsBody?.isDynamic = false
        //self.physicsBody?.affectedByGravity = false
        
        // 1
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // 2
        borderBody.friction = 0
        // 3
        self.physicsBody = borderBody
        //player.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 2.0))
        //jumpAction = SKAction.sequence([jumpUp, fallBack])
     
        
        //CREATE THE BIRD ATLAS FOR ANIMATION
       // let birdAtlas = SKTextureAtlas(named:"player")
        //var birdSprites = Array()
        //var bird = SKSpriteNode()
        //var repeatActionBird = SKAction()

        //SET UP THE BIRD SPRITES FOR ANIMATION
       // birdSprites.append(birdAtlas.textureNamed("bird1"))
        //birdSprites.append(birdAtlas.textureNamed("bird2"))
        //birdSprites.append(birdAtlas.textureNamed("bird3"))
        //birdSprites.append(birdAtlas.textureNamed("bird4"))
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        //Taron, create the shipSprites to animate it
        // let animateShip = SKAction.animate(with: self.shipSprites, timePerFrame: 0.1)
        //self.repeatActionship = SKAction.repeatForever(animateShip)
        
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        ///
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
       // createLogo()
        //taptoplayLbl = createTaptoplayLabel()
        //self.addChild(taptoplayLbl)
        
        ///
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callObjects), userInfo: nil, repeats: true)//increase difficulty by increasing enemies
        
    }
    
    @objc func callObjects (){
        addAlien()
        addPoints()
    }
    
    @objc func addPoints () {
        
        possiblePointsArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in:possiblePointsArray) as! [String]
        let points = SKSpriteNode(imageNamed: possiblePointsArray[0])
        let framesizeheight = CGFloat(self.frame.size.height )
        let randomPointsPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(framesizeheight))
        //lowestValue is X and highestValue is Y
        //let position = CGFloat(randomPointsPosition.nextInt())
        let pointsposition = CGFloat(randomPointsPosition.nextInt())
        
        points.position = CGPoint(x: self.frame.size.width + points.size.width, y: pointsposition)
        points.physicsBody = SKPhysicsBody(rectangleOf: points.size)
        points.physicsBody?.isDynamic = false
        points.physicsBody?.categoryBitMask = pointsCategory
        points.physicsBody?.contactTestBitMask = shipCategory
        points.physicsBody?.collisionBitMask = 0
        self.addChild(points)
   
        let animationDuration:TimeInterval = 6
        var pointsactionArray = [SKAction]()
        
        pointsactionArray.append(SKAction.move(to: CGPoint(x: -points.size.width, y: pointsposition), duration: animationDuration))//points position
        pointsactionArray.append(SKAction.removeFromParent())
        points.run(SKAction.sequence(pointsactionArray))
        
    }
    
    @objc func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let framesizeheight = CGFloat(self.frame.size.height )
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(framesizeheight))
        let Alienposition = CGFloat(randomAlienPosition.nextInt())
        //lowestValue is X and highestValue is Y
        
        alien.position = CGPoint(x: self.frame.size.width + alien.size.width, y: Alienposition)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        //alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.contactTestBitMask = shipCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 10
        var alienactionArray = [SKAction]()

        alienactionArray.append(SKAction.move(to: CGPoint(x: -alien.size.width, y: Alienposition), duration: animationDuration))//alien position
        alienactionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(alienactionArray))

    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0
        if (firstBody.categoryBitMask & shipCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0
        {shipDidCollideWithAlien(shipNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask & shipCategory) != 0 && (secondBody.categoryBitMask & pointsCategory) != 0
        {shipDidCollideWithPoints(shipNode: firstBody.node as! SKSpriteNode, pointsNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func shipDidCollideWithPoints (shipNode:SKSpriteNode, pointsNode:SKSpriteNode) {
        
        ////let explosion = SKEmitterNode(fileNamed: "Explosion")!
        ////explosion.position = pointsNode.position
        ////self.addChild(explosion)
        //self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        //shipNode.removeFromParent()
        pointsNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            ////explosion.removeFromParent()
        }
   
        print(pointsNode)
        score += 5
    }
    
    
    func shipDidCollideWithAlien (shipNode:SKSpriteNode, alienNode:SKSpriteNode) {
        //let shipNode = SKSpriteNode(imageNamed: "shuttle")
        let shipNode = player!
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        //self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        shipNode.removeFromParent()
        alienNode.removeFromParent()
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        //score += 5
        gameOver(didWin: true)
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        //createScene()
    }

    
    
   /* override func didSimulatePhysics() {
        
       // player.position.y += xAcceleration * 2
        
        if player.position.y < -20 {
           // player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
            player.position = CGPoint(x: player.position.x , y: self.size.height + 20)
        }else if player.position.y > self.size.height + 20 {
            player.position = CGPoint(x: player.position.x, y: -20)
        }
        
    }*/
    
    ///////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchDown(atPoint: t.location(in: self))
        //let location = t.location(in: self)
        //print(location)
        }}
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        let playerposy = player.position.y
        let playerposx = player.position.x
        
        if isGameStarted == false{
            //1
            isGameStarted =  true
            createPauseBtn()
            //2
        //    logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
          //      self.logoImg.removeFromParent()
        //    }
        
            taptoplayLbl.removeFromParent()
            //3
            //self.bird.run(repeatActionBird)
            
            //TODO: add pillars here
            
            //bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            //4
            if isDied == false {
                //player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                //player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        if isDied == true{
            if restartBtn.contains(location){
                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLabel.text!)!{
                        UserDefaults.standard.set(scoreLabel.text, forKey: "highestScore")
                    }
                } else {
                    UserDefaults.standard.set(0, forKey: "highestScore")
                }
                restartScene()
            }
        } else {
            //2
            if pauseBtn.contains(location){
                if self.isPaused == false{
                    self.isPaused = true
                    pauseBtn.texture = SKTexture(imageNamed: "play")
                } else {
                    self.isPaused = false
                    pauseBtn.texture = SKTexture(imageNamed: "pause")
                }
            }
        }
        
        //if location.x < self.frame.midX
        if location.x < playerposx
        {player.physicsBody?.applyImpulse(CGVector(dx: -0.5, dy: 0))
            
        }else if location.x > playerposx {
        //else if location.x > self.frame.midX {
            //else location.x > self.frame.midX{
            player.physicsBody?.applyImpulse(CGVector(dx: 0.5, dy: 0))
            
            //tap somewhere above this to make character jump
        }
        if (location.y < playerposy) {
        //if (location.y < self.frame.midY) {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy:-0.5))
        } else if location.y > playerposy {
        //else if location.y > self.frame.midY {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy:0.5))}
        
    }
     func touchDown(atPoint pos: CGPoint) {
        
     //jump()
        player?.texture = SKTexture(imageNamed: "spaceship")
     }
     
     func jump() {
     player?.texture = SKTexture(imageNamed: "spaceship")
     player?.physicsBody?.applyImpulse(CGVector(dx: 1.5, dy: 5))
        
        }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchUp(atPoint: t.location(in: self)) }
     }
     
     func touchUp(atPoint pos: CGPoint) {
     player?.texture = SKTexture(imageNamed: "spaceship")
 }
    /////////
    
  /*  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if player.action(forKey: "jump") == nil {
            player.run(jumpAction, withKey:"jump")
        }
    }*/
    
    private func gameOver(didWin: Bool) {
        print("- - - Game Ended - - -")
        //let menuScene = MenuScene(size: self.size)
        //menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
        //let transition = SKTransition.flipVertical(withDuration: 1.0)
        //menuScene.scaleMode = SKSceneScaleMode.aspectFill
        //self.scene!.view?.presentScene(menuScene, transition: transition)
        isDied = false
        isGameStarted = false
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let menuScene = SKScene(fileNamed: "MenuScene")
        let skView = self.view as SKView!
        menuScene?.scaleMode = .aspectFill
        skView?.presentScene(menuScene!, transition: transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



/*  // - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 {
 for (UITouch *touch in touches) {
 CGPoint touchLocation = [touch locationInNode:self];
 if (touchLocation.x > self.size.width / 2.0) {
 self.player.mightAsWellJump = YES;
 } else {
 self.player.forwardMarch = YES;
 }
 }
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 for (UITouch *touch in touches) {
 
 float halfWidth = self.size.width / 2.0;
 CGPoint touchLocation = [touch locationInNode:self];
 
 //get previous touch and convert it to node space
 CGPoint previousTouchLocation = [touch previousLocationInNode:self];
 
 if (touchLocation.x > halfWidth && previousTouchLocation.x <= halfWidth) {
 self.player.forwardMarch = NO;
 self.player.mightAsWellJump = YES;
 } else if (previousTouchLocation.x > halfWidth && touchLocation.x <= halfWidth) {
 self.player.forwardMarch = YES;
 self.player.mightAsWellJump = NO;
 }
 }
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 
 for (UITouch *touch in touches) {
 CGPoint touchLocation = [touch locationInNode:self];
 if (touchLocation.x < self.size.width / 2.0) {
 self.player.forwardMarch = NO;
 } else {
 self.player.mightAsWellJump = NO;
 }
 }
 }
 
 // - (void);update;:(NSTimeInterval)delta
 func update(_ currentTime: TimeInterval)
 {
 CGPoint.self gravity = CGPoint(0.0, -450.0)
 CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta);
 //1
 CGPoint; forwardMove = CGPoint(800.0, 0.0);
 CGPoint forwardMoveStep = CGPointMultiplyScalar(forwardMove, delta);
 
 self.velocity = CGPointAdd(self.velocity, gravityStep);
 //2
 self.velocity = CGPoint(self.velocity.x * 0.9, self.velocity.y);
 //3
 //Jumping code goes here
 CGPoint jumpForce = CGPointMake(0.0, 310.0);
 
 if (self.mightAsWellJump && self.onGround) {
 self.velocity = CGPointAdd(self.velocity, jumpForce);
 }
 
 if (self.forwardMarch) {
 self.velocity = CGPointAdd(self.velocity, forwardMoveStep);
 }
 //4
 CGPoint minMovement = CGPointMake(0.0, -450);
 CGPoint maxMovement = CGPointMake(120.0, 250.0);
 self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x), Clamp(self.velocity.y, minMovement.y, maxMovement.y));
 
 CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
 
 self.desiredPosition = CGPointAdd(self.position, velocityStep);
 }
 */


//override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//  fireTorpedo()
//}

    
 /*   override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }*/



    /*
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }*/

