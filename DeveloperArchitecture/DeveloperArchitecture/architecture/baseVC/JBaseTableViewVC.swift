//
//  JBaseTableViewVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

typealias kreloadToSolveDataCallback = ((_ isHead : Bool , _ type : String , _ page : Int) -> ())

let kCellIndentifier = "cellIndentifier"

class JBaseTableViewVC : JBaseViewController, JSearchBarDelegate, UITableViewDelegate,UITableViewDataSource {
    lazy var m_topView : UIView = {
        let topView = UIView(i: CGRect(x: 0, y: 0, width: kWidth, height: 0), bg: kColor_White_Dark)
        self.view.addSubview(topView)
        m_topTableViewLine = UIImageView(i_line: CGRect(x: 0, y: 0, width: kWidth, height: 1))
        topView.addSubview(m_topTableViewLine!)
        return topView
    }()
    var m_topTableViewLine : UIView?
    var m_blackImageView : UIImageView?
    var m_isCanDeleteTableItem : Bool  = false
    var m_isReloadNewDataing : Bool = false
    
    lazy var m_dataArr : [Any] = { return [] }()
    private lazy var m_saveQuestionHeightDic : [String : CGFloat] = { return [:] } ()
    
    var m_currentPageType : String = "default" { // 多种类型数据
        willSet {
            let tableView = self.funj_getTabeleView()
            tableView?.funj_setCurrentPageType(newValue)
        }
    }
    
    lazy var m_searchBar : JSearchBar = {
        let searchBar = JSearchBar(frame: CGRect(x: 0, y: 0, width: kWidth, height: 37))
        searchBar.m_searchDelegate = self
        searchBar.m_filletValue = JFilletValue(w: 0.5, r: 37/2, c: kColor_Line_Gray_Dark)
        searchBar.isHidden = true
        searchBar.funj_reloadSearchState(needIcon: true, needCancel: true)
        m_topView.addSubview(searchBar)
        
        m_blackImageView = UIImageView(i_blackAlpha: CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        m_blackImageView?.isHidden = true
        self.view.addSubview(m_blackImageView!)
        m_blackImageView?.funj_whenLongPressed({ (view) in
            self.m_searchBar.endEditing(true)
            self.funj_searchBarState(false)
        })
        self.view.addSubview(m_blackImageView!)
        return searchBar
    }()
    lazy var m_tableView : UITableView = {
        let tableView =  kcreateTableViewWithDelegate(self)
        return tableView
    }()
    lazy var m_defaultImageView : UIImageView = {
        let defaultImageView = UIImageView(i: CGRectZero, image: "uu_tableview_default_icon")
        let contentLabel = UILabel(i: CGRect(x: 0, y: 0, width: 200, height: 20), title: "Here is a wilderness ...Nothing left", textFC: JTextFC(f: kFont_Size17, c: kColor_Text_GRAY_Dark, a: .center))
        defaultImageView.addSubview(contentLabel)
        contentLabel.tag = 9993
        return defaultImageView
    }()
    var m_reloadTableViewCallback : kreloadToSolveDataCallback?
    
    func funj_getTabeleView() -> UIScrollView? {
        if self is JBaseCollectionVC {
            let collectionView =  self.value(forKeyPath: "m_collectionView") as? UIScrollView
            return collectionView
        } else {
            return m_tableView
        }
    }
}
extension JBaseTableViewVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        m_defaultImageView.isHidden = self.m_tableView.visibleCells.count > 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isKind(of: JBaseCollectionVC.self) == false {
            self.view.addSubview(self.m_tableView)
        }
    }
}

extension JBaseTableViewVC {
    func funj_reloadData() {
        let tableView = self.funj_getTabeleView()
        (tableView as? UITableView)?.reloadData()
        (tableView as? UICollectionView)?.reloadData()
    }

    func funj_reloadTableView(_ topViewFrame : CGRect , table tableViewFrame : CGRect , isHidden searchBarHidden : Bool = true){
        if topViewFrame != CGRectZero {
            m_topView.frame = topViewFrame
            m_topTableViewLine?.frame = CGRect(x: m_topTableViewLine!.left, y: m_topView.height - 1, width: m_topView.width, height: m_topTableViewLine!.height)
        }
        let tableView = self.funj_getTabeleView()
        tableView?.frame = tableViewFrame
        
        if searchBarHidden == false {
            m_searchBar.isHidden = searchBarHidden
            m_searchBar.width = topViewFrame.width
            let point = self.view.convert(m_searchBar.origin, from: m_searchBar)
            m_blackImageView?.frame = CGRect(x: m_blackImageView!.left, y: point.y + m_searchBar.height, width: m_topView.width, height: tableViewFrame.height + (tableViewFrame.origin.y - (m_topTableViewLine?.top ?? 0)))
        }
        
        let width : CGFloat = kis_IPad ? 300.0 : 200.0 ;
        m_defaultImageView.frame = CGRect(x: (tableViewFrame.width - width)/2 , y: max(tableViewFrame.height/2 - width/2 - 60, 0), width: width, height: width)
        let contentLabel = m_defaultImageView.viewWithTag(9993)
        contentLabel?.frame = CGRect(x: (m_defaultImageView.width - (tableView?.width ?? 0))/2, y: m_defaultImageView.height + 10, width: tableView?.width ?? 0, height: 20)
        tableView?.addSubview(m_defaultImageView)
    }
    func funj_addLoadingCallback(_ callback : @escaping kreloadToSolveDataCallback){
        self.m_reloadTableViewCallback = callback
        let tableview = self.funj_getTabeleView()
        tableview?.funj_addHeader(callback: { [weak self] (type , page) in
            self?.m_isReloadNewDataing = true
            self?.m_reloadTableViewCallback?(true , type , page )
        })
        tableview?.funj_addFooter(callback: { [weak self] (type , page) in
            self?.m_isReloadNewDataing = false
            self?.m_reloadTableViewCallback?(false , type , page )
        })
    }
}

