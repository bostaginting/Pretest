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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewEmail.delegate = self
        tableViewEmail.dataSource = self
        loadJsonLocal(fileName: "jsonFile")
    }
    
    func loadJsonLocal(fileName: String) -> EmailModelResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(EmailModelResponse.self, from: data)
                self.emailResponse = jsonData
                self.emailData = jsonData.dataEmail
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
        mailDetailVC.emailDetail = emailResponse?.dataEmail?[indexPath.row].email ?? ""
        self.navigationController?.pushViewController(mailDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewEmail.dequeueReusableCell(withIdentifier: "cellView", for: indexPath)
        
        cell.textLabel?.text = self.emailResponse?.dataEmail?[indexPath.row].email ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            emailResponse?.dataEmail?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
}

