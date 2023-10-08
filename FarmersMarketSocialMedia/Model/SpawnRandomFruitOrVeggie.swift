//
//  SpawnRandomFruitOrVeggie.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/8/23.
//

import Foundation
import UIKit

func spawnFruitOrVeggie(in view: UIView, segment: Int, totalSegments: Int, itemIndex: Int, shuffledImages: [String]) -> UIImageView {
    // Retrieve the image name based on the item index from the shuffled images array
    // This ensures each image within a segment is unique
    let randomImageName = shuffledImages[itemIndex]

    // Initialize an image view with the selected image
    let imageView = UIImageView(image: UIImage(named: randomImageName))
    
    // Determine the desired width for the image based on a percentage of the view's width
    let desiredWidth = view.bounds.width * 0.2
    // Calculate the scale factor based on the desired width and the original image width
    let scaleFactor = desiredWidth / imageView.frame.size.width
    // Adjust the height while maintaining the image's original aspect ratio
    let newHeight = imageView.frame.size.height * scaleFactor
    
    // Update the image view's frame size to the newly computed dimensions
    imageView.frame.size = CGSize(width: desiredWidth, height: newHeight)

    // Compute the width of each segment by dividing the total view width by the number of segments
    let segmentWidth = view.bounds.width / CGFloat(totalSegments)
    // Calculate the starting and ending X positions for the current segment
    let startX = segmentWidth * CGFloat(segment)
    let endX = startX + segmentWidth
    
    // Randomly determine an X position within the bounds of the current segment, adjusting to ensure the image view is entirely within the segment
    let randomXPosition = CGFloat.random(in: startX..<endX) - imageView.frame.size.width/2
    // Position the image view's center. Its initial Y position is set just above the top of the view to give the appearance of falling
    imageView.center = CGPoint(x: randomXPosition, y: -imageView.bounds.height)
    
    // Return the prepared image view
    return imageView
}




