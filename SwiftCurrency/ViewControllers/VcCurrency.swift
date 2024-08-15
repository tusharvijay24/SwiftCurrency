//
//  ViewController.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//

import UIKit

class VcCurrency: UIViewController {
    
    @IBOutlet weak var txtDesiredAmount: UITextField!
    @IBOutlet weak var txtCurrencyPicker: UITextField!
    @IBOutlet weak var cvCurrencyGrid: UICollectionView!
    @IBOutlet weak var btnPicker: UIButton!
    
    var viewModel = CurrencyViewModel()
    private var pvCurrency: UIPickerView!
    private var toolbar: UIToolbar!
    private var typingTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configBindings()
        viewModel.fetchInitialData()
    }
    
    private func configUI() {
        configPickerView()
        configCollectionView()
        configTextFields()
    }
    
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (cvCurrencyGrid.bounds.width / numberOfItemsPerRow) - 20
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        cvCurrencyGrid.collectionViewLayout = layout
        cvCurrencyGrid.layoutIfNeeded()
        cvCurrencyGrid.layer.cornerRadius = 15
        cvCurrencyGrid.clipsToBounds = true
        
        cvCurrencyGrid.dataSource = self
        cvCurrencyGrid.delegate = self
        cvCurrencyGrid.isHidden = true
    }
    
    private func configTextFields() {
        txtDesiredAmount.layer.cornerRadius = 15
        txtDesiredAmount.clipsToBounds = true
        txtCurrencyPicker.layer.cornerRadius = 15
        txtCurrencyPicker.clipsToBounds = true
        txtCurrencyPicker.isEnabled = false
        
        txtDesiredAmount.addTarget(self, action: #selector(amountTextChanged), for: .editingChanged)
        
        let btnArrow = UIButton(type: .custom)
        btnArrow.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnArrow.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 10.0)
        btnArrow.setImage(UIImage(named: "down-arrow"), for: .normal)
        btnArrow.addTarget(self, action: #selector(openPickerView), for: .touchUpInside)
        txtCurrencyPicker.rightView = btnArrow
        txtCurrencyPicker.rightViewMode = .always
        btnPicker.addTarget(self, action: #selector(openPickerView), for: .touchUpInside)
    }
    
    private func configBindings() {
        viewModel.onConversionUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if !self.viewModel.convertedAmounts.isEmpty {
                    self.cvCurrencyGrid.reloadData()
                    self.cvCurrencyGrid.isHidden = false
                } else {
                    self.cvCurrencyGrid.isHidden = true
                }
            }
        }
        
        viewModel.onDataFetchComplete = { [weak self] in
            DispatchQueue.main.async {
                self?.txtCurrencyPicker.isEnabled = true
                self?.pvCurrency.reloadAllComponents()
            }
        }

        viewModel.onDataCleared = { [weak self] in
            DispatchQueue.main.async {
                self?.resetUI() 
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }


     func resetUI() {
        txtDesiredAmount.text = ""
        txtCurrencyPicker.text = ""
        txtCurrencyPicker.isEnabled = false
        cvCurrencyGrid.isHidden = true
    }
    
    @objc private func amountTextChanged() {
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performConversion), userInfo: nil, repeats: false)
    }
    
    @objc private func performConversion() {
        guard let amountText = txtDesiredAmount.text, let amount = Double(amountText) else {
            showAlert(title: "Alert!", message: "Invalid amount entered")
            return
        }
        viewModel.convertCurrency(amount: amount)
    }
    
    @objc private func openPickerView() {
        guard let amountText = txtDesiredAmount.text, !amountText.isEmpty else {
            showAlert(title: "Alert!", message: "Please enter amount")
            return
        }
        
        if txtCurrencyPicker.isEnabled {
            txtCurrencyPicker.becomeFirstResponder()
            showPickerView()
        }
    }
    
    private func configPickerView() {
        pvCurrency = UIPickerView()
        pvCurrency.delegate = self
        pvCurrency.dataSource = self
        pvCurrency.backgroundColor = .white
        pvCurrency.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pvCurrency)
        NSLayoutConstraint.activate([
            pvCurrency.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pvCurrency.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pvCurrency.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pvCurrency.heightAnchor.constraint(equalToConstant: 216)
        ])
        
        pvCurrency.isHidden = true
        
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        
        doneButton.isEnabled = false
        toolbar.setItems([doneButton], animated: false)
        
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: pvCurrency.topAnchor)
        ])
        
        toolbar.isHidden = true
        txtCurrencyPicker.inputView = UIView()
    }
    
    private func showPickerView() {
        pvCurrency.isHidden = false
        toolbar.isHidden = false
    }
    
    @objc private func donePicker() {
        txtCurrencyPicker.resignFirstResponder()
        pvCurrency.isHidden = true
        toolbar.isHidden = true
        if let selectedCurrency = viewModel.selectedCurrency {
            txtCurrencyPicker.text = selectedCurrency
        }
    }
}

// MARK: - UIPickerView DataSource and Delegate
extension VcCurrency: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.availableCurrencies.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Please scroll to select"
        } else {
            return viewModel.availableCurrencies[row - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            viewModel.selectedCurrency = viewModel.availableCurrencies[row - 1]
            performConversion()
            toolbar.items?.first?.isEnabled = true
        } else {
            toolbar.items?.first?.isEnabled = false
        }
    }
}

// MARK: - UICollectionView DataSource and Delegate
extension VcCurrency: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.convertedAmounts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CvCellCurrency", for: indexPath) as? CvCellCurrency else {
            return UICollectionViewCell()
        }
        let currencyCode = Array(viewModel.convertedAmounts.keys)[indexPath.row]
        let amount = viewModel.convertedAmounts[currencyCode] ?? 0.0
        cell.config(with: currencyCode, amount: amount)
        return cell
    }
}
