//
//  CardsViewController.swift
//  Tinder
//
//  Created by Gerard Recinto on 4/26/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
  var cardInitialCenter: CGPoint!

  @IBOutlet weak var trayView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cardInitialCenter = trayView.center

        // Do any additional setup after loading the view.
    }


  @IBAction func onTap(_ sender: Any) {
  performSegue(withIdentifier: "passSegue", sender: nil)
  }

  @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
    let translation = (sender).translation(in: view)
    if (sender).state == .changed {
      let rotate = CGAffineTransform(rotationAngle: translation.x/180)
      sender.view?.transform = rotate

      sender.view?.center = CGPoint(x: self.cardInitialCenter.x + translation.x, y: self.cardInitialCenter.y)


    } else if sender.state == .ended {
      if(translation.x > 80){
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          guard let self = self else { return }
          let destination = CGPoint(x: 1000, y: self.cardInitialCenter.y)
          sender.view?.center = destination
        })

      } else if (translation.x < -80){
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          guard let self = self else { return }
          let destination = CGPoint(x: -1000, y: self.cardInitialCenter.y)
          sender.view?.center = destination
        })
      } else {
        sender.view?.center = self.cardInitialCenter
        sender.view?.transform = .identity
      }

    }
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
