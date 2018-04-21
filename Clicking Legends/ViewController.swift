//
//  ViewController.swift
//  Clicking Legends
//
//  Created by Reito Kirihara on 4/8/18.
//  Copyright © 2018 Reito Kirihara. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet var hpLabel: UILabel!
    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var hpProgressBar: UIProgressView!
    @IBOutlet var clickDamageLabel: UILabel!
    @IBOutlet var damagePerSecondLabel: UILabel!
    @IBOutlet var enemyLevelLabel: UILabel!
    @IBOutlet var potionsLeftLabel: UILabel!
    @IBOutlet var enemyButton: UIButton!
    
    //player
    @IBOutlet var playerLevelLabel: UILabel!
    @IBOutlet var playerExperinceProgressLabel: UILabel!
    @IBOutlet var playerHpProgress: UIProgressView!
    @IBOutlet var playerLevelProgressBar: UIProgressView!
    
    //hire buttons
    @IBOutlet var hireLegendOneButton: UIButton!
    @IBOutlet var hireLegendTwoButton: UIButton!
    
    var hp: Float = 0
    var maxHp: Float = 0
    var coins: Int = 0
    var rewardCoins: Int!
    var enemyLevel: Float = 1.0
    var killedNumber: Float = 0
    var potions: Float = 0
    var priceOfPotion: Int = 10
    var numberOfPotions: Float = 0
    var autoClickCount: Int = 0
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapEnemy(_ sender: AnyObject) {
        damage(dmg: clickDamage)
        enemyButton.setImage(UIImage(named: "enemyHit"), for: .highlighted)
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
    
    @IBAction func buyPotion(_ sender: AnyObject){
        if(coins >= priceOfPotion) {
            coins -= priceOfPotion
            coinLabel.text = "💰 \(coins)"
            coinLabel.sizeToFit()
            
            numberOfPotions += 1
            
            potionsLeftLabel.text = "Potions Left: \(numberOfPotions)"
            potionsLeftLabel.sizeToFit()
        }
    }
    
    @IBAction func usePotion(_ sender: AnyObject){
        if(numberOfPotions > 0) {
            activatePotion()
        }
    }
    
    @IBAction func automaticClick(_ sender: Any) {
        if(autoClickCount == 0) {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(tapDamage), userInfo: nil, repeats: true)
            autoClickCount += 1
        } else {
            return
        }
    }
    
    func spawnNewEnemy(level: Float){
        hp = (level - level/2) * pow(level, 3)
        maxHp = hp
        rewardExperience = round(enemyLevel/2)
        currentPlayerExperience += rewardExperience
        if(currentPlayerExperience >= maxEp) {
            extraEp = currentPlayerExperience - maxEp
            currentPlayerExperience = 0
            playerLevel += 1
            maxEp = Float(playerLevel * 20)
            currentPlayerExperience += extraEp
            playerLevelLabel.text = "\(playerLevel)"
            maxPlayerHp = 25 * Float(playerLevel)
            playerHp = maxPlayerHp
            playerHpProgress.progress = playerHp/maxPlayerHp
            performSegue(withIdentifier: "levelUpSegue", sender: nil)
        }
        playerLevelProgressBar.progress = currentPlayerExperience/maxEp
        playerExperinceProgressLabel.text = "\(currentPlayerExperience)/\(maxEp)"
        playerExperinceProgressLabel.sizeToFit()
        
        enemyLevelLabel.text = "Enemy Level \(enemyLevel)"
        enemyLevelLabel.sizeToFit()
    }
    
    func getRewardCoin(){
        rewardCoins = Int(enemyLevel/3) * Int(pow(enemyLevel, 2))
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
    func tapDamage(_ timer: Timer){
        damage(dmg: clickDamage)
    }
    
    @objc
    func enemyAttack(){
        playerHp -= round(enemyLevel/2)
        playerHpProgress.progress = playerHp/maxPlayerHp
        if(playerHp <= 0) {
            performSegue(withIdentifier: "gameOverSegue", sender: nil)
        }
    }
    
    func activatePotion(){
        playerHp = maxPlayerHp
        playerHpProgress.progress = playerHp/maxPlayerHp
        
        numberOfPotions -= 1
        potionsLeftLabel.text = "Potions Left \(numberOfPotions)"
        potionsLeftLabel.sizeToFit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "levelUpSegue" {
            let controller = segue.destination as! LevelUpViewController
            controller.level = playerLevel
        } else if segue.identifier == "gameOverSegue" {
            let controller = segue.destination as! GameOverViewController
        }
    }
}


