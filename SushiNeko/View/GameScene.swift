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
    
//    let kBACKGROUND: String = "background"
    let kBASESUSHI: String = "sushiBasePiece"
//    let kLEFTCHOPSTICK: String = "leftChopstick"
//    let kRIGHTCHOPSTICK: String = "rightChopstick"
    let kCHARACTER: String = "character"
    var sushiBasePiece: SushiPiece!
    var character: Character!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: kBASESUSHI) as? SushiPiece //connect game object from .sks
        sushiBasePiece.connectChopsticks()
        character = childNode(withName: kCHARACTER) as? Character
        
    }
    
}
