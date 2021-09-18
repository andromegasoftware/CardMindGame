//
//  ViewController.swift
//  Card Game
//
//  Created by kadir yapar on 15.9.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var miliseconds:Float = 100*1000
    
    var soundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.shuffle)
    }
    
    @objc func timerElapsed() {
        miliseconds -= 1
        
        //convert to seconds
        let seconds = String(format: "%.2f", miliseconds/1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if(miliseconds <= 0){
            //stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //check if any cards unmatched
            checkGameEnded()
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a CardCollectionView Object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if there is any time left
        if miliseconds <= 0 {
            return
        }
        
        //get the cell user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            //Flip the card
            cell.flip()
            card.isFlipped = true
            soundManager.playSound(.flip)
            
            //determine if it is the first card or second card that is flipped over
            if firstFlippedCardIndex == nil {
                //this is the first card being flipped
                firstFlippedCardIndex = indexPath
            }
            else{
                //this is the second card being flipped
                checkForMatches(indexPath)
            }
            
        }
        else{
            
            //flip card back
            cell.flipBack()
            card.isFlipped = false
            
        }
        
    }
    
    func checkForMatches(_ seconFlippedCardIndex: IndexPath) {
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell

        let cardTwoCell = collectionView.cellForItem(at: seconFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[seconFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName{
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75){
                cardOneCell?.remove()
                cardTwoCell?.remove()
                
                self.soundManager.playSound(.match)
                
                //check if there are any card left unmatched
                self.checkGameEnded()
            }
            
        }
        else{
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            soundManager.playSound(.nomatch)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75){
                cardOneCell?.flipBack()
                cardTwoCell?.flipBack()
            }
            
        }
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        // determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray{
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        //messaging variables
        var title = ""
        var message = ""
        
        //if not, then user has won, stop the timer
        if isWon == true{
            if miliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "you have won"
        }
        else{
            
            //if there are unmatched card, check if there is any time left
            
            if miliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You have lost"
            
        }
        
        //show won/lost messaging
        
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}

