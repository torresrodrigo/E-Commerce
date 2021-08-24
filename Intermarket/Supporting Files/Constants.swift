//
//  Constants.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/08/2021.
//

import Foundation
import UIKit

struct Colors {
    static let Primary = UIColor(named: "Primary")
    static let Secondary = UIColor(named: "Secondary")
    static let ButtonRadiusColor = UIColor(named: "ButtonRadiusColor")?.cgColor
    static let BarTint = UIColor(named: "BarTint")
    static let Shadow = UIColor(named: "Shadow")
}

struct Images {
    static let Slice1 = UIImage(named: "slice1")
    static let Slice2 = UIImage(named: "slice2")
    static let Slice3 = UIImage(named: "slice3")
    static let Search = UIImage(named: "searchImage")
}

struct Icons {
    static let Apple = UIImage(named: "apple")
    static let Google = UIImage(named: "google")
    static let Facebook = UIImage(named: "facebook")
    static let Categories = UIImage(named: "list-solid")
    static let DotActive = UIImage(named: "dot-active")
    static let DotDefault = UIImage(named: "dot-default")
    static let Favorite = UIImage(named: "favorite")
    static let FavoriteAdded = UIImage(named: "favorite-added")
}

struct UserDefaultsKeys {
    static let OnboardingCheck = "onboardingCheck"
    static let LoggedUser = "loggedUser"
}

struct Endpoints {
    static let Search = "https://api.mercadolibre.com/sites/MLA/search?"
}
