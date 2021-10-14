//
//  OnboardingViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/08/2021.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var slicesCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonStart: UIButton!
    let customPageControl = UIPageControl()
    
    var slices = [Slices]()
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlices()
        setupSlicesCollectionView()
        setupCustomPageControl()
    }

    @IBAction func touchSkipButton(_ sender: Any) {
        presentLogin(controller: LoginViewController())
    }
    
    func setupCustomPageControl() {
        self.customPageControl.backgroundStyle = .minimal
        self.customPageControl.currentPage = 0
        self.customPageControl.numberOfPages = slices.count
        self.customPageControl.preferredIndicatorImage = Icons.DotDefault
        self.customPageControl.currentPageIndicatorTintColor = Colors.BarTint
        self.customPageControl.pageIndicatorTintColor = .black
        setupLayoutCustomPageControl()
    }

    func setupLayoutCustomPageControl() {
        view.addSubview(customPageControl)
        self.customPageControl.translatesAutoresizingMaskIntoConstraints = false
        self.customPageControl.topAnchor.constraint(equalTo: slicesCollectionView.bottomAnchor, constant: 10).isActive = true
        self.customPageControl.centerXAnchor.constraint(equalTo: slicesCollectionView.centerXAnchor).isActive = true
        self.customPageControl.bottomAnchor.constraint(equalTo: buttonStart.topAnchor, constant: 10).isActive = true
    }
    
    @IBAction func touchStartButton(_ sender: Any) {
        touchStartButtonAction()
    }
    
    func touchStartButtonAction() {
        if currentPage == slices.count - 1 {
            presentLogin(controller: LoginViewController())
        }
        else {
            updatePage()
        }
    }
    
    func updatePage() {
        currentPage += 1
        customPageControl.currentPage = currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        slicesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        changeTextButton(page: currentPage)
    }
    
    func presentLogin(controller: UIViewController ) {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
    
}

extension OnboardingViewController {
    
    private func changeTextButton(page: Int) {
        switch page {
        case 1:
            buttonStart.setTitle("Siguiente", for: .normal)
        case 2:
            buttonStart.setTitle("Finalizar", for: .normal)
        default:
            buttonStart.setTitle("Comenzar", for: .normal)
        }
    }
    
    private func getSlices() -> [Slices] {
        let slicesArray = [Slices(title: "Buscá", subtitle: "Explorá productos y elegí el mejor", image: Images.Slice1!),
                           Slices(title: "Agregá al carrito", subtitle: "Ve la suma de dinero que gastarás", image: Images.Slice2!),
                           Slices(title: "Es tuyo", subtitle: "Confirma la compra", image: Images.Slice3!)]
        return slicesArray
    }
    
    private func setSlices() {
        slices.append(contentsOf: getSlices())
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupSlicesCollectionView() {
        slicesCollectionView.register(OnboardingCollectionViewCell.nib(), forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        slicesCollectionView.delegate = self
        slicesCollectionView.dataSource = self
        slicesCollectionView.bounces = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = slicesCollectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setupCell(forSlices: slices[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: slicesCollectionView.frame.width , height: slicesCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        customPageControl.currentPage = currentPage
        changeTextButton(page: currentPage)
    }
    
}
