//
//  MoPubBannerViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 28.09.21.
//

import UIKit
import MoPubSDK

class MoPubBannerViewController: UIViewController {
    
    private var banner: MPAdView?
    private var unitId: String {
        return MoPubAdUnits.kMoPubBannerAdUnitID
    }
    
    let airMonetizationBannerConfiguration: [String: Any] = [
        "api_key": AppDelegate.airMonetizationAPIKEY,
        "app_id": AppDelegate.airMonetizationAPPID,
        "test_mode": AppDelegate.airMonetizationTestMode,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func loadBannerAd() {
        guard MoPub.sharedInstance().isSdkInitialized else { return }
        
        banner = MPAdView(adUnitId: unitId)
        banner?.frame = CGRect(x: 0,
                               y: 0,
                               width: kMPPresetMaxAdSizeMatchFrame.width,
                               height: kMPPresetMaxAdSizeMatchFrame.height)
        if let banner = banner {
            self.view.addSubview(banner)
        }
        
        banner?.localExtras = airMonetizationBannerConfiguration
        banner?.delegate = self
        banner?.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)
    }
    
    @IBAction func loadBannerButtonTapped(_ sender: ShadowButton) {
        DispatchQueue.main.async {
            self.loadBannerAd()
        }
        
    }
    
    
}

extension MoPubBannerViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        #if DEBUG
        print("[MoPub Banner] MPAdViewDelegate: \(#function)")
        #endif
        return self
    }
    
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        #if DEBUG
        print("[MoPub Banner] MPAdViewDelegate: \(#function)")
        #endif
    }
    
    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        #if DEBUG
        print("[MoPub Banner] MPAdViewDelegate: \(#function). Error: \(error.localizedDescription)")
        #endif
    }
    
    func willPresentModalView(forAd view: MPAdView!) {
        #if DEBUG
        print("[MoPub Banner] MPAdViewDelegate: \(#function)")
        #endif
    }
    
    func didDismissModalView(forAd view: MPAdView!) {
        #if DEBUG
        print("[MoPub Banner] MPAdViewDelegate: \(#function)")
        #endif
    }
    
}
