//
//  CreateCategoryPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation

protocol CreateCategoryPresenterProtocol: AnyObject {
    var isSaveEnabled: Bool { get }
    func saveCategory()
    func setup()
}

final class CreateCategoryPresenter: CreateCategoryPresenterProtocol {
    
    weak var view: CreateCategoryViewProtocol?
    
    var onSave: (TrackerCategory) -> Void
    
    private var categoryStore = TrackerCategoryStore()
    
    private var enteredCategoryName: String = "" {
        didSet { updateSaveButtonState() }
    }
    
    var isSaveEnabled: Bool {
        !enteredCategoryName.isEmpty
    }
    
    init(
        view: CreateCategoryViewProtocol,
        onSave: @escaping (TrackerCategory) -> Void)
    {
        self.view = view
        self.onSave = onSave
    }
    
    func setup() {
        render()
    }
    
    func saveCategory() {
        let category = TrackerCategory(id: UUID(), title: enteredCategoryName)
        
        do {
            try categoryStore.createCategory(with: category)
        } catch {
            view?.updateSaveButton(isEnabled: true)
            print("❌❌❌ Не удалось преобразовать TrackerCategory в TrackerCategoryCoreData")
        }
        
        onSave(category)
    }
    
    private func buildScreenModel() -> CreateCategoryScreenModel {
        return CreateCategoryScreenModel(
            title: NSLocalizedString("New category", comment: ""),
            tableData: CreateCategoryScreenModel.TableData(sections: [
                .simple(cells: [
                    .textFieldCell(TextFieldCellViewModel(
                        placeholderText: NSLocalizedString("Enter the category name", comment: ""),
                        inputText: enteredCategoryName,
                        textDidChanged: { [ weak self ] categoryName in
                            guard let self else { return }
                            self.enteredCategoryName = categoryName
                        }))
                ])
            ]),
            doneButtonTitle: NSLocalizedString("Done", comment: ""))
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
    
    private func updateSaveButtonState() {
        view?.updateSaveButton(isEnabled: isSaveEnabled)
    }
}
