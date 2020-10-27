//
//  PicturePublisher.swift
//  Previando
//
//  Created by Franco Consoni on 01/10/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation

protocol PhotoPublisher: class {
    var picture: Either<String, UIImage?> { get set }
    var subscribers: [Weak<PhotoSubscriber>] { get set }
}

protocol PhotoSubscriber {
    func receive(_ image: UIImage?)
}

extension PhotoPublisher {
    func subscribeToPhoto(_ subscriber: PhotoSubscriber) {
        if let photo = picture.right {
            subscriber.receive(photo)
        } else {
            self.subscribers.append(Weak(subscriber))
            
            self.downloadPicture()
        }    
    }
    
    func desubscribe<T: PhotoSubscriber & Equatable>(_ subscriber: T) {
        let equatableSubscribers: [Weak<T>] = self.subscribers.filter{ $0.value! is T }.compactMap(\.value).map{ $0 as! T }.map(Weak.init)
        let subscribersWithoutDesubs: [Weak<PhotoSubscriber>] = equatableSubscribers.filter(fold(false, not << equalTo(subscriber)) << \.value).compactMap{ $0 as? PhotoSubscriber }.map(Weak.init)
        
        self.subscribers = self.subscribers.filter(not << { $0.value! is T }) + subscribersWithoutDesubs
    }
    
    private func downloadPicture() {
        if self.subscribers.count == 1, let url = URL(string: self.picture.left ?? "") {
            ImageDownloaderManager.shared.downloadImage(from: url, onCompletionDo: { image in
                self.picture = .right(image)
                
                self.publish(image)
            })
        }
    }

    private func publish(_ picture: UIImage?) {
        self.subscribers.map(\.value).forEach { $0?.receive(picture) }
        self.subscribers = []
    }
}

infix operator <<: CompositionPrecedence
