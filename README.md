# DSRequest

----



## DSRequest

* SwiftUI 一个简单的网络请求库，`MacOS`， `iPhone`，`iPad`，`tvOS` 和  `watchOS`。



----



## 安装 ( Installation ) 

#### Swift Package Manager


The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler



##### GitHub

```swift
dependencies: [
    .package(url: "https://github.com/swp-song/DSRequest.git", .upToNextMajor(from: "1.1.0"))
]
```



##### Gitee ( 国内 )

```swift
dependencies: [
    .package(url: "https://gitee.com/dream-swp/DSRequest.git", .upToNextMajor(from: "1.1.0"))
]
```



----



## 使用 ( Use )

#### GET 

```swift
import DSRequest
import Combine

// GET da
let token = AnyCancellable.Token()
DSRequest.default.ds
    .get(url: "https://www.baidu.com", parameters: ["type":"json"])
    .sink { complete in
        if case .failure(let error) = complete {
            print(error.localizedDescription)
        }
        token.unseal()
    } receiveValue: { data in
        print(String(data: data, encoding: .utf8)!)
    }
    .seal(in: token)
```



#### POST

```swift
var parameters = [String : Any]()
parameters["model"] = "gpt-3.5-turbo-0613"
parameters["messages"] = [["role" : "user", "content" : "你好?"]]
parameters["temperature"] = 0.7
let headers: DSHeaders = [.accept("application/json"), .authorization(bearerToken: "key")]

let token = AnyCancellable.Token()        
DSRequest.default.ds
		.post(url: gptURL, parameters: parameters, headers: headers, model: GPTModel.self)
    .sink { complete in
        if case .failure(let error) = complete {
            print(error.localizedDescription)
        }
        token.unseal()
    } receiveValue: { model in
        print(model)
    }
    .seal(in: token)
```



----

