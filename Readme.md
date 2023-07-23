# İçindekiler

1. [Giriş](#pattern-showcase)
2. [MVC 👉 Model + ViewController](#mvc--model--viewcontroller)
3. [MVVM 👉 Model + View + ViewModel](#mvvm--model--view--viewmodel)
4. [VIPER 👉 View + Interactor + Presenter + Entity + Router](#viper--view--interactor--presenter--entity--router)

# Giriş - Pattern Showcase

Bu projede, farklı tasarım desenlerini (MVC, MVVM ve VIPER) kullanarak, bir API'ye istek atan ve sonuçları listeleyen örnek bir uygulama geliştirilmiştir. Her bir tasarım deseni, uygulamanın bileşenlerini farklı şekillerde düzenleyerek, kodun daha modüler, sürdürülebilir ve test edilebilir olmasını sağlar. Bu sayede, farklı tasarım desenleriyle uygulamanın farklı yönlerini keşfetme ve kıyaslama imkanı elde edilir.

## MVC 👉 Model + ViewController

MVC (Model-ViewController) mimarisi kullanarak da örnek bir projeyi gerçekleştirebiliriz. MVC, iOS uygulama geliştirme sürecinde sıkça kullanılan bir mimaridir. Aşağıda, MVC mimarisine uygun bir örnek verilmiştir:

#### Model:

```swift
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
```

#### ViewController:

```swift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPosts()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                return
            }

            do {
                self?.posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}
```

Bu örnekte, MVC mimarisi kullanarak veriyi çekiyor ve tabloya listeleyen bir proje oluşturduk. MVC mimarisinde Model, View ve Controller (View Controller) kısımlarını temsil eden yapıyı kullandık. Verileri çekmek ve tabloyu güncellemek için Controller sınıfı (View Controller) kullanılırken, tabloyu listeleyen görsel arayüz View sınıfında tanımlandı ve Post modelini Model olarak tanımladık.

MVC, iOS geliştirmede yaygın bir kullanıma sahip olsa da, daha büyük projelerde bakım ve geliştirilebilirlik açısından bazı dezavantajları olabilir. Bu nedenle daha büyük ölçekli projelerde diğer mimarilerin kullanılması daha yaygın olabilir. Fakat küçük veya basit projeler için MVC hala tercih edilebilir bir seçenektir.

## MVVM 👉 Model + View + ViewModel

iOS için MVVM (Model-View-ViewModel), Model-View-Controller (MVC) tasarım desenine alternatif olarak kullanılan bir başka popüler tasarım desenidir. MVVM, uygulamanın bileşenlerini daha fazla ayrıştırarak, uygulama mantığı ve kullanıcı arayüzünün birbirinden daha bağımsız hale gelmesini sağlar.

MVVM deseni, View ve Model arasında direkt bağlantı olmadığından, kodun daha modüler ve daha kolay test edilebilir olmasını sağlar. Özellikle büyük ve karmaşık uygulamalar geliştirirken, MVVM tasarım deseni daha iyi bir alternatif olarak tercih edilebilir.

Örnek bir Swift projesi oluşturarak, "https://jsonplaceholder.typicode.com/posts" adresinden veriyi çekip listeleyen bir MVVM örneği verebilirim. Bu örnekte `URLSession` ile veri çekeceğiz ve çekilen verileri ViewModel aracılığıyla View'a aktaracağız.

#### Model:

Model, uygulamanın verilerini ve iş mantığını temsil eder, MVC'deki gibi bu katmanda değişiklik yapmaya gerek kalmaz. Genellikle sınıflar veya yapılar şeklinde uygulanır ve uygulamanın verilerini ve işlemlerini yönetir. Veri kaynaklarından veri almak, güncellemek ve işlemek için kullanılır.

```swift
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
```

#### View:

View, kullanıcı arayüzünü temsil eder, ancak MVVM'de biraz farklı bir rolü vardır. View, kullanıcıya görsel öğeleri (butonlar, etiketler, görüntüler vb.) gösterme sorumluluğunu taşır ve kullanıcı etkileşimlerini algılar. Ancak, View sadece görsel bileşenleri temsil eder, uygulama mantığını içermez.

```swift
import UIKit
 class ViewController: UIViewController {
     @IBOutlet weak var tableView: UITableView!

     private let viewModel = ViewModel()

     override func viewDidLoad() {
         super.viewDidLoad()

         viewModel.fetchPosts { [weak self] in
             self?.tableView.reloadData()
         }

         tableView.dataSource = self
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     }
 }

 extension ViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.numberOfPosts()
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         let post = viewModel.post(at: indexPath.row)
         cell.textLabel?.text = post.title
         return cell
     }
 }
```

#### ViewModel:

ViewModel, Model ve View arasında arabulucu görevi görür. View'e sunulacak verileri hazırlar ve View'in ihtiyaç duyduğu işlevleri sağlar. Modelin verilerini işleyerek, View'e sunulacak uygun bir sunum yapar. Ayrıca, kullanıcı etkileşimlerini algılayarak bu etkileşimlere uygun işlemleri gerçekleştirir. ViewModel, View'dan bağımsızdır ve bu sayede uygulamanın test edilebilirliğini ve sürdürülebilirliğini artırır.

```swift
import Foundation

class ViewModel {
     private var posts: [Post] = []

     func fetchPosts(completion: @escaping () -> Void) {
         guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
             return
         }

         URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
             guard let data = data, error == nil else {
                 return
             }

             do {
                 self?.posts = try JSONDecoder().decode([Post].self, from: data)
                 DispatchQueue.main.async {
                     completion()
                 }
             } catch {
                 print("Error decoding JSON: \(error)")
             }
         }.resume()
     }

     func numberOfPosts() -> Int {
         return posts.count
     }

     func post(at index: Int) -> Post {
         return posts[index]
     }
}
```

Bu örnekte, `Post` isimli basit bir model oluşturduk ve `ViewModel` adında bir ViewModel sınıfı tanımladık. ViewModel, veriyi çekmek için `URLSession` kullanıyor ve bu verileri `Post` modeli ile çözümlüyor. Ardından, `ViewController` adında bir View sınıfı oluşturduk ve bu sınıf, çekilen verileri ViewModel'den alarak tabloya listeledi.

Tablodaki hücreler, her bir gönderi başlığını içerir. Bu örnek, basit bir MVVM mimarisi kullanarak veri çekme ve tablo listeleme işlemlerini gerçekleştirir. Bu temel örnek üzerinden projenizi geliştirebilir ve özelleştirebilirsiniz.

## VIPER 👉 View + Interactor + Presenter + Entity + Router

Viper mimarisi, iOS uygulamalarının katmanlı bir yapıda geliştirilmesine olanak tanıyan popüler bir tasarım desenidir. Viper mimarisi, uygulamayı beş ana bileşene böler: View, Interactor, Presenter, Entity ve Router. Bu bileşenler, uygulamanın temel mantığını ve işlevselliğini birbirinden bağımsız şekilde ele alır.

#### View:
View, kullanıcı arayüzünü temsil eder ve görsel bileşenleri (UI elemanları) oluşturur. Kullanıcı arayüzündeki etkileşimleri algılar ve bu etkileşimleri Presenter'a aktarır. View, sadece kullanıcı arayüzünün oluşturulmasından ve güncellenmesinden sorumludur. İş mantığını içermez.

```swift
import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var presenter: Presenter!
    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter = Presenter()
        presenter.delegate = self
        presenter.fetchPosts()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension ViewController: PresenterDelegate {
    func showPosts(posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }

    func showError() {
        // Handle error display here
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}
```

#### Interactor:

Interactor, uygulamanın iş mantığını ve veri işleme işlemlerini yönetir. Model katmanına karşılık gelir ve verilerin alınması, işlenmesi ve gerektiğinde sunucuyla iletişim kurulması gibi işlemleri gerçekleştirir. Interactor, Presenter'dan gelen komutları yerine getirir ve sonuçları Presenter'a iletir.

```swift
import Foundation

protocol InteractorDelegate: AnyObject {
    func postsFetched(posts: [Post])
    func onError()
}

class Interactor {
    weak var delegate: InteractorDelegate?

    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            delegate?.onError()
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                self.delegate?.onError()
                return
            }

            if let data = data {
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.postsFetched(posts: posts)
                    }
                } catch {
                    print("Error decoding posts: \(error)")
                    DispatchQueue.main.async {
                        self.delegate?.onError()
                    }
                }
            }
        }.resume()
    }
}

```

#### Presenter:

Presenter, View ve Interactor arasında arabulucu rolü üstlenir. View'dan gelen etkileşimleri alır ve gerekli işlemleri yapmak için Interactor ile iletişime geçer. Sonuçları View'a sunmak için gerekli verileri hazırlar. Presenter, View'dan bağımsızdır ve bu sayede uygulamanın test edilebilirliğini artırır.

```swift
import Foundation

protocol PresenterDelegate: AnyObject {
    func showPosts(posts: [Post])
    func showError()
}

class Presenter {
    weak var delegate: PresenterDelegate?
    private let interactor = Interactor()

    func fetchPosts() {
        interactor.delegate = self
        interactor.fetchPosts()
    }
}

extension Presenter: InteractorDelegate {
    func postsFetched(posts: [Post]) {
        delegate?.showPosts(posts: posts)
    }

    func onError() {
        delegate?.showError()
    }
}

```

#### Entity:

Entity, veri modellerini ve uygulamanın temel veri yapısını temsil eder. Genellikle Interactor tarafından kullanılır ve veri işleme işlemleri için kullanılır.

```swift
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
```

#### Router

Router, uygulama ekranları arasında gezinmeyi yönetir ve bu sayede bağımlılıkları azaltır. Uygulamanın hangi ekranın nereden açılacağı ve kapanacağı gibi navigasyon işlemleri Router katmanında yer alır.

```swift
class Router {
    static func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        return viewController
    }
}

```

Bu örnek, temel bir Viper yapıya sahip basit bir iOS uygulamasını göstermektedir. Uygulama, URL'den veri çekerek bu verileri bir tablo aracılığıyla listeleyecektir.

VIPER, uygulamanın farklı katmanlarını bağımsız hale getirerek, değişiklikleri kolayca yönetilebilir ve parçaların daha iyi anlaşılabilir olmasını sağlar. Bu modüler yapısı sayesinde, farklı ekiplerin ve geliştiricilerin birlikte çalışması ve proje üzerinde verimli bir şekilde işbirliği yapması kolaylaşır. Ancak, VIPER tasarım deseni, basit projelerde kullanımı biraz karmaşık olabilir ve daha büyük, ölçeklenebilir uygulamalar için daha uygundur.
