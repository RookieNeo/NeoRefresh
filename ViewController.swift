//
//  ViewController.swift
//  NeoRefresh
//
//  Created by Neo on 2017/12/21.
//  Copyright © 2017年 Neo. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
//        print(tableView.frame)
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 44
//        self.view.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.snp.left)
//            make.top.equalTo(self.view.snp.top)
//            make.width.equalTo(300)
//            make.height.equalTo(200)
//        }
        tableView.pd.addPullRefresh {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                                self.tableView.pd.endHeaderRefreshing()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        return cell
    }
}

