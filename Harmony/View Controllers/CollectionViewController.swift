//
//  CollectionViewController.swift
//  Harmony
//
//  Created by Aadi Anand on 1/30/23.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var updateView: UpdateView = UpdateView()
//    weak var delegate: CollectionViewDelegate?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Folder>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Folder>
    var dataSource: DataSource!

    
    init?(_ updateView: UpdateView, coder: NSCoder) {
        self.updateView = updateView
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.collectionViewLayout = listLayout()
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Folder> { cell, indexPath, item in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            contentConfiguration.image = UIImage(systemName: "folder")
            let options = UICellAccessory.OutlineDisclosureOptions(style: .cell)
            let disclosureAccessory = UICellAccessory.outlineDisclosure(options: options)
            if item.subFolders != nil && !item.subFolders!.isEmpty {
                cell.accessories = [disclosureAccessory]
            }
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, folder in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: folder)
        }
        
        var snapshot = NSDiffableDataSourceSectionSnapshot<Folder>()
        
        for folder in Folder.parentFolders {
            snapshot.append([folder])
            if let subFolders = folder.subFolders {
                snapshot.append(subFolders, to: folder)
            }
        }
        
        print("SECTIONS: \(snapshot.items)")
                
        dataSource.apply(snapshot, to: 0, animatingDifferences: false)
    }
    
    
    
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    

//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let folder = Folder.allFolders[indexPath.item]
////        delegate.didTapCell(at: indexPath.row, folder: folder)
//    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

protocol CollectionViewDelegate: AnyObject {
    func didTapCell(at index: Int, folder: Folder)
}
