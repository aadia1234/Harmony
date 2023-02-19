//
//  FolderViewController.swift
//  Harmony
//
//  Created by Aadi Anand on 1/29/23.
//

import UIKit
import SwiftUI

class FolderViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    var updateView: UpdateView = UpdateView()
    
    init?(_ updateView: UpdateView, coder: NSCoder) {
        self.updateView = updateView
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: updateView.folderNavigationView)
        addChild(childView)
        childView.view.frame = containerView.bounds
        containerView.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
