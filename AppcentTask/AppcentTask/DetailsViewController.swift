//
//  DetailsViewController.swift
//  AppcentTask
//
//  Created by cihangirincaz on 12.05.2024.
//

import UIKit
import SnapKit
import CoreData
import SafariServices

class DetailsViewController: UIViewController {
    
    //UIView-Elements
    var FavoritesButton = UIBarButtonItem()
    var shareButton = UIBarButtonItem()
    var imageView = UIImageView()
    let titleLabel = UILabel()
    let sourceImageView = UIImageView()
    let sourceLabel = UILabel()
    let timeImageView = UIImageView()
    let timeLabel = UILabel()
    let descriptionTextView = UITextView()
    let webServiceButton = UIButton()
    
    var selectedNews: Article?
    
    //tableView'a veri aktarımı için
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    var favoritesImageURL = String()
    var favoritesURL = String()
    var favoritesisClicked = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Sağ üst köşeye birinci butonu (favoritesButton) ekleme
            FavoritesButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoritesButtonTapped))
            
            // Sağ üst köşeye ikinci butonu (shareButton) ekleme
            shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))
            
            // Sağ üst köşeye boşluk ekleyerek butonları birbirinden ayırma
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 10
            
            // Butonları navigationItem'a ekleme
            navigationItem.rightBarButtonItems = [FavoritesButton, spacer, shareButton]
        
        
        
        favoritesURL = selectedNews?.url ?? ""
        setupUI()
        
        stringToURL()
        getData()
        
