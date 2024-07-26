//
//  Assets.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 17/03/2024.
//

import UIKit

enum Assets {
    enum Colors {
        enum Palette {
            static let azure = UIColor(named: "azure")
            static let blueViolet = UIColor(named: "blueViolet")
            static let brilliantAzure = UIColor(named: "brilliantAzure")
            static let carrot = UIColor(named: "carrot")
            static let cornflowerBlue = UIColor(named: "cornflowerBlue")
            static let cosmicCobalt = UIColor(named: "cosmicCobalt")
            static let eucalyptus = UIColor(named: "eucalyptus")
            static let herbalGreen = UIColor(named: "herbalGreen")
            static let macaroniAndCheese = UIColor(named: "macaroniAndCheese")
            static let mediumOrchid = UIColor(named: "mediumOrchid")
            static let mediumPurple = UIColor(named: "mediumPurple")
            static let orchid = UIColor(named: "orchid")
            static let paleMagentaPink = UIColor(named: "paleMagentaPink")
            static let palePink = UIColor(named: "palePink")
            static let tartOrange = UIColor(named: "tartOrange")
            static let tomato = UIColor(named: "tomato")
            static let UFOGreen = UIColor(named: "UFOGreen")
            static let violette = UIColor(named: "violette")
        }
        static let launchBlue = UIColor(named: "Launch")
        static let background = UIColor(named: "Background")
        static let navBarItem = UIColor(named: "NavigationBarItem")
        static let buttons = UIColor(named: "Buttons")
        static let subtitle = UIColor(named: "subtitleText")
        static let buttonTitle = UIColor(named: "ButtonTitle")
    }
    
    enum Images {
        struct Background {
            static let emptyTrackers = UIImage(named: "EmptyTrackers")
            static let emptyStatistic = UIImage(named: "EmptyStatistic")
            static let emptySearchResults = UIImage(named: "EmptySearchResult")
            
            
        }
        static let logo = UIImage(named: "Logo")
        static let done = UIImage(named: "TrackerDone")
        static let plus = UIImage(named: "TrackerPlus")
    }
    
    enum Fonts {
        static let ypBold = UIFont(name: "YS-Display-Bold", size: 12)
        static let ypMedium = UIFont(name: "YS-Display-Medium", size: 12)
    }
}
