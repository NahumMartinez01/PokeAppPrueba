//
//  MyAppManager.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//
    
import Foundation
import CoreData

class MyAppManager: ObservableObject {
    @Published var isLoadingViewVisible: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: PokemonError? = nil
    @Published var detailPokemon: [PokemonDetailModel] = []
    @Published var bounce: Bool = false
    
    static let shared = MyAppManager()
    
    private let pokemonRepository: PokemonRepositoryProtocol
    
    init(pokemonRepository: PokemonRepositoryProtocol = PokemonRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    // MARK: - Core Data Operations
    @MainActor
    func fetchSavedPokemnos(searchText: String = "", filterType: FilterType = .name){
        isLoadingViewVisible = true
        
        pokemonRepository.fetchPokemons(searchText: searchText, filterType: filterType, completion: { [weak self] result in
            self?.isLoadingViewVisible = false
            switch result {
            case .success(let pokemons):
                self?.detailPokemon = pokemons
            case .failure(let error):
                self?.errorMessage = error
                self?.showErrorAlert = true
                self?.detailPokemon.removeAll()
            }
        })
    }
    
    @MainActor
    func savePokemon(_ pokemon: [PokemonDetailModel]) {
        isLoadingViewVisible = true
        
        do {
            try pokemonRepository.savePokemons(pokemon)
            self.isLoadingViewVisible = false
            self.fetchSavedPokemnos()
        }
        catch {
            self.isLoadingViewVisible = false
            self.errorMessage = .coreDataError(message: error.localizedDescription)
            self.showErrorAlert = true
        }
    }
}
