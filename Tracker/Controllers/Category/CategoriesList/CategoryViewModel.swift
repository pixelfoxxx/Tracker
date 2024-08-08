//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 29/07/2024.
//

import Foundation

enum CategoryScreenState {
    case empty
    case categoriesList
}

protocol CategoryTableDataProtocol {
    var onDataChange: (CategoryScreenModel) -> Void { get set }
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func tableDataCell(indexPath: IndexPath) -> CategoryScreenModel.TableData.Cell
}

protocol CategoryViewModelProtocol: AnyObject, CategoryTableDataProtocol {
    var shouldShowBackgroundView: Bool { get }
    var state: CategoryScreenState? { get }
    var categoryIsChosen: (TrackerCategory) -> Void { get }
    func setup()
    func addCategory()
    func chooseCategory(index: Int)

}

final class CategoryViewModel {
    
    typealias TableData = CategoryScreenModel.TableData
    
    var state: CategoryScreenState?
    var onDataChange: (CategoryScreenModel) -> Void = { _ in }
    var categoryIsChosen: (TrackerCategory) -> Void
    var shouldShowBackgroundView: Bool {
        get {
            state == .empty
        }
    }
    
    private var router: CategoryRouterProtocol
    private var categories: [TrackerCategory]
    private var model: CategoryScreenModel = .empty {
        didSet {
            onDataChange(model)
        }
    }
    
    init(
        state: CategoryScreenState,
        categories: [TrackerCategory],
        router: CategoryRouterProtocol,
        categoryIsChosen: @escaping (TrackerCategory) -> Void
    ) {
        self.state = state
        self.categories = categories
        self.router = router
        self.categoryIsChosen = categoryIsChosen
    }
    
    private func buildScreenModel() -> CategoryScreenModel {
        return CategoryScreenModel(
            title: NSLocalizedString("Category", comment: ""),
            tableData: buildTableData(),
            buttonTitle: NSLocalizedString("Add category", comment: "")
        )
    }
    
    private func buildTableData() -> TableData {
        return TableData(sections: [
            buildCategoriesSection()
        ])
    }
    
    private func buildCategoriesSection() -> TableData.Section {
        .simpleSection( cells:categories.map { .labledCell(LabeledCellViewModel(title: $0.title, style: .leftSideTitle))})
    }

    private func updateModel() {
        self.model = buildScreenModel()
    }
}

extension CategoryViewModel: CategoryViewModelProtocol {
    func chooseCategory(index: Int) {
        let outputCategory = categories[index]
        categoryIsChosen(outputCategory)
    }
    
    
    func setup() {
        updateModel()
    }
    
    func addCategory() {
        router.showCreateCategoryController { [weak self] category in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.categories.append(category)
                self.state = self.categories.isEmpty ? .empty : .categoriesList
                self.updateModel()
            }
        }
    }
}

extension CategoryViewModel: CategoryTableDataProtocol {
    func numberOfSections() -> Int {
        return model.tableData.sections.count
    }
    
    func numberOfRows(section: Int) -> Int {
        switch model.tableData.sections[section] {
        case let .simpleSection(cells):
            return cells.count
        }
    }
    
    func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        switch model.tableData.sections[indexPath.section] {
        case let .simpleSection(cells):
            return cells[indexPath.row]
        }
    }
}
