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
    
    //player
    @IBOutlet var playerLevelLabel: UILabel!
    @IBOutlet var playerExperinceProgressLabel: UILabel!
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
    var playerLevel: Int = 1
    var rewardExperience: Float!
    var currentPlayerExperience: Float = 0
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
        
        maxEp = enemyLevel * 5
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
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(automatedDamage), userInfo: nil, repeats: true)
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
            currentPlayerExperience += extraEp
        }
        playerLevelProgressBar.progress = currentPlayerExperience/maxEp
        playerExperinceProgressLabel.text = "\(currentPlayerExperience)/\(maxEp)"
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
        damage(dmg: damagePerSecond)
    }
}

