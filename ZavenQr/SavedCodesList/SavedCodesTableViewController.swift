//
//  SavedCodesTableViewController.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import UIKit
import RxSwift

class SavedCodesTableViewController: UITableViewController {
    private let savedImagesViewModel: SavedImagesViewModel
    private let disposeBag = DisposeBag()

    var coordinator: SavedImagesCoordinator?

    init(savedImagesViewModel: SavedImagesViewModel) {
        self.savedImagesViewModel = savedImagesViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        bindTableView()
    }

    private func bindTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        savedImagesViewModel.images
              .bind(to: tableView.rx.items) { _, _, item in
                  let cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")
                  cell.textLabel?.text = item.searchedPhrase
                  let dateformater = DateFormatter()
                  dateformater.dateFormat = "dd.MM.yyyy"
                  cell.detailTextLabel?.text = dateformater.string(from: item.creationDate)
                  cell.detailTextLabel?.textColor = .black
                  return cell
              }
              .disposed(by: disposeBag)

        tableView.rx.modelSelected(SearchResultEntity.self).subscribe(onNext: { [weak self] item in
            self?.coordinator?.showResultView(mode: item)
        }).disposed(by: disposeBag)

        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] item in
            self?.savedImagesViewModel.deleteImage(index: item.row)
        }).disposed(by: disposeBag)

        savedImagesViewModel.fetchImages()
    }

    private func prepareView() {
        self.title = "Saved images"
        navigationController?.isNavigationBarHidden = false
    }
}
