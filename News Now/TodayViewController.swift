//
//  TodayViewController.swift
//  News Now
//
//  Created by TrianzDev on 31/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit
import NotificationCenter
import SafariServices

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var todayCollectionView: UICollectionView!
    
    var todayNewsItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.todayCollectionView?.reloadData()
            }
        }
    }
    
    var todaySource: String {
        guard let defaultSource = UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.string(forKey: "source") else {
            return "the-wall-street-journal"
        }
        return defaultSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayCollectionView?.register(UINib(nibName: "TodayImageCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "todayImageCell")

        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
    }

    // MARK: - Load data from network
    func loadNewsData(_ source: String) {
            NewsAPI.getNewsItems(source) { (newsItem, error) in
            guard error == nil, let news = newsItem else { return }
            self.todayNewsItems = news
        }
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        loadNewsData(todaySource)
        completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 440)
        }
    }
    
    // MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayNewsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayImageCell", for: indexPath) as? TodayImageCollectionViewCell
        todayCell?.todayNewsImageView.downloadedFromLink(todayNewsItems[indexPath.row].urlToImage)
        todayCell?.newsTitleLabel.text = todayNewsItems[indexPath.row].title
        todayCell?.publishedAtLabel.text = todayNewsItems[indexPath.row].publishedAt.dateFromTimestamp?.relativelyFormatted(short: true)
        return todayCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: todayCollectionView.bounds.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let appURL = URL(string: todayNewsItems[indexPath.row].url) {
        self.extensionContext?.open(appURL, completionHandler: nil)
        }
    }
}
