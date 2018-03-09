//
//  DetailViewController.swift
//  iOS-Reload
//
//  Created by Matthew Li on 2018-03-08.
//  Copyright © 2018 matthewli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var blockHeight: UILabel!
    @IBOutlet weak var assetsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var assetBalances = [String: Double]()

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.address
            }
        }
    }

    func updateWalletDetails() {
        if let detail = self.detailItem {
            detail.getHeight(completion: { (height, error) in
                if let h = height {
                    DispatchQueue.main.async {
                        self.blockHeight.text = "block: \(h)"
                    }
                }
                if let e = error {
                    print("error calling getHeight: \(e)")
                }
            })
            
            detail.getBalance(completion: { (balances, error) in
                if let respBalances = balances {
                    self.assetBalances = respBalances
                    DispatchQueue.main.async {
                        self.assetsTable.reloadData()
                    }
                }
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        updateWalletDetails()
        
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) {_ in
            self.updateWalletDetails()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: RunningWallet? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        if let assetCell = sender.superview?.superview as? UITableViewCell {
            if let indexPath = assetsTable.indexPath(for: assetCell) {
                if let amountField = assetCell.contentView.viewWithTag(999) as? UITextField {
                    if let text = amountField.text, let amount = Double(text) {
                        print("send \(amount) from asset \(indexPath.row)")
                        
                        if let detail = self.detailItem {
                            let alert = UIAlertController(title: "Send Asset", message: "Tap an address to send asset to", preferredStyle: .alert)
                            for wallet in appDelegate.runningWallets {
                                if wallet.address != detail.address {
                                    let action = UIAlertAction(title: wallet.address, style: .default, handler: { (action) in
                                        detail.sendAsset(Array(self.assetBalances)[indexPath.row].key, amount: amount, to: wallet.address, completion: { (success, error) in
                                            if success {
                                                print("sendAsset succeeded")
                                            } else {
                                                print("sendAsset failed, error: \(String(describing: error))")
                                            }
                                        })
                                    })
                                    alert.addAction(action)
                                }
                            }
                            let action = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(action)
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Assets"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetBalances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetBalanceCell", for: indexPath)
        let assetId = Array(assetBalances)[indexPath.row].key
        let name = assetNameFrom(id: assetId)
        let balance = Array(assetBalances)[indexPath.row].value
        cell.textLabel?.text = String.localizedStringWithFormat("%@: %.2f", name, balance)
        return cell
    }
}

