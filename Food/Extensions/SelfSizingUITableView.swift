//
//  SelfSizingUITableView.swift
//  Food
//
//  Created by Mathias da Rosa on 28/08/25.
//

import UIKit

class SelfSizingUITableView: UITableView {
    override var intrinsicContentSize: CGSize {
        let rows = self.dataSource?.tableView(self, numberOfRowsInSection: 0) ?? 0
        let newHeight = CGFloat(44 * ([rows, 3].min() ?? 0))
        return CGSize(width: CGFloat.infinity, height: newHeight)
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
}
