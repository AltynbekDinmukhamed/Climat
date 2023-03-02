//
//  ViewController.swift
//  Climat
//
//  Created by Димаш Алтынбек on 26.02.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    //MARK: -views-
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "background")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: -Main views
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .trailing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: -navigation bar stack
    let navigationBarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        //stack.alignment = .fill
        //stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var navButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.tintColor = UIColor(named: "DarkMoment")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let navSearch: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 25)
        text.placeholder = "search"
        text.borderStyle = .roundedRect
        text.autocapitalizationType = .words
        text.backgroundColor = UIColor.systemFill
        return text
    }()
    
    private lazy var navSearchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor(named: "DarkMoment")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: -sun Image
    let sunImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "sun.max")
        image.tintColor = UIColor(named: "DarkMoment")
        image.contentMode = .scaleAspectFit
        return image
    }()
    //MARK: -temperature stack
    let temperatureStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "21"
        label.font = .boldSystemFont(ofSize: 80)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureSignLabel: UILabel = {
        let label = UILabel()
        label.text = "°"
        label.font = .systemFont(ofSize: 100, weight: .light)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let CelcieSignLabel: UILabel = {
        let label = UILabel()
        label.text = "C"
        label.font = .systemFont(ofSize: 100, weight: .light)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: -City label
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "London"
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    //MARK: -LifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setUpViews()
        navSearch.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    //MARK: -Funcitions-
    private func setUpViews() {
        view.addSubview(backgroundImage)
        view.addSubview(mainStack)
        mainStack.addArrangedSubview(navigationBarStack)
        //adding views in navigation stack
        navigationBarStack.addArrangedSubview(navButton)
        navigationBarStack.addArrangedSubview(navSearch)
        navigationBarStack.addArrangedSubview(navSearchButton)
        //adding sun image
        mainStack.addArrangedSubview(sunImageView)
        //adding temperature stack
        mainStack.addArrangedSubview(temperatureStack)
        temperatureStack.addArrangedSubview(temperatureLabel)
        temperatureStack.addArrangedSubview(temperatureSignLabel)
        temperatureStack.addArrangedSubview(CelcieSignLabel)
        //adding city label
        mainStack.addArrangedSubview(cityLabel)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            navigationBarStack.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: 5),
            navigationBarStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 5),
            navigationBarStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -5),
            navigationBarStack.heightAnchor.constraint(equalToConstant: 40),
            
            navButton.heightAnchor.constraint(equalToConstant: 40),
            navButton.widthAnchor.constraint(equalToConstant: 40),
            navSearch.heightAnchor.constraint(equalToConstant: 40),
            navSearchButton.heightAnchor.constraint(equalToConstant: 40),
            navSearchButton.widthAnchor.constraint(equalToConstant: 40),
            
            sunImageView.topAnchor.constraint(equalTo: navigationBarStack.bottomAnchor, constant: 5),
            sunImageView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 5),
            sunImageView.heightAnchor.constraint(equalToConstant: 140),
            sunImageView.widthAnchor.constraint(equalToConstant: 140),
            
            temperatureStack.topAnchor.constraint(equalTo: sunImageView.bottomAnchor, constant: 5),
            temperatureStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -5),
            
            cityLabel.topAnchor.constraint(equalTo: temperatureStack.bottomAnchor, constant: 5),
            cityLabel.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 5)
        ])
    }
    
    @objc func navButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
//MARK: -Extension-
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        //print(textField.text!)
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something.."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Use textField.text to get the weather for that city
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        textField.text = ""
    }
}

//MARK: -Weather deleagate-
extension ViewController: WeatherManagerDelegate {
    @objc func searchPressed(_ sender: UIButton) {
        navSearch.endEditing(true)
        print(navSearch.text!)
    }
    
    //Delegate functions
    func didUpdateWeather(_ wheatherManager: WeatherManager, wheather: WeatherModel) {
        print(wheather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = wheather.temperatureString
            self.sunImageView.image = UIImage(systemName: wheather.conditionName)
            self.cityLabel.text = wheather.cityName
        }
    }
    
    func didFailError(error: Error) {
        print(error)
    }
}

//MARK: -CLLocationManagerDelegate-
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeahter(latitude: lat, longtitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