//        if favoritesisClicked == true {
//            FavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        } else if favoritesisClicked == false {
//            FavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
        print(chosenPaintingId)
       
    }
    
    func getData() {
        // CoreData'dan data çekme işlemleri buraya gelecek
        
          
          //tableView'a veri aktarımı için (adım 2)
          if chosenPainting != "" {
              
            
              
              
              //CoreData'dan data çekicem
              
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext

              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppcentData")
              
              //ilgili "id" üzerinden arayıp bulmak için yazılan fonksiyon
              let idString = chosenPaintingId?.uuidString
              fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
              fetchRequest.returnsObjectsAsFaults = false

              do {
                  let results = try context.fetch(fetchRequest)
                  
                  if results.count > 0 {
                      for result in results as! [NSManagedObject] {
                          if let name = result.value(forKey: "name") as? String {
                              sourceLabel.text = name
                          }
                          
                          if let descriptionNews = result.value(forKey: "descriptionNews") as? String {
                              descriptionTextView.text = descriptionNews
                          }
                          
                          if let publishedAt = result.value(forKey: "publishedAt") as? String {
                              timeLabel.text = publishedAt
                          }
                          
                          if let title = result.value(forKey: "title") as? String {
                              titleLabel.text = title
                          }
                          
                          if let bool = result.value(forKey: "bool") as? Bool {
                              favoritesisClicked = bool
                          }
                          
                          if let url = result.value(forKey: "url") as? String {
                              favoritesURL = url
                          }
                          
                          if let urlToImage = result.value(forKey: "urlToImage") as? String {
                              favoritesImageURL = urlToImage
                              
                              guard let imageURL = URL(string: favoritesImageURL) else {
                                  print("Invalid image URL")
                                  return
                              }

                              let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                                  if let error = error {
                                      print("Error downloading image data:", error)
                                      return
                                  }
                                  
                                  guard let imageData = data else {
                                      print("No image data received")
                                      return
                                  }
                                  
                                  // Gelen veriyi ana iş parçacığında kullan
                                  DispatchQueue.main.async {
                                      // Veriyi kullanarak UIImageView.image'i güncelle
                                      let image = UIImage(data: imageData)
                                      self.imageView.image = image
                                  }
                              }

                              task.resume()
                              
                              
                              
                          }
                          
                      }
                  }
                  
              } catch {
                  print("error")
              }
          } else {
          }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    func stringToURL( ){
      
        guard let imageURL = URL(string: selectedNews?.urlToImage ?? "") else {
            print("Invalid image URL")
            return
        }

        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Error downloading image data:", error)
                return
            }
            
            guard let imageData = data else {
                print("No image data received")
                return
            }
            
            // Gelen veriyi ana iş parçacığında kullan
            DispatchQueue.main.async {
                // Veriyi kullanarak UIImageView.image'i güncelle
                let image = UIImage(data: imageData)
                self.imageView.image = image
            }
        }

        task.resume()

       
    }
    
    
    func setupUI(){
        //Favorites Button
//        FavoritesButton.addTarget(self, action: #selector(FavoritesButtonTapped), for: .touchUpInside)
//        FavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        //Share Button
//        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
//        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        // ImageView
        imageView.image = UIImage(systemName: "book.pages.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        //TitleLabel
        titleLabel.text = "Title Label"
        titleLabel.textAlignment = .center
        titleLabel.text = selectedNews?.title
        titleLabel.numberOfLines = 0
       
        // Source Image
        sourceImageView.image = UIImage(systemName: "book.pages.fill")
        sourceImageView.contentMode = .scaleAspectFit
        sourceImageView.clipsToBounds = true
   
        // Source Label
        sourceLabel.text = selectedNews?.source.name
        sourceLabel.numberOfLines = 2
        
        // Time Image
        timeImageView.image = UIImage(systemName: "calendar")
        timeImageView.contentMode = .scaleAspectFit
       
        // Time Label
        timeLabel.text = selectedNews?.publishedAt
        timeLabel.numberOfLines = 2
        
        // descriptionTextView
        descriptionTextView.text = selectedNews?.description
        descriptionTextView.font = .systemFont(ofSize: 15)
     
        // WEB Service
        webServiceButton.setTitle("News Source", for: .normal)
        webServiceButton.setTitleColor(.systemRed, for: .normal)
        webServiceButton.tintColor = .systemRed
        webServiceButton.titleColor(for: .normal)
        webServiceButton.layer.borderColor = UIColor.red.cgColor
        webServiceButton.layer.borderWidth = 2
        webServiceButton.layer.cornerRadius = 10
        webServiceButton.addTarget(self, action: #selector(webServiceButtonTapped), for: .touchUpInside)
      
        //view
        view.backgroundColor = .systemBackground
//        view.addSubview(FavoritesButton)
//        view.addSubview(shareButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(sourceImageView)
        view.addSubview(sourceLabel)
        view.addSubview(timeImageView)
        view.addSubview(timeLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(webServiceButton)
        
        
     
        // SnapKit Constraints
//        FavoritesButton.snp.makeConstraints { make in
//            make.top.equalTo(view.frame.height/10)
//            make.trailing.equalToSuperview().offset(-view.frame.width/15)
//        }
//
//        shareButton.snp.makeConstraints { make in
//            make.top.equalTo(view.frame.height/10)
//            make.trailing.equalTo(FavoritesButton.snp.leading).offset(-10)
//        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.frame.height/8)
//            make.top.equalTo(FavoritesButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(view.frame.width*9/10)
            make.height.equalTo(view.frame.height/3)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalTo(view.frame.width*85/100)
            make.centerX.equalToSuperview()
        }

        sourceImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(imageView)
            make.width.height.equalTo(20)
        }

        sourceLabel.snp.makeConstraints { make in
            
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(sourceImageView.snp.right).offset(5)
            make.width.equalTo(view.frame.width*35/100)
        }

        timeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(sourceImageView)
            make.left.equalTo(sourceLabel.snp.right).offset(10)
            make.width.height.equalTo(20)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(timeImageView.snp.right).offset(5)
            make.width.equalTo(view.frame.width*35/100)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(sourceImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(webServiceButton.snp.top).offset(-20)
        }

        webServiceButton.snp.makeConstraints { make in
            make.bottom.equalTo(-view.frame.height/8)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width/2)
            make.height.equalTo(view.frame.height/25)
        }
    }
    
    //Favorites button operations
    @objc func FavoritesButtonTapped() {
        
       
            print("ilgili satır kaydedildi")
            // bu kısım ezber . her seferinde aynı.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //context'in içine ne koyulucağını belirlemek için
            let newPainting = NSEntityDescription.insertNewObject(forEntityName: "AppcentData", into: context)
            
            
            //Attributes
              newPainting.setValue(UUID(), forKeyPath: "id")
              newPainting.setValue(true, forKey: "bool")
              newPainting.setValue(selectedNews?.source.name , forKey: "name")
              newPainting.setValue(selectedNews?.description , forKey: "descriptionNews")
              newPainting.setValue(selectedNews?.publishedAt , forKey: "publishedAt")
              newPainting.setValue(selectedNews?.title , forKey: "title")
              newPainting.setValue(selectedNews?.urlToImage, forKey: "urlToImage")
              newPainting.setValue(selectedNews?.url, forKey: "url")

            
            
            //verileri kaydetmek için
            do {
                try context.save()
                print("succes")
            } catch {
                print("error")
            }
            
            
            //işim bittikten sonra favorites butonun image'sini değiştirmek için
//            FavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoritesisClicked = true
            
            //yeni eklenen verileri tableView'da görüntülemek için(devamı ViewController'da)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        makeAlert(titleInput: "Bildirim!", messageInput: "Favorilere Kaydedildi")
        
    }
    
    //shared operations
    @objc func shareButtonTapped() {
        print("shareButtonTapped")
        print(favoritesURL)
        
        guard let newURL = URL(string: favoritesURL ?? "") else {
            return
        }
        let objectsToShare: [Any] = [newURL]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    // go to Safari
    @objc func webServiceButtonTapped() {
        guard let newURL = URL(string: favoritesURL) else {
            return
        }
        let vc = SFSafariViewController(url: newURL)
        present(vc, animated: true)
    }
}



