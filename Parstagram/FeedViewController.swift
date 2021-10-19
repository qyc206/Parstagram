//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Qin Ying Chen on 10/18/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var numberOfPosts: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {   // happens only once
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadPosts()
        
        // handle pull to refresh
        myRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        // Do any additional setup after loading the view.
    }
    
    @objc func loadPosts(){
        numberOfPosts = 20
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")  // fetch the author object
        query.order(byDescending: "createdAt")
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { posts, error in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    func loadMorePosts(){
        numberOfPosts = numberOfPosts + 1
        let query = PFQuery(className: "Posts")
        query.includeKey("author")  // fetch the author object
        query.order(byDescending: "createdAt")
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { posts, error in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == posts.count {
            loadMorePosts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        
        // display username
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        // display caption
        cell.captionLabel.text = (post["caption"] as! String)
        
        // display image
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
