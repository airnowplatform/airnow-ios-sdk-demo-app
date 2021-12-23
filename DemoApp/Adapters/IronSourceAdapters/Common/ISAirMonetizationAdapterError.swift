//
//  ISAirMonetizationAdapterError.swift
//  AirnowMediationWithIS
//
//  Created by Gusakovsky, Sergey on 14.12.21.
//

import Foundation

enum ISAirMonetizationAdapterError: Error, CustomStringConvertible {
    case rewardedNotAvailable
    case interstitialNotAvailable
    case bannerNotAvailable
    case noApiKeyOrAppId
    case placementNameForRewardedNotFound
    
    var description: String {
        switch self {
        case .interstitialNotAvailable:
            return "Interstitial Not Available"
        case .bannerNotAvailable:
            return "Banner Not Available"
        case .rewardedNotAvailable:
            return "Rewarded Not Available"
        case .noApiKeyOrAppId:
            return "No Api Key or App ID"
        case .placementNameForRewardedNotFound:
            return "Placement name for Rewarded Ad not found"
        }
    }
    
}
