//
//  GameScene.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: Game Properties
    // MARK:-
    
    // MARK: Nodes
    var player: Player? = Player(color: .red, size: CGSize(width: 50, height: 50))
    var block = Block(color: .yellow, size: CGSize(width: 50, height: 50))
    
    // MARK: Sound
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    var backgroundNoise: SKAudioNode!
    
    // MARK: Arrays
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    var blocks = [Block]()
    var walls = [Wall]()
    let trackVelocities = [180, 200, 250]
    var velocityArray = [Int]()
    
    // MARK: Collision Cateogires
    let playerCategory: UInt32 = 0x1 << 0 //1
    let wallCategory: UInt32 = 0x1 << 1 //2
    let enemyCategory: UInt32 = 0x1 << 2 //4
    let powerUpCategory: UInt32 = 0x1 << 3 // 8
    
    var playerVelocity = CGVector(dx: 0, dy: 0)
    var currentTrack = 1
    var movingToTrack = false
    
    override func didMove(to view: SKView) {
        addTracks()
        addPlayer()
        
        self.physicsWorld.contactDelegate = self

        for _ in 0...2 {
            let randomNumberForVelocty = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
            velocityArray.append(trackVelocities[randomNumberForVelocty])
        }
        
        for vel in velocityArray {
            print("velocity: ", vel)
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnEnemies()
        }, SKAction.wait(forDuration: 1)]
        )))
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first

            if node?.name == "up" {
                moveVertically(up: true)
            }
            else if node?.name == "down" {
                moveVertically(up: false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !movingToTrack {
//            player?.removeAllActions()
//        }
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
            print("Enemy Hit")
            movePlayerToStart()
            if let otherNode = otherBody.node {
                removeEnemy(node: otherNode)
            }
        }
        
//        else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == targetCategory {
//            print("Target hit")
//            nextLevel(playerPhysicsBody: playerBody)
//        }
//        else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == powerUpCategory {
//            self.run(SKAction.playSoundFileNamed("powerUp.wav", waitForCompletion: true))
//            otherBody.node?.removeFromParent()
//            remainingTime += 5
//        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
