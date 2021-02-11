//
//  GameFunctions.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

enum Direction {
    case left
    case right
}

extension GameScene {
    
    func movePlayer(direction: Direction) {

        player?.removeAllActions()
        
        if direction == .left && currentTrack != 0 {
            currentTrack -= 1
        }
        else if direction == .right && currentTrack != 2 {
            currentTrack += 1
        }
        if let nextTrack = tracksArray?[currentTrack].position {
            if let player = player {
                let moveAction = SKAction.move(to: CGPoint(x: nextTrack.x, y: player.position.y), duration: 0.2)
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
            if node.position.y < 70 {
                self.removeEnemy(node: node)
                self.increaseScore()
            }
        }
    }
    
    func increaseScore() {
        currentScore += 1
    }
    
    func removeEnemy(node: SKNode) {
        node.removeFromParent()
    }
    
    func removeTouches(nodes: [SKSpriteNode?]) {
        for node in nodes {
            if let node = node {
                node.isUserInteractionEnabled = false
            }
        }
    }
    
    func endGame(){
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene)
    }
    
    func movePlayerToStart() {
        player?.removeFromParent()
        self.player = nil
        self.addPlayer()
        self.currentTrack = 0
    }

    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        movePlayer(direction: .left)
    }
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        movePlayer(direction: .right)
    }
}
