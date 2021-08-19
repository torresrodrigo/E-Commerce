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
    
    var slices = [Slices]()
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlices()
        setupSlicesCollectionView()
    }

    @IBAction func touchSkipButton(_ sender: Any) {
        presentLogin(forLogin: LoginViewController())
    }
    
    @IBAction func touchStartButton(_ sender: Any) {
        if currentPage == slices.count - 1 {
            presentLogin(forLogin: LoginViewController())
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            slicesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            changeTextButton(forIndex: currentPage)
            pageControl.currentPage = currentPage
        }
    }
    
    func presentLogin(forLogin login: UIViewController ) {
        let navigation = UINavigationController(rootViewController: login)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
    
}

extension OnboardingViewController {
    
    private func changeTextButton(forIndex index: Int) {
        if index == 1 {
            buttonStart.setTitle("Siguiente", for: .normal)
        } else if index == 2 {
            buttonStart.setTitle("Finalizar", for: .normal)
        } else {
            buttonStart.setTitle("Comenzar", for: .normal)
        }
    }
    
    private func getSlices() -> [Slices] {
        var slicesArray = [Slices]()
        let slices1 = Slices(title: "Buscá", subtitle: "Explorá productos y elegí el mejor", image: Images.Slice1!)
        let slices2 = Slices(title: "Agregá al carrito", subtitle: "Ve la suma de dinero que gastarás", image: Images.Slice2!)
        let slices3 = Slices(title: "Es tuyo", subtitle: "Confirma la compra", image: Images.Slice3!)
        slicesArray.append(slices1)
        slicesArray.append(slices2)
        slicesArray.append(slices3)
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
        return CGSize(width: slicesCollectionView.frame.width - 9 , height: slicesCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width - 9
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
        changeTextButton(forIndex: currentPage)
    }
}
