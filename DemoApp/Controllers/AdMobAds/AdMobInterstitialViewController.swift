//
//  AdMobInterstitialViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 28.09.21.
//

import UIKit
import GoogleMobileAds

class AdMobInterstitialViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func createAndLoadInterstitial() {
        let adRequest = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AdMobAdUnits.kCustomEventInterstitialAdUnitID,
                               request: adRequest) { [weak self] ad, error in
            if let error = error {
                print("[AdMob Interstitial] Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    @IBAction func loadInterstitialButtonTapped(_ sender: ShadowButton) {
        createAndLoadInterstitial()
    }
    
    @IBAction func showInterstitialButtonTapped(_ sender: ShadowButton) {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
        } else {
            print("[AdMob Interstitial] Ad wasn't ready")
        }
    }
    
    //MARK: - GADFullScreenContentDelegate
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        #if DEBUG
        print("[AdMob Intestitial] GADFullScreenContentDelegate: \(#function). Error: \(error.localizedDescription)")
        #endif
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[AdMob Intestitial] GADFullScreenContentDelegate: \(#function)")
        #endif
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[AdMob Intestitial] GADFullScreenContentDelegate: \(#function)")
        #endif
    }
}
