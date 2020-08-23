# WordPuzzle
<p align="center"><img src="https://www.pngitem.com/pimgs/m/537-5373008_babbel-for-business-babbel-logo-png-transparent-png.png" ></a></p>

## Prereqs

- Xcode 11.5
- iOS 13+

## Usage

- Run ```Pod Install```  to install the dependencies 

## Features

App is consist of main game screen in which user has to guess the correct translation.

## Overall Architecture 

App is based on **MVVM-C** architecture. Structure is broken down by the general purpose of contained source files. Below are the dependencies used in the project

1. **RxSwift** : Used to bind the flow between layers
2. **SnapKit** : SnapKit is a DSL to make Auto Layout easy .
3. **NVActivityIndicatorView** : Used to show loading states.
4. **SwiftLint** : A tool to enforce Swift style and conventions, loosely based on
[GitHub's Swift Style Guide](https://github.com/github/swift-style-guide).
5. **Swinject** : Used to manage and Inject dependencies.

## Notes
Total duration: ~8h.
- Paper prototyping: ~30'
- Search for assets online: ~30'
- Setup project: ~15'
- Setup project dependecies:  ~15'
- Setup project architecutre: ~2h
- Dependency Injection : ~30'
- Model creation: ~20'
- Base classes: ~20'
- Main Screen UI: ~30'
- Game Mechanism: ~2h

Decision made because of restricted time/improvements with more time:
- Better error handling.
- I chose to use the "words.json" inside the project to retrieve the translations
instead of an implementation of the networking layer to get data from the URL provided.
 In that case I would have used RxAlamofire.
- Game setting screen implementation.
- Game Score screen implementation.
- Better Rx bindings.
- Implentaion of Unit and UI testing but i tried to write as much testable code as possible.
