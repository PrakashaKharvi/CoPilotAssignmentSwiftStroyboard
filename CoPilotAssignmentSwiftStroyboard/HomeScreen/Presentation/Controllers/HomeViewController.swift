//
//  HomeViewController.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var articleListTableView: UITableView!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionTableView()
        bindViewModel()
        viewModel.fetchFilters()
        viewModel.fetchArticleList()
    }
    
    private func setupCollectionTableView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(UINib(nibName: "DropDownCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DropDownCollectionViewCell")
        
        articleListTableView.dataSource = self
        articleListTableView.delegate = self
        articleListTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    private func bindViewModel() {
        viewModel.onFilterFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.filterCollectionView.reloadData()
            }
        }
        
        self.viewModel.onArticleListFetched = { [weak self] in
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
        
    }
}

