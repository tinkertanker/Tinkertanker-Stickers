//
//  ViewController.swift
//  TT Stickers
//
//  Created by JiaChen(: on 3/2/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var stickerPack: StickerPack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try StickerPackManager.fetchStickerPacks(fromJSON: StickerPackManager.stickersJSON(contentsOfFile: "sticker_packs")) { stickerPacks in
                
                self.stickerPack = stickerPacks.first
                self.collectionView.reloadData()
            }
        } catch StickerPackError.fileNotFound {
            fatalError("sticker_packs.wasticker not found.")
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @IBAction func addToWhatsApp(_ sender: Any) {
        stickerPack!.sendToWhatsApp { completed in
            print("yay")
        }
    }
    
    @IBAction func addToTelegram(_ sender: Any) {
        let telegramURL = URL(string: "https://t.me/addstickers/Tinkertanker")!
        
        UIApplication.shared.open(telegramURL)
    }
    
    @IBAction func addToMessages(_ sender: Any) {
        let telegramURL = URL(string: "sms:")!
        
        UIApplication.shared.open(telegramURL)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let sticker = stickerPack?.stickers[indexPath.row],
           let image = sticker.imageData.image,
           let imageView = cell.contentView.subviews.first as? UIImageView,
           let label = cell.contentView.subviews.last as? UILabel {
            imageView.image = image
            label.text = (sticker.emojis ?? []).joined(separator: " • ")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerPack?.stickers.count ?? 0
    }
    
}
