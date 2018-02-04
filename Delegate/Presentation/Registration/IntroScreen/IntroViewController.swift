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

class IntroViewController: UIViewController {
    
    enum SegueIdentifier {
        static let toSelectRole = "SegueToSelectRole"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: FXPageControl!
    
    fileprivate let cellReuseIdentifier = "PageCell"
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let introModel: [(image: UIImage, title: String)] =
    [
        (#imageLiteral(resourceName: "forecast"), "Analyze..."),
        (#imageLiteral(resourceName: "plan"), "Plan..."),
        (#imageLiteral(resourceName: "profit"), "Profit!"),
        (UIImage(), "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleIntroContent()
        pageControl.currentPage = 0
    }
    
    fileprivate func handleIntroContent()
    {
        Observable<[(UIImage, String)]>.just(introModel).bind(to: collectionView.rx.items(cellIdentifier: cellReuseIdentifier)) { index, model, cell in
            guard let cell = cell as? IntroCell else { return }
            cell.imageView.image = model.0
            cell.titleLabel.text = model.1
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
        
        if pageNumber == introModel.count - 1 {
            pageControl.isHidden = true
            performSegue(withIdentifier: SegueIdentifier.toSelectRole, sender: nil)
        }
    }
}

extension IntroViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height)
    }
}
