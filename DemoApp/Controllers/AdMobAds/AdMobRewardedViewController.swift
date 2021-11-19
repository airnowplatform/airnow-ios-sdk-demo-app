//
//  AdMobRewardedViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 28.09.21.
//

import UIKit
import GoogleMobileAds

class AdMobRewardedViewController: UIViewController, GADFullScreenContentDelegate  {

    private var rewardedAd: GADRewardedAd?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func createAndLoadRewarded() {
        let adRequest = GADRequest()
        let customExtras = GADAdapterAirMonetizationRewardedCustomExtras()
        customExtras.setRewardedUserId(userID: AppDelegate.airMonetizationTestRewardedUserID)
        adRequest.register(customExtras)
        
        
        GADRewardedAd.load(withAdUnitID: AdMobAdUnits.kCustomEventRewardedAdUnitID,
                               request: adRequest) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    @IBAction func loadRewardedButtonTapped(_ sender: ShadowButton) {
        createAndLoadRewarded()
    }
    
    @IBAction func showRewardedButtonTapped(_ sender: ShadowButton) {
        if let rewardedAd = rewardedAd {
            rewardedAd.present(fromRootViewController: self) {
                if let reward = self.rewardedAd?.adReward {
                    print("[AdMob Rewarded] Reward the user: Reward type: \(reward.type), Reward amount: \(reward.amount)")
                }
            }
        } else {
            print("[AdMob Rewarded] Ad wasn't ready")
        }
    }
    
    //MARK: - GADFullScreenContentDelegate
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        #if DEBUG
        print("[AdMob Rewarded] GADFullScreenContentDelegate: \(#function). Error: \(error.localizedDescription)")
        #endif
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[AdMob Rewarded] GADFullScreenContentDelegate: \(#function)")
        #endif
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[AdMob Rewarded] GADFullScreenContentDelegate: \(#function)")
        #endif
    }
}
