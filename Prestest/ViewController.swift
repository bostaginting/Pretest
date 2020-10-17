//
//  ViewController.swift
//  Prestest
//
//  Created by Bosta Ginting on 15/10/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewEmail: UITableView!
    
    private var emailResponse : EmailModelResponse?
    private var emailData: [DataEmail]? = []
    private var sortedDate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewEmail.delegate = self
        tableViewEmail.dataSource = self
        tableViewEmail.register(UINib(nibName: "EmailTableViewCell", bundle: nil), forCellReuseIdentifier: "EmailTableViewCell")
        _ = loadJsonLocal(fileName: "jsonFile")
    }
    
    @IBAction func buttonSortDate(_ sender: Any) {
        emailData?.removeAll()
        sortedDate = !sortedDate
        _ = loadJsonLocal(fileName: "jsonFile")
    }
    
    func loadJsonLocal(fileName: String) -> EmailModelResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(EmailModelResponse.self, from: data)
                self.emailResponse = jsonData
                self.emailData = jsonData.dataEmail
                if sortedDate == true {
                    emailData = self.emailData?.sorted{ $0.convertedDate > $1.convertedDate }
                } else if sortedDate == false {
                    self.emailData = jsonData.dataEmail
                }
                
                self.tableViewEmail.reloadData()
                
            } catch {
                print("error: \(error)")
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emailResponse?.dataEmail?.count ?? 0
    }
    
    //status 0 = read
    //status 1 = unread
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mailDetailVC = storyboard.instantiateViewController(withIdentifier: "MailDetail") as? MailDetailViewController else { return }
        mailDetailVC.emailDetail = self.emailData?[indexPath.row].email ?? ""
        emailData?[indexPath.row].status = 0
        tableView.reloadData()
        
        self.navigationController?.pushViewController(mailDetailVC, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewEmail.dequeueReusableCell(withIdentifier: "EmailTableViewCell", for: indexPath) as! EmailTableViewCell
        
        cell.labelEmailContent?.text = self.emailData?[indexPath.row].email
        cell.labelEmailDate?.text = self.emailData?[indexPath.row].date
        if (self.emailData?[indexPath.row].status == 0 ) {
            cell.viewEmailStatus.backgroundColor = .white
        } else {
            cell.viewEmailStatus.backgroundColor = .systemBlue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            emailResponse?.dataEmail?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.emailResponse?.dataEmail?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        let unreadAction = UIContextualAction(style: .normal, title: "Unread") {  (contextualAction, view, boolValue) in
            self.emailData?[indexPath.row].status = 1
            self.tableViewEmail.reloadData()
        }
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, unreadAction])
        
        return swipeActions
    }
}

