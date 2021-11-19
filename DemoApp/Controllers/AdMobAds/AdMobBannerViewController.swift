//
//  AdMobBannerViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 28.09.21.
//

import UIKit
import GoogleMobileAds
import AirMonetizationSDK

class AdMobBannerViewController: UIViewController {
    
    @IBOutlet weak var adContainerView: UIView!
    
    private lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        adBannerView.adUnitID = AdMobAdUnits.kCustomEventBannerAdUnitID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loadAdMobBannerButtonTapped(_ sender: ShadowButton) {
        let adRequest = GADRequest()
        adBannerView.load(adRequest)
    }
    
    private func addBannerViewToContainerView(containerView: UIView, bannerView: GADBannerView) {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bannerView)
        bannerView.alpha = 0
        containerView.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        
        UIView.animate(withDuration: 1.0) {
            bannerView.alpha = 1
        }
    }
}

extension AdMobBannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        #if DEBUG
        print("[AdMob Banner] GADBannerViewDelegate: \(#function)")
        #endif
        self.addBannerViewToContainerView(containerView: self.adContainerView, bannerView: bannerView)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        #if DEBUG
        print("[AdMob Banner] GADBannerViewDelegate: \(#function), error: \(error.localizedDescription)")
        #endif
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        #if DEBUG
        print("[AdMob Banner] GADBannerViewDelegate: \(#function)")
        #endif
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        #if DEBUG
        print("[AdMob Banner] GADBannerViewDelegate: \(#function)")
        #endif
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        #if DEBUG
        print("[AdMob Banner] GADBannerViewDelegate: \(#function)")
        #endif
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        #if DEBUG
        print("[AdMob Banner] GADBannerViewDelegate: \(#function)")
        #endif
    }
}
