//
//  ViewController.swift
//  CycleScrollView
//
//  Created by huobanbengkui on 2018/6/28.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    private let itemWidth: CGFloat = 100
    private let itemHight: CGFloat = 200
    private let itemSpace: CGFloat = 20
    private var collectionView: UICollectionView!
    private var oldPoint: CGFloat!
    private var dragDirection: Int!
    private let messageArray = ["1", "2", "3", "4", "5", "6"]
    private var timer: Timer!
    private let timerInterval = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.blue
        view.addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UIView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(UIView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView")
        collectionView.frame = CGRect(x: 0, y: 100, width: 320, height: 320)
        
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(clickButton), userInfo: nil, repeats: true);
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes);
        timer.pauseTimer()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.scrollToItem(at: IndexPath(row: messageArray.count, section: 0), at: .centeredHorizontally, animated: false)
        oldPoint = collectionView.contentOffset.x
        
        timer.resumeTimerAfterTimeInterval(interval: timerInterval)
    }
    
    @objc func clickButton(){
        var index = Int((collectionView.contentOffset.x + itemWidth + itemSpace) / (itemWidth + itemSpace))
        index += 1
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageArray.count * 2;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.red;
        }else{
            cell.backgroundColor = UIColor.yellow;
        }
        cell.nameLabel.text = messageArray[indexPath.row % messageArray.count]
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {
    
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: itemWidth, height: itemHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: itemSpace, height: itemHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: itemSpace, height: itemHight)
    }
}
extension ViewController: UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        oldPoint = scrollView.contentOffset.x
        timer.pauseTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 如果向右滑或者滑动距离大于item的一半，则像又移动一个item+space的距离，反之向左
        let currentPoint = scrollView.contentOffset.x
        let moveWidth = currentPoint - oldPoint
        let shouldPage = moveWidth / (itemWidth / 2)
        if velocity.x > 0 || shouldPage > 0{
            dragDirection = 1
        }else if velocity.x < 0 || shouldPage < 0{
            dragDirection = -1
        }else{
            dragDirection = 0
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // 松开手指滑动开始减速的时候，设置滑动动画
        let currentIndex = Int((oldPoint + itemWidth + itemSpace) / (itemWidth + itemSpace)) + dragDirection
        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int((collectionView.contentOffset.x + itemWidth + itemSpace) / (itemWidth + itemSpace))
        if index == 1{
            collectionView.scrollToItem(at: IndexPath(row: messageArray.count + 1, section: 0), at: .centeredHorizontally, animated: false)
        }else if index == messageArray.count * 2 - 2{
            collectionView.scrollToItem(at: IndexPath(row: messageArray.count - 2, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.resumeTimerAfterTimeInterval(interval: timerInterval)
    }
}

