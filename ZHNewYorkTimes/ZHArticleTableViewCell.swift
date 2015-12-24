//
//  ZHArticleTableViewCell.swift
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!

    var article: ZHNYTArticle? = nil {
        didSet {
            headlineLabel.text = article?.headline
            if let snippet = article?.snippet {
                snippetLabel.text = snippet
            } else {
                snippetLabel.text = ""
            }
            dateLabel.text = article?.publishDate.stringFromDateShort()
            
            if let multimedia = article?.multimedia {
                self.mediaImageView.sd_setImageWithURL(multimedia)
            } else {
                self.mediaImageView.sd_setImageWithURL(nil)
            }
        }
    }
}
