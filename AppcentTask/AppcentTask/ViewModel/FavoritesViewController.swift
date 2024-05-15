 import UIKit
 import CoreData
 import SnapKit

 class FavoritesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

     //tableView
     var tableView: UITableView = {
             let tableView = UITableView()
             tableView.translatesAutoresizingMaskIntoConstraints = false
             return tableView
         }()
     
     //CoreData'dan veri çekmek için
     var nameArray = [String]()
     var idArray = [UUID]()
     
     //tableView'a veri aktarımı için (adım 3)
     var selectedPainting = ""
     var selectedPaintingId : UUID?
     
     private var articles = [Article]()
     

     
     
     override func viewDidLoad() {
         super.viewDidLoad()

         view.backgroundColor = .systemBackground
         
         setupUI()
         getData()
         NotificationCenter.default.addObserver(self, selector: #selector(handleBoolValueChanged(_:)), name: NSNotification.Name("Bool"), object: nil)
         self.tableView.reloadData()
         
     }
     
     // Notification alındığında tetiklenecek metod
       @objc func handleBoolValueChanged(_ notification: Notification) {
           // Notification'dan bool değeri al
           if let myBoolValue = notification.object as? Bool {
               // Alınan bool değerine göre işlem yap
               if myBoolValue == true {
                   print("Bool değeri true")
                   self.tableView.reloadData()
               } else {
                   print("Bool değeri false")
               }
           }
       }
       
       // NotificationCenter'den abonelik kaldırma
       deinit {
           NotificationCenter.default.removeObserver(self)
       }
     
     func setupUI(){
         
         //
         title = "Favorites"
         
         //tableView
         tableView.delegate = self
         tableView.dataSource = self
         tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
         view.addSubview(tableView)
         tableView.snp.makeConstraints { make in
                   make.top.equalToSuperview().offset(50)
                   make.leading.equalToSuperview().offset(20)
                   make.trailing.equalToSuperview().offset(-20)
                   make.bottom.equalToSuperview().offset(-50)
               }
     }
     
     //yeni eklenen verileri tableView'da görüntülemek için (adım2)
     override func viewWillAppear(_ animated: Bool) {
         NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
     }
     
     //Data'yı çekmek için ilgili fonksiyon
     @objc func getData() {
         //yeni eklenen verileri tableView'da görüntülerken , geçmişteki verileri de tekrar tekrar yazdırmamak için diziyi temizlemelisin.
         nameArray.removeAll(keepingCapacity: false)
         idArray.removeAll(keepingCapacity: false)
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppcentData")
         fetchRequest.returnsObjectsAsFaults = false
         
         do {
             let results = try context.fetch(fetchRequest)
             
             if results.count > 0 {
                 
                 //CoreData model objesi olarak tek tek verileri çekmek için
                 for result in results as! [NSManagedObject] {
                     if let name = result.value(forKey: "name") as? String {
                         self.nameArray.append(name)
                     }
                     
                     if let id = result.value(forKey: "id") as? UUID  {
                         self.idArray.append(id)
                     }
                     
                     //veri ekledikten sonra tableView'i refresh edip yeni verileri görmek için
                     self.tableView.reloadData()
                     
                 }
                 
             }
             
             
             
         } catch {
             print("error")
         }
         
     }
     
     //tableView satır sayısı
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return nameArray.count
     }
     
     //tableView'da satırlarda şu gözüksün
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell()
         var content = cell.defaultContentConfiguration()
         content.text = nameArray[indexPath.row]
         cell.contentConfiguration = content
         return cell
     }

     //seçili satıra şunu yap
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         selectedPainting = nameArray[indexPath.row]
         selectedPaintingId = idArray[indexPath.row]
         let destinationVC = DetailsViewController()
         destinationVC.modalTransitionStyle = .flipHorizontal
         destinationVC.chosenPainting = selectedPainting
         destinationVC.chosenPaintingId = selectedPaintingId
      
         navigationController?.pushViewController(destinationVC, animated: true)
     }
     
     //tableView'dan sola kaydırarak verileri silmek için
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle  == .delete {
 
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
             //fetchRessguest oluşturucaz. ve ilgili veriyi silicez
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppcentData")
 
             let idString = idArray[indexPath.row].uuidString
             fetchRequest.predicate = NSPredicate(format: "id = %@",idString )
 
             fetchRequest.returnsObjectsAsFaults = false
 
             do {
                 let results = try context.fetch(fetchRequest)
                 if results.count > 0 {
                     for result in results as! [NSManagedObject] {
                         if let id = result.value(forKey: "id") as? UUID {
                             if id == idArray[indexPath.row]{
                                 context.delete(result)
                                 nameArray.remove(at: indexPath.row)
                                 idArray.remove(at: indexPath.row)
                                 self.tableView.reloadData()
 
                                 do {
                                     try context.save()
                                 } catch {
                                     print("error")
                                 }
                                 //aradığım şeyi bulduysam ve sildiysem 'break' diyorum ve for loop'u sonlandırıyorum.
                                 break
 
                             }
                         }
                     }
                 }
 
             } catch {
                 print("error")
             }
 
         }
     }
     // delete func burda bitti
     

 }


 
