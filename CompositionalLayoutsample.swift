//
//  CompositionalLayoutsample.swift
//  DownloadManagerProject
//
//  Created by Vipin Sharma on 13/09/23.
//

import Foundation
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    enum Section {
        case horizontalScroll
        case verticalScroll
        case anotherHorizontalScroll
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.addSubview(collectionView)
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createHorizontalScrollSection()
            case 1:
                return self.createVerticalScrollSection()
            case 2:
                return self.createAnotherHorizontalScrollSection()
            default:
                return nil
            }
        }
        return layout
    }
    
    func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createVerticalScrollSection() -> NSCollectionLayoutSection {
        // Customize the layout for the vertical scroll section
        // Similar to the horizontal scroll section
    }
    
    func createAnotherHorizontalScrollSection() -> NSCollectionLayoutSection {
        // Customize the layout for the second horizontal scroll section
        // Similar to the first horizontal scroll section
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.systemTeal
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderReusableView
            header.titleLabel.text = "Section \(indexPath.section + 1) Header"
            header.seeMoreButton.setTitle("See More", for: .normal)
            return header
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.horizontalScroll, .verticalScroll, .anotherHorizontalScroll])
        snapshot.appendItems(Array(1...20), toSection: .horizontalScroll)
        snapshot.appendItems(Array(21...40), toSection: .verticalScroll)
        snapshot.appendItems(Array(41...60), toSection: .anotherHorizontalScroll)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

class HeaderReusableView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(seeMoreButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            seeMoreButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
