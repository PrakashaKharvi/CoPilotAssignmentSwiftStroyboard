//
//  HomeViewController.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import UIKit

enum LoadScreenFor {
    case initial
    case tagBased
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var articleListTableView: UITableView!
    
    var viewModel: HomeViewModel!
    var loadFor: LoadScreenFor = .initial
    var navigationTtile = "ARTICLES"
    var selectdTag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.navigationTtile
        
        setupCollectionTableView()
        
        self.bindViewModel()
        self.viewModel.fetchArticleList()

        switch self.loadFor {
        case .initial:
            self.viewModel.fetchFilters()
            
        case .tagBased:
            self.filterCollectionView.isHidden = true
        }
    }
    
    private func setupCollectionTableView() {
        self.filterCollectionView.dataSource = self
        self.filterCollectionView.delegate = self
        self.filterCollectionView.register(UINib(nibName: "DropDownCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DropDownCollectionViewCell")
        
        self.articleListTableView.dataSource = self
        self.articleListTableView.delegate = self
        self.articleListTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    private func bindViewModel() {
        self.viewModel.onFilterFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.filterCollectionView.reloadData()
            }
        }
        
        // Article
        self.viewModel.onArticleListFetched = { [weak self] in
            switch self?.loadFor {
            case .initial:
                DispatchQueue.main.async {
                    self?.articleListTableView.reloadData()
                }
                
            case .tagBased:
                if let selectdTag = self?.selectdTag {
                    self?.viewModel.fetchTagBasedArticleList(tags: [selectdTag])
                }
            case .none: break
            }
        }
        
        self.viewModel.onTagBasedArticleListFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.articleListTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFilters()
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DropDownCollectionViewCell", for: indexPath) as! DropDownCollectionViewCell
        let filter = viewModel.getFilterCategoryFor(index: indexPath.row)
        cell.configureCell(list: filter?.list)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // To scroll the selected cell to the center in a UICollectionView, you can use the scrollToItem(at:at:animated:) method with .centeredHorizontally or .centeredVertically, depending on your layout.
        viewModel.centerCellSmoothly(collectionView: filterCollectionView, indexPath: indexPath)
        
        // Need to display dropdown from viewModel.filterList[indexPath.row].list
        guard let selectedFilter = viewModel.filterModel?.data[indexPath.row] else { return }
        if let cell = collectionView.cellForItem(at: indexPath) as? DropDownCollectionViewCell {
            showDropdown(for: selectedFilter, sourceView: cell, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 32)
    }
}

extension HomeViewController {
    func showDropdown(for categoryModel: FilterCategoryModel, sourceView: DropDownCollectionViewCell, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Select " + categoryModel.title, message: nil, preferredStyle: .actionSheet)
        
        categoryModel.list.forEach { option in
            var title = option.name
            if option.id == "0" {
                title = viewModel.getAllTitle(data: categoryModel)
            }
                
            let action = UIAlertAction(title: title, style: .default) { _ in
                // Update selected item in viewModel
                self.viewModel.updateSelectedItem(categoryId: categoryModel.id, itemId: option.id)
                self.filterCollectionView.reloadItems(at: [indexPath])
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = CGRect(x: sourceView.bounds.midX, y: -sourceView.bounds.height, width: 0, height: 0)
            popoverController.permittedArrowDirections = [.down]
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfArticles()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        let article = self.viewModel.getArticleFor(index: indexPath.row)
        cell.configureCell(model: article)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectArticle(at: indexPath.row)
    }
}

