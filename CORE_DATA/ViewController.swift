

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var passWordTxtFld: UITextField!
    @IBAction func fetchREsults(sender: AnyObject) {
        let returnArray = DATA_OPERATIONS.sharedDataOperation.fetchAllObjectsForEntity("USERS")
        print(returnArray)
        
        for result in returnArray! as! [NSManagedObject] {
            print(result)
            print(result.valueForKey("userName")!)
            print(result.valueForKey("passWord")!)
        }
    }
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBAction func SaveBtnAction(sender: AnyObject) {
        
        let users: USERS = DATA_OPERATIONS.sharedDataOperation.insertNewObjectForEntityForName("USERS") as! USERS
        users.userName = userNameTxtFld.text
        users.passWord = passWordTxtFld.text
        COREDATA.sharedCoreData.saveContext()
        
        userNameTxtFld.text = ""
        passWordTxtFld.text = ""

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

