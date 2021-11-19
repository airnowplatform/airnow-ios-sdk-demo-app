//
//  GADMediationAdapterAirMonetization.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 23.09.21.
//

import Foundation
import GoogleMobileAds
import AirMonetizationSDK

@objc public class GADAdapterAirMonetizationRewardedCustomExtras: NSObject, GADAdNetworkExtras {
    @objc private var userId: String? = nil
    
    @objc public func setRewardedUserId(userID: String) {
        self.userId = userID
    }
    
    @objc public func getRewardedUserId() -> String? {
        return self.userId
    }
}

@objc public class GADAdapterAirMonetizationRewarded: NSObject, GADMediationAdapter, GADMediationRewardedAd, AirMonetizationRewardedAdDelegate {
    
    // MARK: - Members
    private var currentRewardedAd: AirMotetizationAd?
    
    //MARK: - Delegate
    @objc public weak var adEventDelegate: GADMediationRewardedAdEventDelegate?
    
    @objc required public override init() {
        super.init()
    }
    
    public static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return GADAdapterAirMonetizationRewardedCustomExtras.self
    }
    
    public static func adSDKVersion() -> GADVersionNumber {
        let sdkVersion = AirMonetizationAdapterSettings.sdkVersion
        let versionComponents = sdkVersion.components(separatedBy: ".")
        if versionComponents.count == 3,
           let majorVersion = Int(versionComponents[0]),
           let minorVersion = Int(versionComponents[1]),
           let patchVersion = Int(versionComponents[1]) {
            return GADVersionNumber(majorVersion: majorVersion,
                                    minorVersion: minorVersion,
                                    patchVersion: patchVersion)
        }
        return GADVersionNumber()
    }
    
    public static func adapterVersion() -> GADVersionNumber {
        let adapterVersion = GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationVersion
        let versionComponents = adapterVersion.components(separatedBy: ".")
        if versionComponents.count == 3,
           let majorVersion = Int(versionComponents[0]),
           let minorVersion = Int(versionComponents[1]),
           let patchVersion = Int(versionComponents[2]) {
            return GADVersionNumber(majorVersion: majorVersion,
                                    minorVersion: minorVersion,
                                    patchVersion: patchVersion)
        }
        return GADVersionNumber()
    }
    
    public static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        let error = NSError.from(code: .SDKCredentialsNotFound,
                                 description: "AirMonetization SDK integration error.",
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)

        guard
            let rewardCredential = configuration.credentials.first(where: { $0.format == .rewarded})
        else {
            completionHandler(error)
            return
        }

        guard
            let jsonParams = rewardCredential.settings["parameter"] as? String,
            let data = jsonParams.data(using: .utf8),
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let _ = try? AirMonetizationAdapterSettings.instance(fromAdmobParameters: jsonDictionary)
        else {
            completionHandler(error)
            return
        }
        
        completionHandler(nil)
    }
    
    public func loadRewardedAd(for adConfiguration: GADMediationRewardedAdConfiguration, completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
        
        if currentRewardedAd != nil {
            currentRewardedAd?.removeFromViewController()
            currentRewardedAd?.stop()
            currentRewardedAd?.dismiss()
            currentRewardedAd = nil
        }
        
        guard let jsonParams = adConfiguration.credentials.settings["parameter"] as? String,
              let data = jsonParams.data(using: .utf8),
              let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let airMonetizationSettings = try? AirMonetizationAdapterSettings.instance(fromAdmobParameters: jsonDictionary) else {
            let error = NSError.from(code: .SDKCredentialsNotFound,
                                     description: "AirMonetization SDK integration error.",
                                     domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
            _ = completionHandler(nil, error)
            return
        }
        
        guard let placementName = airMonetizationSettings.placementName else {
            let error = NSError.from(code: .loadingFailure,
                                     description: "Placement Name for Rewarded Ad was not found.",
                                     domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
            _ = completionHandler(nil, error)
            return
        }
        
        currentRewardedAd = AirMonetizationRewarded.rewarded(placementName: placementName)
        currentRewardedAd?.setSource(source: "AdMob")
        if let customExtras = adConfiguration.extras as? GADAdapterAirMonetizationRewardedCustomExtras, let rewardedUserId = customExtras.getRewardedUserId() {
            currentRewardedAd?.setUserId(userId: rewardedUserId)
        }
        currentRewardedAd?.rewardDelegate = self
        currentRewardedAd?.load()
        adEventDelegate = completionHandler(self, nil)
    }

    //MARK: - GADMediationRewardedAd Protocol
    public func present(from viewController: UIViewController) {
        if let rewardedAd = currentRewardedAd, rewardedAd.isCanOpen {
            rewardedAd.show()
            adEventDelegate?.reportImpression()
            adEventDelegate?.willPresentFullScreenView()
        }
    }
    
    //MARK: - AirMonetizationRewardedAdDelegate Protocol
    public func rewardedAdDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    public func rewardedAdDidFinishLoad(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). RewardName: \(rewardName). RewardValue: \(rewardValue)")
        #endif
    }

    public func rewardedAdDidReceiveReward(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). RewardName: \(rewardName). RewardValue: \(rewardValue)")
        #endif
        let reward = GADAdReward(rewardType: rewardName, rewardAmount: NSDecimalNumber(decimal: Decimal(rewardValue)))
        adEventDelegate?.didRewardUser(with: reward)
    }

    public func rewardedAdDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        adEventDelegate?.reportImpression()
        adEventDelegate?.didStartVideo()
    }

    public func rewardedAdDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        adEventDelegate?.willPresentFullScreenView()
        adEventDelegate?.reportClick()
    }

    public func rewardedAdDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        adEventDelegate?.didEndVideo()
        adEventDelegate?.didDismissFullScreenView()
    }

    public func rewardedAdDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    public func rewardedAdDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        adEventDelegate?.didEndVideo()
        adEventDelegate?.didDismissFullScreenView()
    }

    public func rewardedAdDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = NSError.from(code: .loadingFailure,
                                 description: error,
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
        adEventDelegate?.didFailToPresentWithError(error)
    }
    
    public func rewardedAdDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = NSError.from(code: .loadingFailure,
                                 description: error,
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
        adEventDelegate?.didFailToPresentWithError(error)
    }
}
