//
//  NibIdentifiable.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit

///nib id 协议
protocol NibIdentifiable {
    static var nibIdentifier: String { get }
}

///扩展这个协议
extension NibIdentifiable {
    
    static var nib: UINib {
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
    
}

///为UIView扩展这个协议
extension UIView: NibIdentifiable {
    
    static var nibIdentifier: String {
        return String(describing: self)
    }
    
}

///为UIViewController扩展这个协议
extension UIViewController: NibIdentifiable {
    
    static var nibIdentifier: String {
        return String(describing: self)
    }
    
}

///只扩展给UIView
extension NibIdentifiable where Self: UIView {
    
    static func instantiateFromNib() -> Self {
        guard let view = UINib(nibName: nibIdentifier, bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? Self 
            else { fatalError("Couldn't find nib file for \(String(describing: Self.self))") }
        return view
    }
    
}

///只扩展给UIViewController
extension NibIdentifiable where Self: UIViewController {
    
    static func instantiateFromNib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }
    
}

extension NibIdentifiable where Self: UITableView {
    
    static func instantiateFromNib() -> Self {
        guard let tableView = UINib(nibName: nibIdentifier, bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? Self 
            else { fatalError("Couldn't find nib file for \(String(describing: Self.self))") }
        return tableView
    }
    
}

extension NibIdentifiable where Self: UITableViewController {
    
    static func instantiateFromNib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }
    
}

extension UITableView {
    
    func registerCell<T: UITableViewCell>(type: T.Type) {
        register(T.nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) {
        register(type.nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T 
            else { fatalError("Couldn't find nib file for \(String(describing: T.self))") } 
        return cell
    }
    
    func dequeueResuableCell<T: UITableViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
            else { fatalError("Couldn't find nib file for \(String(describing: T.self))") }
        return cell
    }
    
    func dequeueResuableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) -> T {
        guard let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T 
            else { fatalError("Couldn't find nib file for \(String(describing: T.self))") }
        return headerFooterView
    }
    
}

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        register(type.nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Couldn't find nib file for \(String(describing: T.self))")
        }
        return cell
    }
    
}
