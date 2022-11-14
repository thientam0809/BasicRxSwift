**ERROR HANDLE IN RXSWIFT**

## 1. Managing errors

Error là một thứ không thể tránh khỏi trong bất kì cái app nào.Thật không may, không một ai có thể đảm bảo một app sẽ không bao giờ có lỗi, vì vậy chúng ta sẽ luôn luôn cần handle cho một số trường hợp lỗi.

Một số lỗi thường xảy ra trong một ứng dụng:

- **No internet connection**: Đây là lỗi rất phổ biến. Nếu ứng dụng cần internet kết nối trở lại để retry và xử lí data của nó. nhưng device hiện tại lại offline, bạn phải detect nó và xử lí phù hợp.
- **Invalid input:** Thỉnh thoảng bạn sẽ cần một số input nhất định nhưng user lại nhập không đúng yêu cầu. Ví dụ bạn cần user nhập đầy đủ số điện thoại, nhưng user lại nhập chữ cái thay vì số.
- **API error or HTTP error:** Error từ API nó rất nhiều và phong phú. Nó có thể đến từ "**standard HTTP error**" (code từ 400 đến 500) hoặc error trong response, ví dụ sử dụng status field trong JSON response.

Trong RxSwift, error handling là một phần của framework. Tất cả opetators đều có closure, RxSwift biến đổi bất kì lỗi nào trong closure thành **error event** và nó sẽ chấm dứt observable. **Error event** này là một thứ mà bạn có thể catch and act (bắt và thực hiện). Nó có 2 cách:

- **Catch:** Phục hồi, tái tạo từ error với giá trị mặc định.
  ![Screenshot 2022-11-12 at 10.18.01](/Users/tam.nguyen7/Library/Application Support/typora-user-images/Screenshot 2022-11-12 at 10.18.01.png)
- **Retry:**
  ![Screenshot 2022-11-12 at 10.19.40](/Users/tam.nguyen7/Library/Application Support/typora-user-images/Screenshot 2022-11-12 at 10.19.40.png)

Trước giờ các bạn sử dụng **catchErrorJustReturn** để trả về một dummy, nhưng đó không phải **real error handling**.

## 2.  Throwing errors

```swift
    public func data(request: URLRequest) -> Observable<Data> {
        return self.response(request: request).map { pair -> Data in
            if 200 ..< 300 ~= pair.0.statusCode {
                return pair.1
            }
            else {
                throw RxCocoaURLError.httpRequestFailed(response: pair.0, data: pair.1)
            }
        }
    }
```

Đây là một hàm trong RxCocoa wrapper ở trong **URLSession+Rx.swift**. Hàm này trả về một observable type Data. Điều quan trọng là có return về một error. Từ đây có thể thấy được cách observable có thể phát ra lỗi, và đặc biệt ta có thể custom error được.

## 3. Handle errors with catch

Sau khi biết ném lỗi (throw errors) như thế nào rồi thì bây giờ chúng ta handle error. Cách cơ bản nhất là sử dụng **"catch"**.

Catch nó hoạt động do-try-catch như swift thuần. Nếu bất cứ thứ gì nó không đúng, lỗi bạn sẽ return một event mà nó sẽ wrap an error.
Trong RxSwift có 2 operator để catch error. 

Đầu tiên là:

```swift
func catchError(_ handler:) -> RxSwift.Observable<Self.E>
```

Đây là hàm cơ bản nhất, nó để closure như một param và cho phép return một observable khác. Nếu không thể hình dung được nơi mà bạn sử dụng cái này, thì a nghĩ đến caching **strategy**, cái này nó sẽ return một cached value nếu observable phát ra lỗi.

![Screenshot 2022-11-12 at 10.59.45](/Users/tam.nguyen7/Library/Application Support/typora-user-images/Screenshot 2022-11-12 at 10.59.45.png)

catchError trong trườn hợp này sẽ return những giá trị mà nó tồn tại trước đó và một vài lí do nào đó nó hiện tại nó không có.

Thứ 2 là:

```swift
func catchErrorJustReturn(_ element:) -> RxSwift.Observable<Self.E>
```

Cái này nó lơ, bỏ qua error và chỉ return một giá trị define. Cách này nó hạn chế hơn nhiều so với cái thứ nhất vì nó không thể return một giá trị cho từng loại error, còn cái kia nó return cho bất kì cái lỗi nào, không quan tâm là lỗi gì.

## 4. A common pitfall