/*
 
 //
 //  DetailsViewController.swift
 //  AppcentTask
 //
 //  Created by cihangirincaz on 12.05.2024.
 //

 import UIKit
 import SnapKit
 import CoreData
 import SafariServices

 class DetailsViewController: UIViewController {
     
     //UIView-Elements
     var FavoritesButton = UIBarButtonItem()
     var shareButton = UIBarButtonItem()
     var imageView = UIImageView()
     let titleLabel = UILabel()
     let sourceImageView = UIImageView()
     let sourceLabel = UILabel()
     let timeImageView = UIImageView()
     let timeLabel = UILabel()
     let descriptionTextView = UITextView()
     let webServiceButton = UIButton()
     
     var selectedNews: Article?
     
     //tableView'a veri aktarımı için
     var chosenPainting = ""
     var chosenPaintingId : UUID?
     var favoritesImageURL = String()
     var favoritesURL = String()
     var favoritesisClicked = false
     
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         // Sağ üst köşeye birinci butonu ekleme
         FavoritesButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
             navigationItem.rightBarButtonItem = addButton

             // Sağ üst köşeye ikinci butonu ekleme
         shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(editButtonTapped))
             let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
             spacer.width = 10
             navigationItem.rightBarButtonItems = [editButton, spacer, addButton]
         
         
         
         
         
         favoritesURL = selectedNews?.url ?? ""
         setupUI()
         
         stringToURL()
         getData()
         
         if favoritesisClicked == true {
             FavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
         } else if favoritesisClicked == false {
             FavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
         }
         print(chosenPaintingId)
        
     }
     
     func getData() {
         // CoreData'dan data çekme işlemleri buraya gelecek
         
           
           //tableView'a veri aktarımı için (adım 2)
           if chosenPainting != "" {
               
             
               
               
               //CoreData'dan data çekicem
               
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext

               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppcentData")
               
               //ilgili "id" üzerinden arayıp bulmak için yazılan fonksiyon
               let idString = chosenPaintingId?.uuidString
               fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
               fetchRequest.returnsObjectsAsFaults = false

               do {
                   let results = try context.fetch(fetchRequest)
                   
                   if results.count > 0 {
                       for result in results as! [NSManagedObject] {
                           if let name = result.value(forKey: "name") as? String {
                               sourceLabel.text = name
                           }
                           
                           if let descriptionNews = result.value(forKey: "descriptionNews") as? String {
                               descriptionTextView.text = descriptionNews
                           }
                           
                           if let publishedAt = result.value(forKey: "publishedAt") as? String {
                               timeLabel.text = publishedAt
                           }
                           
                           if let title = result.value(forKey: "title") as? String {
                               titleLabel.text = title
                           }
                           
                           if let bool = result.value(forKey: "bool") as? Bool {
                               favoritesisClicked = bool
                           }
                           
                           if let url = result.value(forKey: "url") as? String {
                               favoritesURL = url
                           }
                           
                           if let urlToImage = result.value(forKey: "urlToImage") as? String {
                               favoritesImageURL = urlToImage
                               
                               guard let imageURL = URL(string: favoritesImageURL) else {
                                   print("Invalid image URL")
                                   return
                               }

                               let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                                   if let error = error {
                                       print("Error downloading image data:", error)
                                       return
                                   }
                                   
                                   guard let imageData = data else {
                                       print("No image data received")
                                       return
                                   }
                                   
                                   // Gelen veriyi ana iş parçacığında kullan
                                   DispatchQueue.main.async {
                                       // Veriyi kullanarak UIImageView.image'i güncelle
                                       let image = UIImage(data: imageData)
                                       self.imageView.image = image
                                   }
                               }

                               task.resume()
                               
                               
                               
                           }
                           
                       }
                   }
                   
               } catch {
                   print("error")
               }
           } else {
           }
     }

     
     
     
     
     
     
     
     
     
     
     
     
     func stringToURL( ){
       
         guard let imageURL = URL(string: selectedNews?.urlToImage ?? "") else {
             print("Invalid image URL")
             return
         }

         let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
             if let error = error {
                 print("Error downloading image data:", error)
                 return
             }
             
             guard let imageData = data else {
                 print("No image data received")
                 return
             }
             
             // Gelen veriyi ana iş parçacığında kullan
             DispatchQueue.main.async {
                 // Veriyi kullanarak UIImageView.image'i güncelle
                 let image = UIImage(data: imageData)
                 self.imageView.image = image
             }
         }

         task.resume()

        
     }
     
     
     func setupUI(){
         //Favorites Button
         FavoritesButton.addTarget(self, action: #selector(FavoritesButtonTapped), for: .touchUpInside)
         FavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
         
         //Share Button
         shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
         shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
         
         // ImageView
         imageView.image = UIImage(systemName: "book.pages.fill")
         imageView.contentMode = .scaleAspectFill
         imageView.clipsToBounds = true
         
         //TitleLabel
         titleLabel.text = "Title Label"
         titleLabel.textAlignment = .center
         titleLabel.text = selectedNews?.title
         titleLabel.numberOfLines = 0
        
         // Source Image
         sourceImageView.image = UIImage(systemName: "book.pages.fill")
         sourceImageView.contentMode = .scaleAspectFit
         sourceImageView.clipsToBounds = true
    
         // Source Label
         sourceLabel.text = selectedNews?.source.name
         sourceLabel.numberOfLines = 2
         
         // Time Image
         timeImageView.image = UIImage(systemName: "calendar")
         timeImageView.contentMode = .scaleAspectFit
        
         // Time Label
         timeLabel.text = selectedNews?.publishedAt
         timeLabel.numberOfLines = 2
         
         // descriptionTextView
         descriptionTextView.text = selectedNews?.description
         descriptionTextView.font = .systemFont(ofSize: 15)
      
         // WEB Service
         webServiceButton.setTitle("News Source", for: .normal)
         webServiceButton.setTitleColor(.systemRed, for: .normal)
         webServiceButton.tintColor = .systemRed
         webServiceButton.titleColor(for: .normal)
         webServiceButton.layer.borderColor = UIColor.red.cgColor
         webServiceButton.layer.borderWidth = 2
         webServiceButton.layer.cornerRadius = 10
         webServiceButton.addTarget(self, action: #selector(webServiceButtonTapped), for: .touchUpInside)
       
         //view
         view.backgroundColor = .systemBackground
         view.addSubview(FavoritesButton)
         view.addSubview(shareButton)
         view.addSubview(imageView)
         view.addSubview(titleLabel)
         view.addSubview(sourceImageView)
         view.addSubview(sourceLabel)
         view.addSubview(timeImageView)
         view.addSubview(timeLabel)
         view.addSubview(descriptionTextView)
         view.addSubview(webServiceButton)
         
         
         //not : Favorites butonu 10 br yer değiştir
         // SnapKit Constraints
         FavoritesButton.snp.makeConstraints { make in
             make.top.equalTo(view.frame.height/10)
             make.trailing.equalToSuperview().offset(-view.frame.width/15)
         }

         shareButton.snp.makeConstraints { make in
             make.top.equalTo(view.frame.height/10)
             make.trailing.equalTo(FavoritesButton.snp.leading).offset(-10)
         }

         imageView.snp.makeConstraints { make in
             make.top.equalTo(FavoritesButton.snp.bottom).offset(10)
             make.left.equalToSuperview().offset(20)
             make.width.equalTo(view.frame.width*9/10)
             make.height.equalTo(view.frame.height/3)
         }

         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(imageView.snp.bottom).offset(10)
             make.width.equalTo(view.frame.width*85/100)
             make.centerX.equalToSuperview()
         }

         sourceImageView.snp.makeConstraints { make in
             make.top.equalTo(titleLabel.snp.bottom).offset(10)
             make.left.equalTo(imageView)
             make.width.height.equalTo(20)
         }

         sourceLabel.snp.makeConstraints { make in
             
             make.top.equalTo(titleLabel.snp.bottom).offset(10)
             make.left.equalTo(sourceImageView.snp.right).offset(5)
             make.width.equalTo(view.frame.width*35/100)
         }

         timeImageView.snp.makeConstraints { make in
             make.centerY.equalTo(sourceImageView)
             make.left.equalTo(sourceLabel.snp.right).offset(10)
             make.width.height.equalTo(20)
         }

         timeLabel.snp.makeConstraints { make in
             make.top.equalTo(titleLabel.snp.bottom).offset(10)
             make.left.equalTo(timeImageView.snp.right).offset(5)
             make.width.equalTo(view.frame.width*35/100)
         }

         descriptionTextView.snp.makeConstraints { make in
             make.top.equalTo(sourceImageView.snp.bottom).offset(20)
             make.left.equalToSuperview().offset(20)
             make.right.equalToSuperview().offset(-20)
             make.bottom.equalTo(webServiceButton.snp.top).offset(-20)
         }

         webServiceButton.snp.makeConstraints { make in
             make.bottom.equalTo(-view.frame.height/8)
             make.centerX.equalToSuperview()
             make.width.equalTo(view.frame.width/2)
             make.height.equalTo(view.frame.height/25)
         }
     }
     
     //Favorites button operations
     @objc func FavoritesButtonTapped() {
         
         if favoritesisClicked == false {
             print("ilgili satır kaydedildi")
             // bu kısım ezber . her seferinde aynı.
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
             
             //context'in içine ne koyulucağını belirlemek için
             let newPainting = NSEntityDescription.insertNewObject(forEntityName: "AppcentData", into: context)
             
             
             //Attributes
               newPainting.setValue(UUID(), forKeyPath: "id")
               newPainting.setValue(true, forKey: "bool")
               newPainting.setValue(selectedNews?.source.name , forKey: "name")
               newPainting.setValue(selectedNews?.description , forKey: "descriptionNews")
               newPainting.setValue(selectedNews?.publishedAt , forKey: "publishedAt")
               newPainting.setValue(selectedNews?.title , forKey: "title")
               newPainting.setValue(selectedNews?.urlToImage, forKey: "urlToImage")
               newPainting.setValue(selectedNews?.url, forKey: "url")

             
             
             //verileri kaydetmek için
             do {
                 try context.save()
                 print("succes")
             } catch {
                 print("error")
             }
             
             
             //işim bittikten sonra favorites butonun image'sini değiştirmek için
             FavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
             favoritesisClicked = true
             
             //yeni eklenen verileri tableView'da görüntülemek için(devamı ViewController'da)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
             
         } else if favoritesisClicked == true {
             print("ilgili satır silindi")
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
             //fetchRessguest oluşturucaz. ve ilgili veriyi silicez
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppcentData")
             
             let idString = chosenPaintingId?.uuidString
             fetchRequest.predicate = NSPredicate(format: "id = %@",idString ?? "" )
             
             fetchRequest.returnsObjectsAsFaults = false
             
             do {
                 let results = try context.fetch(fetchRequest)
                 if results.count > 0 {
                     for result in results as! [NSManagedObject] {
                         if let id = result.value(forKey: "id") as? UUID {
                             if id == chosenPaintingId{
                                 context.delete(result)
                                
 //                                self.tableView.reloadData()
                                 let reloadData = true
                                 NotificationCenter.default.post(name: NSNotification.Name("Bool"), object: reloadData)


                                 
                                 
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
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             FavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
             favoritesisClicked = false
         }
         
       
         
     }
     
     //shared operations
     @objc func shareButtonTapped() {
         print("shareButtonTapped")
         
         guard let newURL = URL(string: selectedNews?.url ?? "") else {
             return
         }
         let objectsToShare: [Any] = [newURL]
         let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
         present(activityViewController, animated: true, completion: nil)
     }

     // go to Safari
     @objc func webServiceButtonTapped() {
         guard let newURL = URL(string: favoritesURL) else {
             return
         }
         let vc = SFSafariViewController(url: newURL)
         present(vc, animated: true)
     }
 }

 */
