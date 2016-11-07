//
//  ViewController.swift
//  CoreDataSample001
//
//  Created by Shinya Hirai on 2015/10/29.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // CoreDataのTodo Entityに接続し、情報を取得する
        // データの読み込みなので、read()を用意して呼び出す形で作成
        read()
    }

    // すでに存在するデータの読み込み処理
    func read() {
        // AppDeleteをコードで読み込む
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            // Entityを指定する設定
            let entityDiscription = NSEntityDescription.entity(forEntityName: "Todo", in: managedObjectContext)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            fetchRequest.entity = entityDiscription
            
            // errorが発生した際にキャッチするための変数
            var error: NSError? = nil
            
            // フェッチリクエスト (データの検索と取得処理) の実行
            do {
                let results = try managedObjectContext.fetch(fetchRequest)
                print(results.count)
                for managedObject in results {
                    let todo = managedObject as! Todo
                    print("title: \(todo.title), saveDate: \(todo.saveDate)")
                }
            } catch let error1 as NSError {
                error = error1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapSaveBtn(_ sender: AnyObject) {
        // AppDeleteをコードで読み込む
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            // 新しくデータを追加するためのEntityを作成します
            let managedObject: AnyObject = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: managedObjectContext)
            
            // Todo EntityからObjectを生成し、Attributesに接続して値を代入
            let todo = managedObject as! Todo
            todo.title = "hogehoge"
            todo.saveDate = Date() // NSDate()は現在の日時を返します。
            
            // ※※※ データの保存 ※※※
            // CoreDataは少し特殊で上記でAttributesにデータを追加するだけではすぐに保存処理はされません。
            // 一定期間おいて保存されるか、アプリを終了時にAppDelegateに定義してある
            // applicationWillTerminate()内のsaveContext()が発動した際に保存処理が実行されます。
            // よくCoreDataを使用していてあるのはこれを忘れていてデータの書き込み処理は正常に動作しているのに保存がなぜかされない！どうしよう！あぁ〜もう！ってなることがあります。
            
            // データの保存処理
            appDelegate.saveContext() // ←←← これ重要
            
        }
    }
    
    
    @IBAction func tapDeleteBtn(_ sender: AnyObject) {
        // AppDeleteをコードで読み込む
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appDelegate.managedObjectContext {
            // Entityを指定する設定
            let entityDiscription = NSEntityDescription.entity(forEntityName: "Todo", in: managedObjectContext)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            fetchRequest.entity = entityDiscription
            
            // データを一件取得する
            let predicate = NSPredicate(format: "%K = %@", "title", "hogehoge")
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil
            
            // フェッチリクエストの実行
            do {
                let results = try managedObjectContext.fetch(fetchRequest)
                print(results.count)
                
                for managedObject in results {
                    let todo = managedObject as! Todo
                    print("削除するデータ => title: \(todo.title), saveDate: \(todo.saveDate)")
                    
                    // 削除処理の本体
                    managedObjectContext.delete(managedObject as! NSManagedObject)
                    
                    // 削除したことも保存しておかないと反映されないので注意!!!
                    appDelegate.saveContext()
                }
            } catch let error1 as NSError {
                error = error1
            }
        }
    }

}