extension JBaseTableViewVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_dataArr.count
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableviewCell = tableView.dequeueReusableCell(withIdentifier: kCellIndentifier)
        tableviewCell?.backgroundColor = krandomColor
        return tableviewCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension JBaseTableViewVC {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.m_isCanDeleteTableItem
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        var result : UITableViewCell.EditingStyle = .none
        if tableView == m_tableView {
            result = .delete
        }
        return result
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        m_tableView.setEditing(editing, animated: animated)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return kLocalStr("Delete")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = JAppViewTools.funj_showAlertBlock(nil, message: kLocalStr("Do you want to delete? "), buttonArr: [kLocalStr("Cancel"),kLocalStr("Confirm")]) { (index) in
                
            }
        }
    }
}

extension JBaseTableViewVC {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        m_defaultImageView.isHidden = true
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        m_defaultImageView.isHidden = true
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        m_defaultImageView.isHidden = true
    }
}

extension JBaseTableViewVC {
    func funj_addCellCallbackHeight(cell : JBaseTableViewCell , idKey : String) {
        cell.m_callback = { [weak self ](idKey, height) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let height1 = self?.m_saveQuestionHeightDic[idKey] , height1 != height {
                    self?.m_saveQuestionHeightDic[idKey] = height
                }
            }
        }
    }

    func funj_solverToSubRepeatData<T : JBaseDataModel>(data : [Any] , targeArr : inout [Any]? , key : String , model : T? = nil) {
        var array : [Any] = []
        if targeArr == nil {
            targeArr = m_dataArr
        }

        if m_isReloadNewDataing {
            targeArr?.removeAll()
            self.funj_reloadData()
        }
        
        for obj in targeArr! {
            array.append(obj)
        }
        
        if model == nil {
            for obj in data {
                var isHas = NSNotFound ; var index = 0
                for obj2 in array {
                    if let obj = obj as? [String : Any] , let value = obj[key] as? String {
                        if let obj2 = obj2 as? [String : Any] , let value2 = obj2[key] as? String , value == value2 {
                            isHas = index ; break
                        }
                    }
                    index += 1
                }
                if isHas == NSNotFound {
                    array.append(obj)
                } else {
                    if isHas < array.count {
                        array.insert(obj, at: isHas)
                    } else {
                        array.append(obj)
                    }
                    array.remove(at: isHas + 1)
                }
            }
        } else {
            for obj in data {
                var isHas = NSNotFound ; var index : Int = 0
                for obj2 in array {
                    
                    if let obj = obj as? T , let value = obj.value(forKey: key) {
                        if let obj2 = obj2 as? T , let value2 = obj2.value(forKey: key){
                            if let value = value as? String , let value2 = value2 as? String , value == value2 {
                                isHas = index ; break
                            } else {
//                                assert(1 != 1, " repeat data ")
//                                isHas = index ; break
                            }
                        }
                    }
                    index += 1
                }
                if isHas == NSNotFound {
                    array.append(obj)
                } else {
                    if isHas < array.count {
                        array.insert(obj, at: isHas)
                    } else {
                        array.append(obj)
                    }
                    array.remove(at: isHas + 1)
                }
            }
        }
        targeArr?.removeAll()
        for obj in array {
            targeArr?.append(obj)
        }
        m_defaultImageView.isHidden = targeArr?.count ?? 0 > 0
        self.funj_reloadData()
    }
}
//MARK JsearchBar delegate
extension JBaseTableViewVC {
    func funj_searchShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count ?? 0 <= 0 {
            funj_searchBarState(true)
        } else {
            funj_searchBarState(false)
        }
        return true
    }
    func funj_search(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        var isShow = true
        if range.length <= 0 { isShow = false }
        if range.length >= 1 {
            if textField.text?.count ?? 0 > 1 { isShow = false}
            else  if string.count > 0{
                if textField.text?.hasSuffix(string) ?? false == false{
                    isShow = false
                }
            }
        }
        funj_searchBarState(isShow)
        return true
    }
    func funj_searchDidEndEditing(_ textField: UITextField) {
        funj_searchBarState(false)
        funj_reloadData()
    }
    func funj_searchReturnButtonClicked(_ textField: UITextField) -> Bool {
        funj_searchBarState(false)
        self.view.endEditing(true)
        return true
    }
    func funj_searchCancelButtonClicked(_ textField: UITextField) {
        funj_searchBarState(false)
        self.view.endEditing(true)
    }
    func funj_searchBarState(_ isshowBlack : Bool) {
        m_blackImageView?.isHidden = !isshowBlack
    }
}

func kcreateTableViewWithDelegate(_ delegate : AnyObject) -> UITableView {
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight), style: .plain)
    tableView.tag = 939003
    tableView.backgroundColor = UIColor.clear
    tableView.rowHeight = 100
    tableView.showsVerticalScrollIndicator = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.delegate = (delegate as? UITableViewDelegate)
    tableView.dataSource = (delegate as? UITableViewDataSource)
    tableView.separatorStyle = .none
    tableView.register(JBaseTableViewCell.self, forCellReuseIdentifier: kCellIndentifier)
    if #available(iOS 11.0, *) {
        tableView.contentInsetAdjustmentBehavior = .never
    }
    return tableView
}





