import UIKit
import DriftAnimationImageView

class ViewController: UIViewController {

    @IBOutlet weak var imageView: DriftAnimationImageView?
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    @IBAction func valueChangedAction(_ sender: UISegmentedControl?) {
        if let imageView = self.imageView {
            imageView.removeDriftAnimations()
            if let segmentedControl = self.segmentedControl {
                if (segmentedControl.selectedSegmentIndex == 0) {
                    imageView.performDriftAnimations(["photo00.JPG","photo01.JPG"])
                } else if (segmentedControl.selectedSegmentIndex == 1) {
                    imageView.image = UIImage(named: "photo00.JPG")
                    _ = imageView.beginDriftAnimations()
                }
            }
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.valueChangedAction(nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let imageView = self.imageView {
            imageView.removeDriftAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + coordinator.transitionDuration) {
                self.valueChangedAction(nil)
            }
        }
    }
    
}