Khi mà observable phát ra lỗi thì observable cần thiết phải kết thúc và bất kì các event sau khi error sẽ bị lơ đi.![Screenshot 2022-11-12 at 11.18.14](/Users/tam.nguyen7/Library/Application Support/typora-user-images/Screenshot 2022-11-12 at 11.18.14.png)

Như bạn thấy khi network bị lỗi và observable phát ra lỗi, subscription update UI sẽ ngừng hoạt động để chặn các update tiếp theo.
Ví dụ thực tế:
Khi bạn remove .catchErrorJustReturn(.empty) trong lúc subcrible.

Và bạn search một địa điểm nào đó thì gọi api thì nó sẽ trả về 404 ( 404 có nghĩa là địa điểm đó không tìm thấy)
Bạn sẽ phải thông báo là ngưng việc search sau khi trả về 404.

## 5. Catching errors

![Screenshot 2022-11-12 at 11.29.33](/Users/tam.nguyen7/Library/Application Support/typora-user-images/Screenshot 2022-11-12 at 11.29.33.png)

**Ví dụ 1:**
Khi load một lists lên tableView.
Vì một số lí do chi đó mà nó request bị lỗi trả về (400 ..500) thì ta phải bắt cái lỗi đó là gì và show lên màn hình là lỗi gì để cho user có thể biết.

(chup ảnh liên quan các thứ)

**Ví dụ 2:**
Liên quan đến search các thành phố, search cú nào thì gọi api cú đó.

```swift
private var cache = [String: Weather]()
```

Biến này sẽ lưu tạm thời cached data.

```swift
let textSearch = searchInput.flatMap { text in
  return ApiController.shared.currentWeather(city: text)
    .do(onNext: { [weak self] data in
      self?.cache[text] = data
})
    .catchErrorJustReturn(.empty)
}
```

Với kiểu code trên thì mỗi giá trị hợp lệ (valid) sẽ được lưu vào dictionary.Vậy chúng ra sẽ tái sử dụng cached data như thế nào?

Thay thế **.catchErrorJustReturn(.empty)** thành:

```swift
.catchError { error in
  return Observable.just(self?.cache[text] ?? .empty)
}
```

Kết quả đạt được:

Nhập search "London", "VietNam", "Monstar-lab" thì load được thời tiết của các địa điểm đó.
Xong tắt cái mạng đi.

Xong search "Asian Tech" bạn sẽ nhận được lỗi. Tiếp tục để mạng disabled, search một trong 3 cái địa điểm phía trên thì nó sẽ hiển thị thông tin thời tiết vì nó đã được lưu trong cached.

Đây là một cách dùng rất phổ biến của catch.

## 6. Retry operators

Có 3 loại retry operator. Sử dụng nhiều nhất là :

```swift
func retry() -> Observabke<Element>
```

Operator này sẽ repeat observable không giới hạn số lần cho đến khi nó trả về thành công.
Ví dụ, nếu mất mạng thì nó sẽ retry liên tục cho đến khi có mạng trở lại.Nhưng điều này là khiến ngốn tài nguyên nặng và khuyến nghị nên retry giới hạn số lần nếu không có lí do chính đáng làm điều đó.

```swift
func retry(_ maxAttemptCount:) -> Observable<Element>
```

```swift
let textSearch = searchInput.flatMap { text in
  return ApiController.shared.currentWeather(city: text)
    .do(onNext: { [weak self] data in
      self?.cache[text] = data
    })
    .retry(3)
    .catchError { [weak self] error in
      return Observable.just(self?.cache[text] ?? .empty)
    }
}
```

Nếu quá trình này lỗi thì nó sẽ retry 3 lần. Nếu lỗi tới 4 lần thì đoạn code này nó sẽ nhảy xuống .catchError.

## 7. Custom Errors

### 7.1. Creating custom errors

Ví dụ đơn giản request sẽ xảy ra 2 lỗi:

- HTTP 404 error (page not found)
- 502 (bad gateway)

```swift
enum ApiError: Error {
  case cityNotFound
  case serverFailure
}
```

```swift
return session.rx.response(request: request)
  .map { response, data in
  switch response.statusCode {
  case 200 ..< 300:
    return data
  case 400 ..< 500:
    throw ApiError.cityNotFound
  default:
    throw ApiError.serverFailure
  }
}
```

Sử dụng methods này bạn có thể custom errors và có thể thêm một số logic, thêm case lỗi ví dụ khi API cung cấp response message trong file Json. Bạn có thể get Json data đó, lấy cái message field đó rồi đóng gói lại thành lỗi để ném đi.

## 7.2. Using custom errors