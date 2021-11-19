//
//  AppDelegate.swift
//  AirMonetizationDemo
//
//  Created by Gusakovsky, Sergey on 26.05.21.
//

import UIKit
import AirMonetizationSDK
import MoPubSDK
import GoogleMobileAds
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let airMonetizationAPIKEY: String = <#YOUR_AIRNOW_API_KEY#>
    static let airMonetizationAPPID: String = <#YOUR_AIRNOW_APP_ID#>
    
    /**
     *  TEST OR PRODUCTION SDK MODE.
     *  SEE AIRNOW DOCS.
     */
    static let airMonetizationTestMode: Bool = true
    
    static let airMonetizationRewardedPlacementName: String = <#YOUR_AIRNOW_REWARDED_PLACEMENT_NAME#>
    
    /**
     *  UNIQUE USER ID FOR EACH USER.
     *  ONLY FOR REWAREDED ADS.
     *  SEE AIRNOW DOCS.
     */
    static var airMonetizationTestRewardedUserID: String {
        if let userId = UserDefaults.standard.string(forKey: "AirnowRewardedUserId") {
            return userId
        } else {
            let newUserId = UUID().uuidString
            UserDefaults.standard.set(newUserId, forKey: "AirnowRewardedUserId")
            return newUserId
        }
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        DispatchQueue.main.async {
            self.setupTrackingIDFA()
            
            //MARK: - AirMonetizationSDK initialization
            AirMonetization.shared.setAPIKey(key: AppDelegate.airMonetizationAPIKEY,
                                             appID: AppDelegate.airMonetizationAPPID)
            AirMonetization.shared.setTestMode(testMode: AppDelegate.airMonetizationTestMode)
            
            //MARK: - AdMob initialization
            let ads = GADMobileAds.sharedInstance()
            ads.start { status in
                // Optional: Log each adapter's initialization latency.
                let adapterStatuses = status.adapterStatusesByClassName
                for adapter in adapterStatuses {
                    let adapterStatus = adapter.value
                    NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
                          adapterStatus.description, adapterStatus.latency)
                }
                /**
                 *  If you are using Admob in test mode,
                 *  please add your test device here.
                 *  For example: GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["c82329403fae38f611c7b4a63ec3e839"]
                 */
                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = []
            }
            
            //MARK: - MoPub initialization
            let airMonetizationCommonConfiguration: [String: Any] = [
                "api_key": AppDelegate.airMonetizationAPIKEY,
                "app_id": AppDelegate.airMonetizationAPPID,
                "test_mode": AppDelegate.airMonetizationTestMode
            ]
            let airMonetizationBannerConfiguration: [String: Any] = [
                "api_key": AppDelegate.airMonetizationAPIKEY,
                "app_id": AppDelegate.airMonetizationAPPID,
                "test_mode": AppDelegate.airMonetizationTestMode,
            ]
            let airMonetizationInterstitialConfiguration: [String: Any] = [
                "api_key": AppDelegate.airMonetizationAPIKEY,
                "app_id": AppDelegate.airMonetizationAPPID,
                "test_mode": AppDelegate.airMonetizationTestMode,
            ]
            let airMonetizationRewardedConfiguration: [String: Any] = [
                "api_key": AppDelegate.airMonetizationAPIKEY,
                "app_id": AppDelegate.airMonetizationAPPID,
                "test_mode": AppDelegate.airMonetizationTestMode,
                "placement_name": AppDelegate.airMonetizationRewardedPlacementName,
                "user_id": AppDelegate.airMonetizationTestRewardedUserID
            ]
            let config = MPMoPubConfiguration(adUnitIdForAppInitialization: MoPubAdUnits.kMoPubInterstitialAdUnitID)
            config.setNetwork(airMonetizationCommonConfiguration,
                              forMediationAdapter: "MPAirMonetizationAdapterConfiguration")
            config.setNetwork(airMonetizationBannerConfiguration,
                              forMediationAdapter: "MPAirMonetizationMopubBannerAdapter")
            config.setNetwork(airMonetizationInterstitialConfiguration,
                              forMediationAdapter: "MPAirMonetizationMoPubInterstitialAdapter")
            config.setNetwork(airMonetizationRewardedConfiguration,
                              forMediationAdapter: "MPAirMonetizationMoPubRewardedAdapter")
            config.additionalNetworks = [MPAirMonetizationAdapterConfiguration.self,
                                         MPAirMonetizationMopubBannerAdapter.self,
                                         MPAirMonetizationMoPubInterstitialAdapter.self,
                                         MPAirMonetizationMoPubRewardedAdapter.self]
            /**
             * Optional Mopub logs
             */
            config.loggingLevel = .debug
            
            MoPub.sharedInstance().initializeSdk(with: config)
        }
        
        return true
    }

    private func setupTrackingIDFA() {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case ATTrackingManager.AuthorizationStatus.authorized:
                    #if DEBUG
                    print("ATTrackingManager.AuthorizationStatus.authorized")
                    #endif
                case ATTrackingManager.AuthorizationStatus.denied:
                    #if DEBUG
                    print("ATTrackingManager.AuthorizationStatus.denied")
                    #endif
                case ATTrackingManager.AuthorizationStatus.restricted:
                    #if DEBUG
                    print("ATTrackingManager.AuthorizationStatus.restricted")
                    #endif
                case ATTrackingManager.AuthorizationStatus.notDetermined:
                    #if DEBUG
                    print("ATTrackingManager.AuthorizationStatus.notDetermined")
                    #endif
                @unknown default:
                    break
                }
            }
        } else {
            #if DEBUG
            print("Less then iOS 14.0")
            #endif
        }
    }
}
