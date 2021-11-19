//
//  AirMonetizationAdapterExtras-extension.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 22.09.21.
//

import Foundation
import AirMonetizationSDK
import GoogleMobileAds

extension AirMonetizationAdapterSettings: GADAdNetworkExtras {
    @nonobjc internal class func instance(fromAdmobParameters dictionary: [AnyHashable: Any]?) throws -> AirMonetizationAdapterSettings {
        let adSettings = try AirMonetizationAdapterSettings.instance(from: dictionary ?? Dictionary())
        AirMonetization.shared.setAPIKey(key: adSettings.APIKey, appID: adSettings.appID)
        AirMonetization.shared.setTestMode(testMode: adSettings.testMode)
        return adSettings
    }
}

@objc public final class GADMAdapterAirMonetization: NSObject {
    @objc public static let defaultLabel = "AirNowMedia"

    @objc public class func customEventExtra(with airMonetizationAdSettings: AirMonetizationAdapterSettings, for label: String = defaultLabel) -> GADCustomEventExtras {
        let customEventExtras = GADCustomEventExtras()
        if let parameters = try? airMonetizationAdSettings.toDictionary() {
            customEventExtras.setExtras(parameters, forLabel: label)
        }
        return customEventExtras
    }
}

extension GADCustomEventExtras {
    func setRewardedUserId(userId: String) {
        self.setExtras(["user_id": userId], forLabel: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationCustomExtrasLabel)
    }
    
    func getRewardedUserID() -> String? {
        guard
            let dictionary = self.extras(forLabel: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationCustomExtrasLabel),
            let rewardedUserId = dictionary["user_id"] as? String
        else
        {
            return nil
        }
        
        return rewardedUserId
    }
}
