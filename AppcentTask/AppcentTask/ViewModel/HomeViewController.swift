import UIKit
import SnapKit
import SafariServices

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
  
    var tableView: UITableView!
    
    
    //object model
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTopStories()
        
        
    }
    
    //SetupUI
    func setupUI(){
        
        title = "Appcent News App"
        //view
        view.backgroundColor = .systemBackground
        
        // Search Bar
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search by title"
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.frame.height/10)
            make.left.right.equalToSuperview()
        }
        
        // TableView oluştur
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        view.addSubview(tableView)
        
        // TableView Konumlandırma
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = DetailsViewController()
        destinationVC.selectedNews = articles[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //API
    private func fetchTopStories(){
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
 
}

// Search Bar Delegate Methods
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Eğer searchBar boşsa, tüm makaleleri göster
        if searchText.isEmpty {
            viewModels = articles.map { NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? "")) }
        } else {
            // Eğer searchBar doluysa, başlıkta arama yap
            viewModels = articles.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                .map { NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? "")) }
        }
        
        // TableView'ı yenile
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // İptal butonuna basıldığında searchBar'ı temizle ve tüm makaleleri göster
        searchBar.text = ""
        viewModels = articles.map { NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? "")) }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

