//
//  GameScene.swift
//  SushiNeko
//
//  Created by Macbook Pro 15 on 11/11/19.
//  Copyright © 2019 SamuelFolledo. All rights reserved.
//

import SpriteKit
import GameplayKit

/* Tracking enum for use with character and sushi side */
enum Side {
    case left, right, none
}

class GameScene: SKScene {
    
    var sushiTower: [SushiPiece] = []
    var sushiBasePiece: SushiPiece!
    var character: Character!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: kBASESUSHI) as? SushiPiece //connect game object from .sks
        sushiBasePiece.connectChopsticks()
        character = childNode(withName: kCHARACTER) as? Character
        addTowerPiece(side: .none)
        addRandomPieces(total: 10)
    }
    
    func addRandomPieces(total: Int) { /* Add random sushi pieces to the sushi tower */
      for _ in 1...total {
          let lastPiece = sushiTower.last! /* Need to access last piece properties */
          if lastPiece.side != .none { /* Need to ensure we don't create impossible sushi structures */
             addTowerPiece(side: .none)
          } else {
             /* Random Number Generator */
             let rand = arc4random_uniform(100)
             if rand < 45 {
                /* 45% Chance of a left piece */
                addTowerPiece(side: .left)
             } else if rand < 90 {
                /* 45% Chance of a right piece */
                addTowerPiece(side: .right)
             } else {
                /* 10% Chance of an empty piece */
                addTowerPiece(side: .none)
             }
          }
      }
    }
    
    func addTowerPiece(side: Side) { /* Add a new sushi piece to the sushi tower */
       let newPiece = sushiBasePiece.copy() as! SushiPiece /* Copy original sushi piece */
       newPiece.connectChopsticks()
       let lastPiece = sushiTower.last /* Access last piece properties */
       /* Add on top of last piece, default on first piece */
       let lastPosition = lastPiece?.position ?? sushiBasePiece.position
       newPiece.position.x = lastPosition.x
       newPiece.position.y = lastPosition.y + 55
       /* Increment Z to ensure it's on top of the last piece, default on first piece*/
       let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
       newPiece.zPosition = lastZPosition + 1
       /* Set side */
       newPiece.side = side
       addChild(newPiece)
       sushiTower.append(newPiece) /* Add sushi piece to the sushi tower */
    }
    
}
