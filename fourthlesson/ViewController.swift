import UIKit

class ViewController: UIViewController {
    
    // Данные
    let fruits = ["🍎 Яблоко", "🍌 Банан", "🍊 Апельсин", "🍇 Виноград", "🍓 Клубника"]
    let animals = ["🐱 Кот", "🐶 Собака", "🐹 Хомяк", "🦊 Лиса", "🐼 Панда"]
    
    // Текущая выбранная секция
    var currentSection = 0 // 0 - фрукты, 1 - животные
    
    var collectionView: UICollectionView!
    var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
        setupSegmentControl()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Регистрируем ячейку
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
    }
    
    func setupSegmentControl() {
        // Создаем переключатель
        let items = ["Фрукты", "Животные"]
        segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Создаем контейнер для нижней панели
        let bottomView = UIView()
        bottomView.backgroundColor = .systemGray6
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomView)
        bottomView.addSubview(segmentControl)
        
        NSLayoutConstraint.activate([
            // Collection view занимает всю область кроме нижней панели
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            // Нижняя панель
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80),
            
            // Переключатель по центру нижней панели
            segmentControl.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            segmentControl.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            segmentControl.widthAnchor.constraint(equalToConstant: 250),
            segmentControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func segmentChanged() {
        currentSection = segmentControl.selectedSegmentIndex
        collectionView.reloadData() // Перезагружаем коллекцию
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSection == 0 ? fruits.count : animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Очищаем ячейку
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Настраиваем внешний вид
        cell.backgroundColor = currentSection == 0 ? .systemRed : .systemBlue
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.2
        
        // Добавляем текст
        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        
        if currentSection == 0 {
            label.text = fruits[indexPath.row]
        } else {
            label.text = animals[indexPath.row]
        }
        
        cell.contentView.addSubview(label)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = currentSection == 0 ? fruits[indexPath.row] : animals[indexPath.row]
        
        let alert = UIAlertController(title: "Выбрано", message: item, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
