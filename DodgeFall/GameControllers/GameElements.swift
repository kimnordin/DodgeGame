//
//  GameElements.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import GameplayKit
import SpriteKit

enum Enemies: Int {
    case slow
    case medium
    case fast
}

extension GameScene {
    
    func addTracks() {
        for i in 0...2 {
            if let track = self.childNode(withName: "track\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
    }
    
    func addPlayer(){
        // Physics
        player = Player(color: .red, size: CGSize(width: 50, height: 50))
        if let player = player {
            print("Player Created")
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
            player.physicsBody?.linearDamping = 0
            player.physicsBody?.categoryBitMask = playerCategory
            player.physicsBody?.collisionBitMask = 0
            player.physicsBody?.contactTestBitMask = enemyCategory | wallCategory
            player.physicsBody?.affectedByGravity = false
            
            guard let playerPosition = tracksArray?.first?.position.x else {return}
            player.position = CGPoint(x: 165+player.size.width, y: self.size.height/2)
            
            self.addChild(player)
        }
    }
    
    func addEnemy(type: Enemies, forTrack track: Int) -> SKShapeNode? {
        let enemySprite = SKShapeNode()
        enemySprite.name = "ENEMY"
        
        enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: tracksArray?.first?.size.height ?? 138), cornerWidth: 8, cornerHeight: 8, transform: nil)
        
        switch type {
        case .slow:
            enemySprite.fillColor = UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
        case .medium:
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.4039, blue: 0.4039, alpha: 1)
        case .fast:
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.6392, blue: 0.4039, alpha: 1)
        }
        
        guard let enemyPosition = tracksArray?[track].position else {return nil}
        
        enemySprite.position.x = self.size.width + 130
        enemySprite.position.y = enemyPosition.y - 70
        
        enemySprite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemySprite.path!)
        enemySprite.physicsBody?.categoryBitMask = enemyCategory
        enemySprite.physicsBody?.velocity = CGVector(dx: -velocityArray[track], dy: 0)
        
        return enemySprite
    }
}
