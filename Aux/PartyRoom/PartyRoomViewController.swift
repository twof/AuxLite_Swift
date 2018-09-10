import UIKit

class PartyRoomViewController: UIViewController {
    override func loadView() {
        view = PartyRoomView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HELLO")
        self.view.backgroundColor = .blue
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
