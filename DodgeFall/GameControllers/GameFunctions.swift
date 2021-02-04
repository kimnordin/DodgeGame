//
//  GameFunctions.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func moveVertically(up: Bool) {

        player?.removeAllActions()
        
        if up && currentTrack != 0 {
            currentTrack -= 1
        }
        else if !up && currentTrack != 2 {
            currentTrack += 1
        }
        if let nextTrack = tracksArray?[currentTrack].position {
            if let player = player {
                let moveAction = SKAction.move(to: CGPoint(x: player.position.x, y: nextTrack.y), duration: 0.2)
                player.run(moveAction)
            }
        }
    }
    
    
    func spawnEnemies() {
        let randomTracks = [0, 1, 2]
        let roll = randomTracks[Int(arc4random_uniform(UInt32(randomTracks.count)))]
        
        
        let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
        if let newEnemy = addEnemy(type: randomEnemyType, forTrack: roll) {
            self.addChild(newEnemy)
            print("newEnemy track: ", roll)
        }
        
        self.enumerateChildNodes(withName: "ENEMY") { (node:SKNode, nil) in
            if node.position.x < 156 {
                node.removeFromParent()
            }
        }
    }
    
    func removeEnemy(node: SKNode) {
        node.removeFromParent()
    }
    
    func movePlayerToStart() {
        player?.removeFromParent()
        self.player = nil
        self.addPlayer()
        self.currentTrack = 0
    }
}
