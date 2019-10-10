//
//  IMKBStocksAndIndicesViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 7.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit
import NavigationDrawer

class IMKBStocksAndIndicesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewController: UIView!
    
    @IBOutlet weak var symbolValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var volumeValueLabel: UILabel!
    @IBOutlet weak var buyingValueLabel: UILabel!
    @IBOutlet weak var salesValueLabel: UILabel!
    @IBOutlet weak var changeValueLabel: UILabel!
    
    let symbolValueLabelText = "Sembol"
    let priceValueLabelText = "Fiyat"
    let differenceValueLText = "Fark"
    let volumeValueLabelText = "Hacim"
    let buyingValueLabelText = "Alış"
    let salesValueLabelText = "Satış"
    let changeValueLabelText = "Değişim"
    
    
    
    
    var symbolArrayInSymbolStr: [String] = []
    let refreshControl = UIRefreshControl()
    
    let navigationBarTitle = "IMKB Hisse ve Endeksler"
    let deneme = StartRequestViewController()
    
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        return StructView.symbolArrayInSymbolStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! IMKBStocksAndIndicesTableViewCell
        cell.symbolValueLabel.text = StructView.symbolArrayInSymbolStr[indexPath.row]
        cell.differenceValueLabel.text = String(StructView.differenceArray[indexPath.row])
        cell.priceValueLabel.text = String(StructView.priceArray[indexPath.row])
        cell.salesValueLabel.text = String(StructView.offerArray[indexPath.row])
        cell.volumeValueLabel.text = String(StructView.volumeArray[indexPath.row])
        cell.buyingValueLabel.text = String(StructView.bidArray[indexPath.row])
        
        if (StructView.isDownArray[indexPath.row] == false) {
            cell.imageView?.image = UIImage(named:"up")!
        } else {
            cell.imageView?.image = UIImage(named:"down")!
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
        performSegue(withIdentifier: "toDetail", sender: self)
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
