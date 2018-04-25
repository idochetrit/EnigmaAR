//
//  ChallengeInfoViewController.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 24/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import UIKit
import Hero

class ChallengeInfoViewController: UIViewController {
  


  @IBOutlet weak var titleChallenge: UILabel!
  @IBOutlet weak var bigImage: UIImageView!
  @IBOutlet weak var lognText: UITextView!
  @IBOutlet weak var prizeDescrip: UILabel!
  @IBOutlet weak var prizeImg: UIImageView!
  
  var challengeInfo: ChallengeInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hero.isEnabled = true
    
    titleChallenge.text = challengeInfo.challengeName
    bigImage.image = challengeInfo.companyImage
    lognText.text = challengeInfo.longDescription
    prizeDescrip.text = challengeInfo.prizeDescription
    prizeImg.image = challengeInfo.prizeImage
    
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func back(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
