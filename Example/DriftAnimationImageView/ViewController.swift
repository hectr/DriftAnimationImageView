import UIKit
import DriftAnimationImageView

class ViewController: UIViewController {

    @IBOutlet weak var imageView: DriftAnimationImageView?
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    @IBAction func valueChangedAction(sender: UISegmentedControl?) {
        if let imageView = self.imageView {
            imageView.removeDriftAnimations()
            if let segmentedControl = self.segmentedControl {
                if (segmentedControl.selectedSegmentIndex == 0) {
                    imageView.performDriftAnimations(["photo00.JPG","photo01.JPG"])
                } else if (segmentedControl.selectedSegmentIndex == 1) {
                    imageView.image = UIImage(named: "photo00.JPG")
                    imageView.beginDriftAnimations()
                }
            }
        }
    }
    
    // MARK: UIViewController
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.valueChangedAction(nil)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if let imageView = self.imageView {
            imageView.removeDriftAnimations()
            dispatch_after(UInt64(coordinator.transitionDuration()), dispatch_get_main_queue(), {
                self.valueChangedAction(nil)
            })
        }
    }
    
}
