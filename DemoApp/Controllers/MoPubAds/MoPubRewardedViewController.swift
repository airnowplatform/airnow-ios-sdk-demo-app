//
//  MoPubRewardedViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 28.09.21.
//

import UIKit
import MoPubSDK

class MoPubRewardedViewController: UIViewController {
    
    private var unitId: String {
        return MoPubAdUnits.kMoPubRewardedAdUnitID
    }
    
    let airMonetizationRewardedConfiguration: [String: Any] = [
        "api_key": AppDelegate.airMonetizationAPIKEY,
        "app_id": AppDelegate.airMonetizationAPPID,
        "test_mode": AppDelegate.airMonetizationTestMode,
        "placement_name": AppDelegate.airMonetizationRewardedPlacementName,
        "user_id": AppDelegate.airMonetizationTestRewardedUserID
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func loadRewardedAd() {
        guard MoPub.sharedInstance().isSdkInitialized else { return }
        MPRewardedAds.setDelegate(self, forAdUnitId: unitId)

        MPRewardedAds.loadRewardedAd(withAdUnitID: unitId,
                                     keywords: nil,
                                     userDataKeywords: nil,
                                     customerId: nil,
                                     mediationSettings: nil,
                                     localExtras: airMonetizationRewardedConfiguration)
    }
    
    private func showRewardedAd() {
        guard MoPub.sharedInstance().isSdkInitialized else { return } 
        MPRewardedAds.presentRewardedAd(forAdUnitID: unitId,
                                        from: self,
                                        with: nil)
    }
    
    @IBAction func loadRewardedButtonTapped(_ sender: ShadowButton) {
        DispatchQueue.main.async {
            self.loadRewardedAd()
        }
        
    }
    
    @IBAction func showRewardedButtonTapped(_ sender: ShadowButton) {
        DispatchQueue.main.async {
            self.showRewardedAd()
        }
    }
    
}

extension MoPubRewardedViewController: MPRewardedAdsDelegate {
    //MARK: - MPRewardedAdsDelegate
    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        #if DEBUG
        print("[MoPub Rewarded] MPRewardedAdsDelegate: \(#function)")
        #endif
    }
    
    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        #if DEBUG
        print("[MoPub Rewarded] MPRewardedAdsDelegate: \(#function). Error: \(error.localizedDescription)")
        #endif
    }
    
    func rewardedAdDidPresent(forAdUnitID adUnitID: String!) {
        #if DEBUG
        print("[MoPub Rewarded] MPRewardedAdsDelegate: \(#function)")
        #endif
    }
    
    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        #if DEBUG
        print("[MoPub Rewarded] MPRewardedAdsDelegate: \(#function)")
        #endif
        loadRewardedAd()
    }
    
    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        #if DEBUG
        print("[MoPub Rewarded] MPRewardedAdsDelegate: \(#function). Rewarded Ad Did Reward With Amount: \(String(describing: reward.amount)) \(String(describing: reward.currencyType))")
        #endif
    }
    
}
