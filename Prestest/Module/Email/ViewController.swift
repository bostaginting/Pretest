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
    private var sortedUnread: Bool = false
    private var sortedStart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewEmail.delegate = self
        tableViewEmail.dataSource = self
        tableViewEmail.register(UINib(nibName: "EmailTableViewCell", bundle: nil), forCellReuseIdentifier: "EmailTableViewCell")
        _ = loadJsonLocal(fileName: "jsonFile", sort: "")
    }
    
    @IBAction func buttonSort(_ sender: UIBarButtonItem) {
        if (sender.tag == 0) {
            sortedDate = !sortedDate
            _ = loadJsonLocal(fileName: "jsonFile", sort: "date" )
        } else {
            sortedStart = true
            sortedUnread = !sortedUnread
            _ = loadJsonLocal(fileName: "jsonFile", sort: "unread")
        }
    }
    
    func loadJsonLocal(fileName: String, sort: String) -> EmailModelResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(EmailModelResponse.self, from: data)
                self.emailResponse = jsonData
                self.emailData = jsonData.dataEmail
                if sort == "date" {
                    if sortedDate {
                        emailData = self.emailData?.sorted{ $0.convertedDate > $1.convertedDate }
                    } else {
                        emailData = self.emailData?.sorted{ $0.convertedDate < $1.convertedDate }
                    }
                } else if sort == "unread" {
                    if sortedUnread {
                        emailData = self.emailData?.sorted{ $0.status! > $1.status! }
                    } else {
                        emailData = self.emailData?.sorted{ $0.status! < $1.status! }
                    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mailDetailVC = storyboard.instantiateViewController(withIdentifier: "MailDetail") as? MailDetailViewController else { return }
        mailDetailVC.emailDetail = self.emailData?[indexPath.row].subject ?? ""
        mailDetailVC.htmlString = self.emailData?[indexPath.row].email ?? ""
        emailData?[indexPath.row].status = 0
        tableView.reloadData()
        self.navigationController?.pushViewController(mailDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewEmail.dequeueReusableCell(withIdentifier: "EmailTableViewCell", for: indexPath) as! EmailTableViewCell
        
        cell.labelEmailContent?.text = self.emailData?[indexPath.row].subject
        cell.labelEmailDate?.text = self.emailData?[indexPath.row].date
        if (self.emailData?[indexPath.row].status == 0 ) {
            cell.viewEmailStatus.backgroundColor = .white
            cell.labelEmailContent.font = UIFont.systemFont(ofSize: 17)
        } else if self.emailData?[indexPath.row].status == 1 {
            cell.labelEmailContent.font = UIFont.boldSystemFont(ofSize: 20)
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

