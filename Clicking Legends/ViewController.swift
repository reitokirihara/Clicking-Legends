//
//  ViewController.swift
//  Clicking Legends
//
//  Created by Reito Kirihara on 4/8/18.
//  Copyright © 2018 Reito Kirihara. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet var hpLabel: UILabel!
    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var hpProgressBar: UIProgressView!
    @IBOutlet var clickDamageLabel: UILabel!
    @IBOutlet var damagePerSecondLabel: UILabel!
    @IBOutlet var enemyLevelLabel: UILabel!
    
    //player
    @IBOutlet var playerLevelLabel: UILabel!
    @IBOutlet var playerExperinceProgressLabel: UILabel!
    @IBOutlet var playerHpProgress: UIProgressView!
    @IBOutlet var playerLevelProgressBar: UIProgressView!
    
    //hire buttons
    @IBOutlet var hireLegendOneButton: UIButton!
    @IBOutlet var hireLegendTwoButton: UIButton!
    @IBOutlet var skView:SKView!
    
    var hp: Float = 0
    var maxHp: Float = 0
    var coins: Int = 0
    var rewardCoins: Int!
    var enemyLevel: Float = 1.0
    var killedNumber: Float = 0
    
    var playerLevel: Int = 1
    var rewardExperience: Float!
    var currentPlayerExperience: Float = 0
    var playerHp: Float = 0
    var maxPlayerHp: Float = 0
    
    var maxEp: Float = 0
    var extraEp: Float!
    
    //damage variables
    var clickDamage: Float = 1
    var damagePerSecond: Float = 0

    //price for legends
    var priceForLegendOne: Int = 5
    var priceForLegendTwo: Int = 25
    
    private var dragon = SKSpriteNode()
    private var dragonFlying: [SKTexture] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = skView as? SKView {
            //init SKScene
            // Create the scene programmatically
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            //view.presentScene(SKScene)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        playerHp = 5 * Float(playerLevel)
        maxPlayerHp = 5 * Float(playerLevel)
        maxEp = enemyLevel * 20
        spawnNewEnemy(level: 1)
        
        playerLevelProgressBar.progress = 0
        
        coinLabel.text = "💰 \(coins)"
        hpLabel.text = "\(hp) HP"
        clickDamageLabel.text = "Click Damage \(clickDamage)"
        damagePerSecondLabel.text = "DPS \(damagePerSecond)"
        playerExperinceProgressLabel.text = "0/\(maxEp)"
        
        coinLabel.sizeToFit()
        hpLabel.sizeToFit()
        clickDamageLabel.sizeToFit()
        damagePerSecondLabel.sizeToFit()
        playerExperinceProgressLabel.sizeToFit()
        
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(automatedDamage), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapEnemy(_ sender: AnyObject) {
        damage(dmg: clickDamage)
    }
    
    @IBAction func hireLegendOne(_ sender: AnyObject) {
      
        if(coins >= priceForLegendOne) {
            coins -= priceForLegendOne
            clickDamage += 1
            priceForLegendOne += 5
        }
        
        clickDamageLabel.text = "Click Damage \(clickDamage)"
        clickDamageLabel.sizeToFit()
        
        hireLegendOneButton.setTitle("Hire     💰\(priceForLegendOne)", for: .normal)
        hireLegendOneButton.sizeToFit()
    
        changeCoinLabel()
        
    }
    
    @IBAction func hireLegendTwo(_ sender: AnyObject) {
        
        if(coins >= priceForLegendTwo) {
            coins -= priceForLegendTwo
            damagePerSecond += 20
            priceForLegendTwo += 25
        }
        
        damagePerSecondLabel.text = "DPS \(damagePerSecond)"
        damagePerSecondLabel.sizeToFit()
        
        hireLegendTwoButton.setTitle("Hire     💰\(priceForLegendTwo)", for: .normal)
        hireLegendTwoButton.sizeToFit()
        
        changeCoinLabel()
    }
    
    func spawnNewEnemy(level: Float){
        hp = level * 5
        maxHp = hp
        rewardExperience = enemyLevel
        currentPlayerExperience += rewardExperience
        if(currentPlayerExperience >= maxEp) {
            extraEp = currentPlayerExperience - maxEp
            currentPlayerExperience = 0
            playerLevel += 1
            maxEp = Float(playerLevel * 20)
            currentPlayerExperience += extraEp
            playerLevelLabel.text = "\(playerLevel)"
            performSegue(withIdentifier: "levelUpSegue", sender: nil)
        }
        playerLevelProgressBar.progress = currentPlayerExperience/maxEp
        playerExperinceProgressLabel.text = "\(currentPlayerExperience)/\(maxEp)"
        playerExperinceProgressLabel.sizeToFit()
        
        enemyLevelLabel.text = "Enemy Level \(enemyLevel)"
        enemyLevelLabel.sizeToFit()
    }
    
    func getRewardCoin(){
        rewardCoins = Int(enemyLevel)
        coins += rewardCoins
        coinLabel.text = "💰 \(coins)"
        coinLabel.sizeToFit()
    }
    
    func changeCoinLabel() {
        coinLabel.text = "💰 \(coins)"
        coinLabel.sizeToFit()
    }
    
    func damage(dmg: Float){
        hp -= dmg
        
        if(hp <= 0){
            killedNumber += 1

            if (killedNumber >= enemyLevel * 5) {
                spawnNewEnemy(level: enemyLevel + 1)
                enemyLevel += 1
                getRewardCoin()
            } else {
                spawnNewEnemy(level: enemyLevel)
                getRewardCoin()
            }
        }
        hpProgressBar.progress = hp / maxHp
        hpLabel.text = "\(hp) HP"
        hpLabel.sizeToFit()
    }
   
    @objc
    func automatedDamage(_ timer: Timer){
        damage(dmg: damagePerSecond/100)
    }
    
    @objc
    func enemyAttack(){
        playerHp -= enemyLevel * 5
        playerHpProgress.progress = playerHp/maxPlayerHp
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "levelUpSegue" {
            let controller = segue.destination as! LevelUpViewController
            controller.level = playerLevel
        }
    }
    
    func buildDragon() {
        let dragonAnimatedAtlas = SKTextureAtlas(named: "dragonImages")
        var flyFrames: [SKTexture] = []
        
        for i in 4...6 {
            let dragonTextureName = "tile\(i)"
            flyFrames.append(dragonAnimatedAtlas.textureNamed(dragonTextureName))
        }
        dragonFlying = flyFrames
        
        let firstFrameTexture = dragonFlying[0]
        dragon = SKSpriteNode(texture: firstFrameTexture)
        dragon.position = CGPoint(x: 100, y: 100)
        skView.scene?.addChild(dragon)
    }
    func animateDragon() {
        dragon.run(<#T##action: SKAction##SKAction#>, withKey: <#T##String#>)
    }

}


