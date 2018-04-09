//
//  ViewController.swift
//  Clicking Legends
//
//  Created by Reito Kirihara on 4/8/18.
//  Copyright © 2018 Reito Kirihara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var hpLabel: UILabel!
    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var hpProgressBar: UIProgressView!
    @IBOutlet var clickDamageLabel: UILabel!
    @IBOutlet var hireLegendOneButton: UIButton!
    
    var hp: Float = 5
    var maxHp: Float = 5
    var coins: Int = 0
    var clickDamage: Float = 1
    var rewardCoins: Int!
    var arenaNumber: Int = 1

    //variables for legend one
    var priceForLegendOne: Int = 0
    var numberOfLegendOne: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        coinLabel.text = "💰 \(coins)"
        hpLabel.text = "\(hp) HP"
        clickDamageLabel.text = "Click Damage \(clickDamage)"
        
        coinLabel.sizeToFit()
        hpLabel.sizeToFit()
        clickDamageLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapEnemy(_ sender: AnyObject) {
        hp -= clickDamage
        if(hp <= 0){
            spawnNewEnemy()
            getRewardCoin()
        }
        hpProgressBar.progress = hp / maxHp
        hpLabel.text = "\(hp) HP"
        hpLabel.sizeToFit()
    }
    
    @IBAction func hireLegendOne(_ sender: AnyObject) {
        if(numberOfLegendOne == 0) {
            priceForLegendOne = 5
            if(coins >= priceForLegendOne) {
                numberOfLegendOne += 1
                coins -= 5
                clickDamage += 1
            }
        } else {
            priceForLegendOne = numberOfLegendOne * 5
            if(coins >= priceForLegendOne) {
                coins -= priceForLegendOne
                numberOfLegendOne += 1
                clickDamage += 1
            }
        }
        
        clickDamageLabel.text = "Click Damage \(clickDamage)"
        clickDamageLabel.sizeToFit()
        
        hireLegendOneButton.setTitle("Hire \(priceForLegendOne)", for: .normal)
        hireLegendOneButton.sizeToFit()
        
        coinLabel.text = "💰 \(coins)"
        coinLabel.sizeToFit()
    
    }
    
    func spawnNewEnemy(){
        hp = maxHp + 50
        maxHp = hp
    }
    
    func getRewardCoin(){
        rewardCoins = arenaNumber * 50
        coins += rewardCoins
        coinLabel.text = "💰 \(coins)"
        coinLabel.sizeToFit()
    }
}

