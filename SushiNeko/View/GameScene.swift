//
//  GameScene.swift
//  SushiNeko
//
//  Created by Macbook Pro 15 on 11/11/19.
//  Copyright © 2019 SamuelFolledo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
//MARK: Properties
    let punch = SKAction(named: "punch")!
    var sushiTower: [SushiPiece] = []
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var state: GameState = .title /* Game management */
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
      didSet {
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            /* Cap Health */
            if health > 1.0 { health = 1.0 }
            healthBar.xScale = health
      }
    }
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
      didSet {
        scoreLabel.text = String(score)
      }
    }
    var highScoreLabel: SKLabelNode!
    var gameTitleLabel: SKLabelNode!
    var tapToPlayLabel: SKLabelNode!
    
    
//MARK: App LifeCycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: kBASESUSHI) as? SushiPiece //connect game object from .sks
        sushiBasePiece.connectChopsticks()
        character = childNode(withName: kCHARACTER) as? Character
        addTowerPiece(side: .none)
        addRandomPieces(total: 10)
        playButton = childNode(withName: kPLAYBUTTON) as? MSButtonNode
        playButton.selectedHandler = { /* Setup play button selection handler */
            self.state = .ready /* Start game */
        }
        healthBar = childNode(withName: kHEALTHBAR) as! SKSpriteNode
    }
    
//MARK: Update
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if state != .playing { return }
        /* Decrease Health */
        health -= 0.01
        /* Has the player ran out of health? */
        if health < 0 {
            gameOver()
        }
        moveTowerDown()
    }
    
//MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { /* Called when a touch begins */
        if state == .gameOver || state == .title { return } /* Game not ready to play */
        if state == .ready { state = .playing } /* Game begins on first touch */
        /* We only need a single touch here */
        let touch = touches.first!
        /* Get touch position in scene */
        let location = touch.location(in: self)
        /* Was touch on left/right hand side of screen? */
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        if let firstPiece = sushiTower.first as SushiPiece? { /* Grab sushi piece on top of the base sushi piece, it will always be 'first' */
            if character.side == firstPiece.side { /* Check character side against sushi piece side (this is our death collision check)*/
                gameOver()
                return /* No need to continue as player is dead */
            }
            /* Remove from sushi tower array */
            sushiTower.removeFirst()
            firstPiece.flip(character.side)
            addRandomPieces(total: 1) /* Add a new sushi piece to the top of the sushi tower */
        }
        health += 0.1
        /* Increment Score */
        score += 1
    }
    
//MARK: Helper Methods
    func gameOver() {
        state = .gameOver
        /* Create turnRed SKAction */
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        /* Turn all the sushi pieces red*/
        sushiBasePiece.run(turnRed)
        for sushiPiece in sushiTower {
            sushiPiece.run(turnRed)
        }
        character.run(turnRed) /* Make the player turn red */
        playButton.selectedHandler = { /* Change play button selection handler */
            let skView = self.view as SKView? /* Grab reference to the SpriteKit view */
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else { /* Load Game scene */
                return
            }
            scene.scaleMode = .aspectFill /* Ensure correct aspect mode */
            skView?.presentScene(scene) /* Restart GameScene */
        }
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
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
