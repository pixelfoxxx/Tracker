//
//  CategoryPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation

enum CategoryScreenState {
    case empty
    case categoriesList
}

protocol CategoryPresenterProtocol: AnyObject {
    var shouldShowBackgroundView: Bool { get }
    var state: CategoryScreenState? { get }
    var categoryIsChosen: (TrackerCategory) -> Void { get }
    func setup()
    func addCategory()
    func chooseCategory(index: Int)
}

final class CategoryPresenter {
    
    var state: CategoryScreenState?
    private weak var view: CategoryViewProtocol?
    private var router: CategoryRouterProtocol
    private var categories: [TrackerCategory]

    var shouldShowBackgroundView: Bool {
        get {
            state == .empty
        }
    }
    
    var categoryIsChosen: (TrackerCategory) -> Void
    
    init(
        view: CategoryViewProtocol,
        state: CategoryScreenState,
        categories: [TrackerCategory],
        router: CategoryRouterProtocol,
        categoryIsChosen: @escaping (TrackerCategory) -> Void
    ) {
        self.view = view
        self.state = state
        self.categories = categories
        self.router = router
        self.categoryIsChosen = categoryIsChosen
    }
    
    private func buildScreenModel() -> CategoryScreenModel {
        return CategoryScreenModel(
            title: "Категория",
            tableData: buildTableData(),
            buttonTitle: "Добавить категорию"
        )
    }
    
    private func buildTableData() -> CategoryScreenModel.TableData {
        return CategoryScreenModel.TableData(sections: [
            buildCategoriesSection()
        ])
    }
    
    private func buildCategoriesSection() -> CategoryScreenModel.TableData.Section {
        .simpleSection( cells:categories.map { .labledCell(LabeledCellViewModel(title: $0.title, style: .leftSideTitle))})
    }

    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension CategoryPresenter: CategoryPresenterProtocol {
    func chooseCategory(index: Int) {
        let outputCategory = categories[index]
        categoryIsChosen(outputCategory)
    }
    
    
    func setup() {
        render()
    }
    
    func addCategory() {
        router.showCreateCategoryController { [weak self] category in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.categories.append(category)
                self.state = self.categories.isEmpty ? .empty : .categoriesList
                self.render()
            }
        }
    }
}
