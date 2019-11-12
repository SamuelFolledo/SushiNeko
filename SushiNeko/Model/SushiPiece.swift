//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Macbook Pro 15 on 11/11/19.
//  Copyright © 2019 SamuelFolledo. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {

    /* Chopsticks objects */
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    var side: Side = .none { /* Sushi type */
        didSet {
            switch side {
            case .left:
                leftChopstick.isHidden = false
            case .right:
                rightChopstick.isHidden = false
            case .none:
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }

    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectChopsticks() {
        rightChopstick = childNode(withName: "rightChopstick") as? SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as? SKSpriteNode
        side = .none
    }
}
