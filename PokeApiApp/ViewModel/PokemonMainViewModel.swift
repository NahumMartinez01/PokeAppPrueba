//
//  PokemonMainViewModel.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//
import Foundation
import CoreData
import Combine

class PokemonMainViewModel: ObservableObject {
    @Published var pokemons: [PokemonListModel] = []
    @Published var detailPokemon: [PokemonDetailModel] = []
    @Published var currentError: PokemonError? = nil
    @Published var hasError: Bool = false
    @Published var searchText: String = ""
    @Published var filterType: FilterType = .name
    
    private var appServices: AppServicesProtocol
    private var myAppManager: MyAppManager
    private var viewContext: NSManagedObjectContext
    private var cancellable = Set<AnyCancellable>()
    
    private var didDownloadPokemons: Bool {
        get { UserDefaults.standard.bool(forKey: "DidDownloadPokemons") }
        set { UserDefaults.standard.set(newValue, forKey: "DidDownloadPokemons") }
    }
    
    init(appServices: AppServicesProtocol = AppServices.shared, myAppManager: MyAppManager = MyAppManager.shared, viewContext: NSManagedObjectContext) {
        self.appServices = appServices
        self.myAppManager = myAppManager
        self.viewContext = viewContext
    }
    
    //MARK: SERVICES FUNCTIONS
    //    @MainActor
    //    func getFiveNewPokemonsForBackgroundFetch() async {
    //            do {
    //                let response = try await appServices.fetchRequest(
    //                    url: AppServicesUtils.PokemonURLs.getPokemonList(limit: 50, offset: 0),
    //                    method: AppServicesK.methodRequest.GET.rawValue,
    //                    headers: nil,
    //                    body: nil,
    //                    responseType: PokemonListBaseResponse.self
    //                )
    //                self.pokemons = response.results ?? []
    //                await withTaskGroup(of: Void.self) { group in
    //                    for pokem in pokemons {
    //                        group.addTask {
    //                            await self.getPokemonDetail(url: pokem.url ?? "")
    //                        }
    //                    }
    //                }
    //                print("pokemons", self.pokemons)
    //                savePokemonsToCoreData()
    //            } catch {
    //                currentError = .downloadFailed(message: error.localizedDescription)
    //                print("Un error ha ocurrido:", error.localizedDescription)
    //            }
    //    }
    
    
    @MainActor
    func getPokemonsList() async {
        //        guard !didDownloadPokemons else {
        //                print("✅ Pokémons ya fueron descargados anteriormente")
        //                return
        //        }
        hasError = false
        self.myAppManager.isLoadingViewVisible = true
        do {
            let response = try await appServices.fetchRequest(
                url: AppServicesUtils.PokemonURLs.getPokemonList(limit: 5, offset: 0),
                method: AppServicesK.methodRequest.GET.rawValue,
                headers: nil,
                body: nil,
                responseType: PokemonListBaseResponse.self
            )
            self.pokemons = response.results ?? []
            await withTaskGroup(of: Void.self) { group in
                for pokem in pokemons {
                    group.addTask {
                        await self.getPokemonDetail(url: pokem.url ?? "")
                    }
                }
            }
            savePokemonsToCoreData(pokemons: detailPokemon)
            didDownloadPokemons = true
        } catch {
            currentError = .downloadFailed(message: error.localizedDescription)
            hasError = true
            print("Un error ha ocurrido:", error.localizedDescription)
        }
        self.myAppManager.isLoadingViewVisible = false
    }
    
    @MainActor
    func getPokemonDetail(url: String) async {
        hasError = false
        do {
            let response = try await appServices.fetchRequest(
                url: url,
                method: AppServicesK.methodRequest.GET.rawValue,
                headers: nil,
                body: nil,
                responseType: PokemonDetailModel.self
            )
            self.detailPokemon.append(response)
        } catch {
            hasError = true
            //currentError = .downloadFailed(message: error.localizedDescription)
            print("Error al obtener el detalle para \(url):", error.localizedDescription)
        }
    }
    
    //MARK: UTILS FUNCTION
    @MainActor
    func fetchSavedPokemons(searchText: String = "", filterType: FilterType = .name) {
        myAppManager.fetchSavedPokemnos(searchText: searchText, filterType: filterType)
    }
    
    @MainActor
    func savePokemonsToCoreData(pokemons: [PokemonDetailModel]) {
        myAppManager.savePokemon(pokemons)
    }
}

