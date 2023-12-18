# PSCore

PSCore é um pacote Swift que inclui implementações para o padrão de design Observer e Chain of Responsibility, além de várias outras funcionalidades.

## Instalação

Para instalar o PSCore, você precisa adicionar o seguinte ao seu arquivo Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/tiagopoleze/PSCore.git", from: "1.0.0")
]
```

Uso
Observer
Para usar o padrão Observer, você precisa fazer o seguinte:
```
struct TestAction: ObserverEvent {
    var eventData: Bool
}

class TestObserver: Observer {
    var value: Bool = false

    func send(event: TestAction) {
        self.value = event.eventData
    }
}

class TestObservable: Observable {
    var registeredObservers: [TestObserver] = []
}

let observer = TestObserver()
let observable = TestObservable()

observable.register(observer: observer)
observable.sendToAll(event: TestAction(eventData: true))
```

Chain of Responsibility
Para usar o padrão Chain of Responsibility, você precisa fazer o seguinte:
```
let first = ChainOfResponsibility<Int, Int> { number in
    number == 10
} result: { number in
    number + 1
}

let second = ChainOfResponsibility<Int, Int>(next: first) { number in
    number == 5
} result: { number in
    number + 2
}

let result = try second.execute(input: 10)
let result2 = try second.execute(input: 5)
```

Testes
Para executar os testes, você pode usar o seguinte comando:
```
swift test
```

Linting
Para linting, usamos SwiftLint. Você pode executar o linter com o seguinte comando:
```
./scripts/bin/swiftlint --format --quiet --config ./.swiftlint.yml
```

Contribuindo
Contribuições são bem-vindas! Por favor, leia nosso guia de contribuição para começar.

Licença
Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para detalhes.