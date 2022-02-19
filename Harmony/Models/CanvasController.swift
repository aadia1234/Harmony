//
//  DrawingCanvas+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 2/18/22.
//
//

import Foundation
import PencilKit

public class CanvasController: NSObject, PKCanvasViewDelegate, ObservableObject {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;

        if scrollOffset + scrollViewHeight >= scrollContentSizeHeight + 50 {
            scrollView.contentSize.height += 200
        }
    }
    
}
