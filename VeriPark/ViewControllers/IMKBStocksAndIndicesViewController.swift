//
//  IMKBStocksAndIndicesViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 7.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit
import NavigationDrawer

class IMKBStocksAndIndicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var viewController: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var symbolValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var volumeValueLabel: UILabel!
    @IBOutlet weak var buyingValueLabel: UILabel!
    @IBOutlet weak var salesValueLabel: UILabel!
    @IBOutlet weak var changeValueLabel: UILabel!
    
    var symbolArrayInSymbolString: [String] = []
    var symbolArrayInSymbolStr: [String] = []
    var isSearch = false
    
    let symbolValueLabelText = "Sembol"
    let priceValueLabelText = "Fiyat"
    let differenceValueLText = "Fark"
    let volumeValueLabelText = "Hacim"
    let buyingValueLabelText = "Alış"
    let salesValueLabelText = "Satış"
    let changeValueLabelText = "Değişim"
     let navigationBarTitle = "IMKB Hisse ve Endeksler"
    
    let refreshControl = UIRefreshControl()
    
    let startRequestViewController = StartRequestViewController()
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.symbolValueLabel.text = self.symbolValueLabelText
        self.priceValueLabel.text = self.priceValueLabelText
        self.differenceValueLabel.text = self.differenceValueLText
        self.volumeValueLabel.text = self.volumeValueLabelText
        self.buyingValueLabel.text = self.buyingValueLabelText
        self.salesValueLabel.text = self.salesValueLabelText
        self.changeValueLabel.text = self.changeValueLabelText
        navigationBar.title = navigationBarTitle
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = true
        let filteredStrings = StructView.symbolArrayInSymbolStr.filter({(item: String) -> Bool in
            let stringMatch = item.lowercased().range(of: searchText.lowercased())
            return stringMatch != nil ? true : false
        })
        symbolArrayInSymbolString = filteredStrings
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (StructView.symbolArrayInSymbolStr == nil) {
            showAlert(title: "HATA", message: "İnternet hızınızdan dolayı veri çekme işlemi tamamlanamadı lütfen table viewi yenilemek için aşağı çekiniz.")
            return
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSlidingMenu", sender: nil)
    }
    
    @IBAction func edgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "showSlidingMenu", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController{
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearch == true) {
            return symbolArrayInSymbolString.count
        }else {
            return StructView.symbolArrayInSymbolStr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! IMKBStocksAndIndicesTableViewCell
        if (isSearch == true) {
            cell.symbolValueLabel.text = symbolArrayInSymbolString[indexPath.row]
        }else {
            cell.symbolValueLabel.text = StructView.symbolArrayInSymbolStr[indexPath.row]
            cell.differenceValueLabel.text = String(StructView.differenceArray[indexPath.row])
            cell.priceValueLabel.text = String(StructView.priceArray[indexPath.row])
            cell.salesValueLabel.text = String(StructView.offerArray[indexPath.row])
            cell.volumeValueLabel.text = String(StructView.volumeArray[indexPath.row])
            cell.buyingValueLabel.text = String(StructView.bidArray[indexPath.row])
            
            if (StructView.isDownArray[indexPath.row] == false) {
                cell.changeImageView.image = UIImage(named:"up")!
            } else {
                cell.changeImageView.image = UIImage(named:"down")!
            }
        }
        return cell
    }

    @objc private func refreshData(_ sender: Any) {
        
        if (StructView.symbolArrayInSymbolStr == nil) {
            return
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StructView.selectedId = StructView.idArray[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    @IBAction func homeButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}

extension IMKBStocksAndIndicesViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
