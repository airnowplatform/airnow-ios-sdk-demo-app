//
//  MoPubInterstitialViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 28.09.21.
//

import UIKit
import MoPubSDK

class MoPubInterstitialViewController: UIViewController {
    
    private var interstitial: MPInterstitialAdController?
    private var unitId: String {
        return MoPubAdUnits.kMoPubInterstitialAdUnitID
    }
    
    let airMonetizationInterstitialConfiguration: [String: Any] = [
        "api_key": AppDelegate.airMonetizationAPIKEY,
        "app_id": AppDelegate.airMonetizationAPPID,
        "test_mode": AppDelegate.airMonetizationTestMode,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func loadInterstitialAd() {
        guard MoPub.sharedInstance().isSdkInitialized else { return }
        
        interstitial = MPInterstitialAdController(forAdUnitId: unitId)
        interstitial?.localExtras = airMonetizationInterstitialConfiguration
        interstitial?.delegate = self
        interstitial?.loadAd()
    }
    
    private func showInterstitialAd() {
        guard MoPub.sharedInstance().isSdkInitialized else { return } 
        if let interstitial = interstitial, interstitial.ready {
            interstitial.show(from: self)
        }
    }
    
    @IBAction func loadInterstitialButtonTapped(_ sender: ShadowButton) {
        DispatchQueue.main.async {
            self.loadInterstitialAd()
        }
        
    }
    
    @IBAction func showInterstitialButtonTapped(_ sender: ShadowButton) {
        DispatchQueue.main.async {
            self.showInterstitialAd()
        }
    }
    
}

extension MoPubInterstitialViewController: MPInterstitialAdControllerDelegate {
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        #if DEBUG
        print("[MoPub Interstitial] MPInterstitialAdControllerDelegate: \(#function)")
        #endif
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        #if DEBUG
        print("[MoPub Interstitial] MPInterstitialAdControllerDelegate: \(#function). Error: \(error.localizedDescription)")
        #endif
    }
    
    func interstitialWillPresent(_ interstitial: MPInterstitialAdController!) {
        #if DEBUG
        print("[MoPub Interstitial] MPInterstitialAdControllerDelegate: \(#function)")
        #endif
    }
    
    func interstitialDidPresent(_ interstitial: MPInterstitialAdController!) {
        #if DEBUG
        print("[MoPub Interstitial] MPInterstitialAdControllerDelegate: \(#function)")
        #endif
    }
    
    func interstitialWillDismiss(_ interstitial: MPInterstitialAdController!) {
        #if DEBUG
        print("[MoPub Interstitial] MPInterstitialAdControllerDelegate: \(#function)")
        #endif
    }
    
    func interstitialDidDismiss(_ interstitial: MPInterstitialAdController!) {
        #if DEBUG
        print("[MoPub Interstitial] MPInterstitialAdControllerDelegate: \(#function)")
        #endif
    }
    
}
