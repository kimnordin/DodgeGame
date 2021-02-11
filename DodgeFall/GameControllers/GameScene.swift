//
//  GameScene.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

let gameTime = 60.0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: Game Properties
    // MARK:-
    
    // MARK: HUD
    var scoreLabel: SKLabelNode?
    var currentScore: Int = 0 {
        didSet {
            self.scoreLabel?.text = "SCORE: \(self.currentScore)"
        }
    }
    
    // MARK: Nodes
    var bottomBar: SKSpriteNode?
    var player: Player? = Player(color: .red, size: CGSize(width: 50, height: 50))
    var block = Block(color: .yellow, size: CGSize(width: 50, height: 50))
    
    // MARK: Sound
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    var backgroundNoise: SKAudioNode!
    
    // MARK: Arrays
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    var blocks = [Block]()
    var walls = [Wall]()
    let trackVelocities = [380, 400, 450]
    var velocityArray = [Int]()
    
    // MARK: Collision Cateogires
    let playerCategory: UInt32 = 0x1 << 0 //1
    let wallCategory: UInt32 = 0x1 << 1 //2
    let enemyCategory: UInt32 = 0x1 << 2 //4
    let powerUpCategory: UInt32 = 0x1 << 3 //8
    
    var playerVelocity = CGVector(dx: 0, dy: 0)
    var currentTrack = 1
    var movingToTrack = false
    
    override func didMove(to view: SKView) {
        addTracks()
        addPlayer()
        createHUD()
        
        self.physicsWorld.contactDelegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        for _ in 0...2 {
            let randomNumberForVelocty = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
            velocityArray.append(trackVelocities[randomNumberForVelocty])
        }
        
        for vel in velocityArray {
            print("velocity: ", vel)
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnEnemies()
        }, SKAction.wait(forDuration: 0.5)]
        )))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
        }
        else {
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
            self.run(SKAction.playSoundFileNamed("fail.wav", waitForCompletion: true))
//            movePlayerToStart()
            if let otherNode = otherBody.node {
                removeEnemy(node: otherNode)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
