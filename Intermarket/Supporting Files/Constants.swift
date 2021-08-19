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
}

struct Images {
    static let Slice1 = UIImage(named: "slice1")
    static let Slice2 = UIImage(named: "slice2")
    static let Slice3 = UIImage(named: "slice3")
}

struct Icons {
    static let Apple = UIImage(named: "apple")
    static let Google = UIImage(named: "google")
    static let Facebook = UIImage(named: "facebook")
    static let Categories = UIImage(named: "list-solid")
}

struct UserDefaultsKeys {
    static let OnboardingCheck = "onboardingCheck"
    static let LoggedUser = "loggedUser"
}
