# Tip-Calculator

### Description

Compute your tip effortlessly by entering the bill amount. The application provides a breakdown of your tip, the total tip amount, and the original bill. Additionally, you can save the bill for future reference and delete it as needed.

<p align="center">
<img src="/img/one.png" width="250"> <img src="/img/two.png" width="250"> <img src="/img/three.png" width="250">
</p>

#### Description of the project:

- ```Xcode``` & ```UIKit``` for autolayout

- Persist data with ```Core Data``` when saving some numbers
    ```swift
        private func saveToDB(input: String, tip: String, total: String, splitTotal: String?, splitPeopleQuantity: String?) { ... }
    ```

- ```MVVM``` as Architecture structure
- ```protocols```and```delegate```
    <strong>_Calculating data_</strong>
    ```swift
    protocol ViewModelBillCalculationsProtocol {
        func calculateTip(with valueInput: UITextField, segment: UISegmentedControl, tipValue: UILabel, totalValue: UILabel)
        func reset(valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, totalByPerson: UILabel, peopleQuantity: UILabel)
        func splitBiil(people: UILabel, bill: Double, totalByPerson: UILabel)
    }
    ```
    ```swift
    final class CalculationsViewModel: ViewModelBillCalculationsProtocol { ... }
    ```
    <strong>_Saving data_</strong>
    ```swift
    protocol ViewModelBillImplementationProtocol {
        func fetchItems()
        func save(_ vc: UIViewController, valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, splitTotal: UILabel?, splitPeopleQuantity: UILabel?)
    }
    ```
    ```swift
    final class SaveViewModel: ViewModelBillImplementationProtocol { ... }
    ```
- ```SwiftUI``` preview implemented for ```UIViewController``` and ```UIVIew```
    ```swift
    struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
        let viewController: ViewController
    
        init(with builder: @escaping() -> ViewController) {
            self.viewController = builder()
        }
    
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
    ```
    ```swift
    struct UIViewPreview<View: UIView>: UIViewRepresentable {
   
        let view: View
        
        init(with builder: @escaping() -> View) {
            self.view = builder()
        }
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) { }
    }
    ```
- Accessibility

- Localized language

- No Modularity (coming soon)

- ```Unit Testing``` 

 _Build <strong>GitHub</strong> CI/CD_

#### Launch :rocket:
- First release on early 2017

- Second release on later 2019

- Third release on 2023

[Tip Calculator](https://itunes.apple.com/us/app/my-new-news/id1210234219?mt=8).

#### Media
- [LinkedIn](https://www.linkedin.com/in/israel-manzo/) 
- [Twitter](https://twitter.com/israman30)

_Copyright &copy; 2023, Israel Manzo_
