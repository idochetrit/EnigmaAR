//
//  QuestViewController.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 07/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import UIKit
import FSPagerView
import Hero

class QuestViewController: UIViewController , FSPagerViewDataSource, FSPagerViewDelegate {

  
  @IBOutlet weak var pagerView: FSPagerView!{
    didSet{
      self.pagerView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
      self.pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
      self.pagerView.itemSize = CGSize(width: 250, height: 250)
      pagerView.isInfinite = true
      
    }
  }
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return infos.count
  }
  
  public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! CollectionViewCell
    
    //cell design
    cell.layer.backgroundColor = UIColor(red: 0, green: 249, blue: 255, alpha: 1).cgColor
    
    
    let info = infos[index]
    cell.title.text = info.challengeName
    cell.bigImage.image = info.companyImage
    cell.descrip.text = info.prizeDescription
    cell.prizeImage.image = info.prizeImage
    
    
    return cell
  }
  
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: "challengeInfo") as! ChallengeInfoViewController

    viewController.hero.modalAnimationType = .zoom
    
    viewController.challengeInfo = infos[index]
    
    self.present(viewController, animated: true, completion: nil)


  }
  
  var infos: [ChallengeInfo] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    infos = [ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_audi"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF"),
           ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_audi"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF"),
           ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_google"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF"),
           ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_canada"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF"),
           ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_intel"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF"),
           ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_asana"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF"),
           ChallengeInfo(companyImage: #imageLiteral(resourceName: "icon_canada"), challengeName: "Audi", shortDescription: "A German car manufacturer", prizeImage: #imageLiteral(resourceName: "20precent"), longDescription: "Audiis a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.", prizeDescription: "Get 20% OFF")
    ]
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
struct ChallengeInfo {
  var companyImage: UIImage
  var challengeName: String
  var shortDescription: String
  var prizeImage: UIImage
  var longDescription: String
  var prizeDescription: String
}
