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
    
    init(appServices: AppServicesProtocol = AppServices.shared, myAppManager: MyAppManager = MyAppManager.shared, viewContext: NSManagedObjectContext) {
        self.appServices = appServices
        self.myAppManager = myAppManager
        self.viewContext = viewContext
    }
    
    //MARK: INITIAL DATA
    func loadInitialData() async {
        if !InitialFetchFlagManager.wasInitialFetchDone() {
           
            await getPokemonsList()
        }
        else {
            await fetchSavedPokemons()
        }
    }
    
    //MARK: SERVICES FUNCTIONS
        @MainActor
        func getPokemonsList() async {
            self.myAppManager.isLoadingViewVisible = true
            
            defer {
                   self.myAppManager.isLoadingViewVisible = false
               }
            let currentOffset = LimitsOffsetManager.getCurrentOffset()
            let limit = 5
            do {
                let response = try await appServices.fetchRequest(
                    url: AppServicesUtils.PokemonURLs.getPokemonList(limit: limit, offset: currentOffset),
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
                LimitsOffsetManager.imcrementOffset(limit)
                InitialFetchFlagManager.markInitialFetchDone()
            } catch {
                myAppManager.errorMessage = .downloadFailed(message: error.localizedDescription)
                myAppManager.showErrorAlert = true
                InitialFetchFlagManager.reset()
            }
        }
    
    @MainActor
    func getPokemonDetail(url: String) async {
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
            myAppManager.errorMessage = .downloadFailed(message: error.localizedDescription)
            myAppManager.showErrorAlert = true
            InitialFetchFlagManager.reset()
        }
    }
    
    //MARK: UTILS FUNCTION
    @MainActor
    func fetchSavedPokemons(searchText: String = "", filterType: FilterType = .name) {
        myAppManager.isLoadingViewVisible = true
        myAppManager.fetchSavedPokemnos(searchText: searchText, filterType: filterType)
        myAppManager.isLoadingViewVisible = false
    }
    
    @MainActor
    func savePokemonsToCoreData(pokemons: [PokemonDetailModel]) {
        myAppManager.savePokemon(pokemons)
    }
}

