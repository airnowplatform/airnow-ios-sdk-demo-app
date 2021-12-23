//
//  ISAirnowCustomRewardedVideo.swift
//  AirnowMediationWithIS
//
//  Created by Gusakovsky, Sergey on 15.12.21.
//

import Foundation
import ObjectiveC.runtime
import AirMonetizationSDK

@objc(ISAirnowCustomRewardedVideo)
public class ISAirnowCustomRewardedVideo: ISBaseAdAdapter, AirMonetizationRewardedAdDelegate {
        
    @objc private var rewardedlAd: AirMotetizationAd?
    
    @objc private weak var adapterDelegate: ISAdapterAdDelegate? = nil
    
    @objc public override func loadAd(with adData: ISAdData, delegate: ISAdapterAdDelegate) {
        guard
            let apiKey = adData.configuration[ISAdapterConstants.ExtraKey.APIKey] as? String,
            let appId = adData.configuration [ISAdapterConstants.ExtraKey.appID] as? String,
            let placementName = adData.configuration[ISAdapterConstants.ExtraKey.placementName] as? String
        else
        {
            delegate.adDidFailToLoadWith(
                .internal,
                errorCode: Int32(ISAdapterErrors.missingParams.rawValue),
                errorMessage: ISAirMonetizationAdapterError.noApiKeyOrAppId.description
            )
            return
        }
        
        //MARK: - TODO
        AirMonetization.shared.setAPIKey(key: apiKey, appID: appId)
        AirMonetization.shared.setTestMode(testMode: false)
        
        self.adapterDelegate = delegate
        
        DispatchQueue.main.async {
            if self.rewardedlAd != nil {
                self.rewardedlAd?.removeFromViewController()
                self.rewardedlAd?.stop()
                self.rewardedlAd?.dismiss()
                self.rewardedlAd = nil
            }
            
            self.rewardedlAd = AirMonetizationRewarded.rewarded(placementName: placementName)

            self.rewardedlAd?.setSource(source: "IronSource")
            self.rewardedlAd?.rewardDelegate = self
            self.rewardedlAd?.load()
        }
    }
    
    @objc public override func isAdAvailable(with adData: ISAdData) -> Bool {
        return rewardedlAd?.isCanOpen ?? false
    }
    
    @objc public override func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISAdapterAdDelegate) {
        if let rewardedlAd = rewardedlAd, rewardedlAd.isCanOpen {
            rewardedlAd.show()
        }
    }

    //MARK: - AirMonetizationRewardedAdDelegate Protocol
    public func rewardedAdDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }
    
    public func rewardedAdDidFinishLoad(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). RewardName: \(rewardName). RewardValue: \(rewardValue)")
        #endif
        
        adapterDelegate?.adDidLoad()
    }
    
    public func rewardedAdDidReceiveReward(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). RewardName: \(rewardName). RewardValue: \(rewardValue)")
        #endif
    }
    
    public func rewardedAdDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        
        adapterDelegate?.adDidOpen()
    }
    
    public func rewardedAdDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        
        adapterDelegate?.adDidClick()
    }
    
    public func rewardedAdDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        
        adapterDelegate?.adDidClose()
    }
    
    public func rewardedAdDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }
    
    public func rewardedAdDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }
    
    public func rewardedAdDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). Error: \(error)")
        #endif
        
        adapterDelegate?.adDidFailToLoadWith(
            .internal,
            errorCode: Int32(ISAdapterErrors.internal.rawValue),
            errorMessage: ISAirMonetizationAdapterError.interstitialNotAvailable.description
        )
    }
    
    public func rewardedAdDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). Error: \(error)")
        #endif
        
        adapterDelegate?.adDidFailToShowWithErrorCode(
            Int32(ISAdapterErrors.missingParams.rawValue),
            errorMessage: ISAirMonetizationAdapterError.interstitialNotAvailable.description
        )
    }

}
