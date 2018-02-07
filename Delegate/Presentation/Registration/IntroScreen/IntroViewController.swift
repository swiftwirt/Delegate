//
//  IntroViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FXPageControl

class IntroViewController: DelegateAbstractViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: FXPageControl!
    
    fileprivate let cellReuseIdentifier = "PageCell"
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let introModel: [(UIImage, String, String, String)] =
    [
        (image: #imageLiteral(resourceName: "forecast"), title: "Analyze...", content: "Without big data analytics, companies are blind and deaf, wandering out onto the Web like deer on a freeway.", author:  "...Geoffrey Moore"),
        (image: #imageLiteral(resourceName: "plan"), title: "Manage...", content: "In preparing for battle I have always found that plans are useless, but planning is indispensable.", author:  "...Dwight D. Eisenhower"),
        (image: #imageLiteral(resourceName: "profit"), title: "Profit!", content: "Money is multiplied in practical value depending on the number of W's you control in your life: what you do, when you do it, where you do it, and with whom you do it.", author:  "...Timothy Ferriss"),
        (UIImage(), "", "", "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleIntroContent()
        pageControl.currentPage = 0
    }
    
    fileprivate func handleIntroContent()
    {
        Observable<[(image: UIImage, title: String,  content: String, author: String)]>.just(introModel).bind(to: collectionView.rx.items(cellIdentifier: cellReuseIdentifier)) { index, model, cell in
            guard let cell = cell as? IntroCell else { return }
            cell.imageView.image = model.image
            cell.titleLabel.text = model.title
            cell.contentLabel.text = model.content
            cell.authorLabel.text = model.author
            }
            .disposed(by: disposeBag)
    }

}

extension IntroViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        guard let pageNumber = visibleIndexPath?.item else { return }
        
        pageControl.currentPage = pageNumber
        pageControl.selectedDotColor = Color.getPageControlDotColor(pageNumber: pageNumber)
        
        if pageNumber == introModel.count - 1 {
            pageControl.isHidden = true
            ApplicationRouter.showSelectRoleScreen()
        }
    }
}

extension IntroViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height)
    }
}
