//
//  DirectRewardedViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 27.09.21.
//

import UIKit
import AirMonetizationSDK

class DirectRewardedViewController: UIViewController {
    
    //MARK: - Properties
    private var rewarded: AirMotetizationAd? = nil
        
    private var rewardName: String = ""
    private var rewardValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard rewarded != nil else { return }
        rewarded?.uninstallPreviousAd()
        rewarded = nil
    }
    
    @IBAction func loadAdAction(_ sender: UIButton) {
        guard rewarded != nil else { return }
        rewarded?.load()
    }
    
    @IBAction func loadRewardedAdAction(_ sender: UIButton) {
        if rewarded != nil {
            rewarded?.uninstallPreviousAd()
            rewarded = nil
        }
        rewarded = AirMonetizationRewarded.rewarded(placementName: AppDelegate.airMonetizationRewardedPlacementName)
        rewarded?.setUserId(userId: AppDelegate.airMonetizationTestRewardedUserID)
        
        rewarded?.rewardDelegate = self
        rewarded?.load()
    }
    
    @IBAction func showRewardedAd(_ sender: UIButton) {
        if let rewarded = rewarded, rewarded.isCanOpen {
            let message = "You will get \(rewardValue) \(rewardName) after watching the video"
            self.presentMessageDialog(title: "Attention",
                                      message: message,
                                      actionTitle: "OK",
                                      action: {
                                        rewarded.show()
                                      },
                                      cancelTitle: "Cancel",
                                      cancelAction: nil)
        }
    }
    
}

extension DirectRewardedViewController: AirMonetizationRewardedAdDelegate {
    //MARK: - AirMonetizationRewardedAdDelegate
    func rewardedAdDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }


    func rewardedAdDidFinishLoad(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function), rewardedName: \(rewardName), rewardedValue: \(rewardValue)")
        #endif
        self.rewardName = rewardName
        self.rewardValue = rewardValue
    }

    func rewardedAdDidReceiveReward(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function), rewardedName: \(rewardName), rewardedValue: \(rewardValue)")
        #endif
    }

    func rewardedAdDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    func rewardedAdDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    func rewardedAdDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    func rewardedAdDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    func rewardedAdDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }

    func rewardedAdDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function), error: \(error)")
        #endif
    }
    
    func rewardedAdDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization Direct Rewarded] AirMonetizationRewardedAdDelegate: \(#function), error: \(error)")
        #endif
    }
    
}
