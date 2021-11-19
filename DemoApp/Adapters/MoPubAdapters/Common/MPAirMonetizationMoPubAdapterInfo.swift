//
//  MPAirMonetizationMoPubAdapterInfo.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 24.09.21.
//

import Foundation

struct MPAirMonetizationMoPubAdapterInfo {
    
    let apiKey: String
    let appID: String
    let testMode: Bool
    let placementName: String?
    let rewardedUserId: String?
    
    init?(remote: [AnyHashable: Any], local: [AnyHashable: Any]?) {
        
        if let localApiKey = local?[Constants.ExtraKey.APIKey] as? String {
            apiKey = localApiKey
        } else if let remoteApiKey = remote[Constants.ExtraKey.APIKey] as? String {
            apiKey = remoteApiKey
        } else {
            return nil
        }
        
        if let localAppId = local?[Constants.ExtraKey.appID] as? String {
            appID = localAppId
        } else if let remoteApiKey = remote[Constants.ExtraKey.appID] as? String {
            appID = remoteApiKey
        } else {
            return nil
        }
        
        if let localTestingMode = local?[Constants.ExtraKey.testMode] as? Bool {
            testMode = localTestingMode
        } else if let remoteTestingMode = remote[Constants.ExtraKey.testMode] as? Bool {
            testMode = remoteTestingMode
        } else {
            testMode = false
        }
        
        if let localPlacementName = local?[Constants.ExtraKey.placementName] as? String {
            placementName = localPlacementName
        } else if let remotePlacementName = remote[Constants.ExtraKey.placementName] as? String {
            placementName = remotePlacementName
        } else {
            placementName = nil
        }
        
        if let localRewardedUserId = local?[Constants.ExtraKey.rewardedUserId] as? String {
            rewardedUserId = localRewardedUserId
        } else if let remoteRewardedUserId = remote[Constants.ExtraKey.rewardedUserId] as? String {
            rewardedUserId = remoteRewardedUserId
        } else {
            rewardedUserId = nil
        }
    }
    
}
