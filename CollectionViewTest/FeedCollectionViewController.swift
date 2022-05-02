//
//  FeedCollectionViewController.swift
//  CollectionViewTest
//
//  Created by Omer Hagage on 28/04/2022.
//

import Foundation
import UIKit

enum Section {
  case main
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, UIColor>

typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIColor>

class FeedCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout,
                                    UICollectionViewDataSourcePrefetching {
  private lazy var dataSource: DataSource = makeDataSource()

  private let collectionView: UICollectionView

  private static let cellIdentifier = "CollectionViewCell"

  init() {
//    let layout = Self.makeFlowLayout()
    let layout = Self.makeCompositionLayout()

    print("Log: collectionview layout - \(layout.description)")
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: Self.cellIdentifier
    )

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCollectionView()
    applySnapshot(animatingDifferences: false)
  }

  private static func makeFlowLayout() -> UICollectionViewFlowLayout {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 0
    return flowLayout
  }

  private static func makeCompositionLayout() -> UICollectionViewLayout {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 0

    let fullSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: fullSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: fullSize, subitems: [item])
    let layout = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: layout, configuration: config)
  }

  private func setupCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.prefetchDataSource = self
    collectionView.isPrefetchingEnabled = true

    collectionView.contentInsetAdjustmentBehavior = .never

    view.addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    let contraints = [
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor)
    ]

    NSLayoutConstraint.activate(contraints)
  }

  private func makeDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: Self.cellIdentifier,
          for: indexPath
        )

        print("Log: configure cell in indexPath - \(indexPath)")
        cell.backgroundColor = itemIdentifier
        return cell
    })
    return dataSource
  }

  private func applySnapshot(animatingDifferences: Bool = true) {
    let items = (0...200).map { _ in
      UIColor(
        red: CGFloat.random(in: 0...1),
        green: CGFloat.random(in: 0...1),
        blue: CGFloat.random(in: 0...1),
        alpha: 1
      )
    }

    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
  }

  // MARK: - UICollectionViewDataSourcePrefetching

  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    print("Log: prefetch cells in indexPaths - \(indexPaths)")
  }
}
