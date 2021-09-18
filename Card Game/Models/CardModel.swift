//
//  CardModel.swift
//  Card Game
//
//  Created by kadir yapar on 15.9.2021.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        //Declare an array to store numbers we have already generated
        var generatedNumbersArray = [Int]()
        
        //Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        //Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            //get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                print("randomNumber: " + String(randomNumber))
                
                //store the number into the generated numbers array
                generatedNumbersArray.append(Int(randomNumber))
                
                //crreate the first card object
                let cardOne = Card()
                cardOne.imageName = String(randomNumber)
                
                generatedCardsArray.append(cardOne)
                
                //create the second card object
                let cardTwo = Card()
                cardTwo.imageName = String(randomNumber)
                
                generatedCardsArray.append(cardTwo)
            }
            
            
            
            //Make it so we only have unique pairs of cards
            generatedCardsArray.shuffle()
            
        }
        print("result: " + String(generatedCardsArray.count))
        //Randomize the array
        
        
        //Return the array
        return generatedCardsArray
    }
}
