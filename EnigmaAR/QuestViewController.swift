//
//  QuestViewController.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 07/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController , FSPagerViewDataSource, FSPagerViewDelegate {
  
  
  let imageArray = [#imageLiteral(resourceName: "icon_audi"),#imageLiteral(resourceName: "icon_asana"),#imageLiteral(resourceName: "icon_chery"),#imageLiteral(resourceName: "icon_intel"),#imageLiteral(resourceName: "icon_google"),#imageLiteral(resourceName: "icon_canada")]
  let imagePrizeArray = [#imageLiteral(resourceName: "20precent"),#imageLiteral(resourceName: "20precent"),#imageLiteral(resourceName: "20precent"),#imageLiteral(resourceName: "20precent"),#imageLiteral(resourceName: "20precent"),#imageLiteral(resourceName: "20precent")]
  
  let imageLabel = ["Audi","Arana","Chery","Intel","Google","Canada"]
  let descriptionArray = ["bla bla bla bla lba lba ldvdkjsndjks asdnaskd " , "description......" , "description......", "description......" , "description......" , "description......" ]
  //let prizeArray = ["You Won 20% OFF","2","3" ,"4","5","6"]
  
  //Hero library (view animation)
  
  @IBOutlet weak var pagerView: FSPagerView!{
    didSet{
      self.pagerView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
//      self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
      self.pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
      self.pagerView.itemSize = CGSize(width: 250, height: 250)
      pagerView.isInfinite = true
      
    }
  }
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return imageArray.count
  }
  
  public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! CollectionViewCell
    
    //cell design
    cell.layer.backgroundColor = UIColor(red: 0, green: 249, blue: 255, alpha: 1).cgColor
    
    
    
    cell.descrip.text = descriptionArray[index]
    cell.bigImage.image = imageArray[index]
    cell.prizeImage.image = imagePrizeArray[index]
    cell.title.text = imageLabel[index]
    
    return cell
  }
  
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    let viewController = ChallengeInfoViewController()
//    viewController.
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
