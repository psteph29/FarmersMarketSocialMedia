//
//  ShowBubble.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/8/23.
//

import Foundation
import UIKit

class BubbleManager {
    
      static func showBubble(over label: UILabel, in view: UIView) {
          let bubble = BubbleView()
          // Assuming a bubble size of 200x50; adjust as necessary
          let bubbleSize = CGSize(width: 200, height: 50)
          let spacing: CGFloat = 10  // Spacing between the bubble and the label

          var bubbleOrigin = CGPoint(
              x: label.frame.midX - bubbleSize.width / 2,
              y: label.frame.maxY + spacing
          )
          
          // Convert point to the view's coordinate space
          bubbleOrigin = label.superview!.convert(bubbleOrigin, to: view)
          
          // Check if the bubble will go off the top of the screen
          if bubbleOrigin.y < 0 {
              // Position bubble below the label if it goes off the top
              bubbleOrigin.y = label.frame.maxY + spacing
          }
          
          // Check if the bubble will go off the bottom of the screen
          if bubbleOrigin.y + bubbleSize.height > view.bounds.height {
              // Position bubble above the label if it goes off the bottom
              bubbleOrigin.y = label.frame.minY - spacing - bubbleSize.height
          }
          
          // Assign the frame to the bubble
          bubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
          view.addSubview(bubble)
          
          // Fade out and remove the bubble after 3 seconds
          UIView.animate(withDuration: 0.5, delay: 3, options: [], animations: {
              bubble.alpha = 0
          }) { _ in
              bubble.removeFromSuperview()
          }
      }
}
