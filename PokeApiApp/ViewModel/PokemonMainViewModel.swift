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
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{[weak self] text in
                guard let self = self else { return }
                self.fetchSavedPokemons(searchText: text, filterType: self.filterType)
            }
            .store(in: &cancellable)
    }
    
    @MainActor
    func getPokemonsList() async {
        guard !didDownloadPokemons else {
                print("✅ Pokémons ya fueron descargados anteriormente")
                return
        }
        self.myAppManager.isLoadingViewVisible = true
        do {
            let response = try await appServices.fetchRequest(
                url: AppServicesUtils.PokemonURLs.getPokemonList(),
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
            savePokemonsToCoreData()
            didDownloadPokemons = true 
        } catch {
            currentError = .downloadFailed(message: error.localizedDescription)
            print("Un error ha ocurrido:", error.localizedDescription)
        }
        self.myAppManager.isLoadingViewVisible = false
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
            currentError = .downloadFailed(message: error.localizedDescription)
            print("Error al obtener el detalle para \(url):", error.localizedDescription)
        }
    }
}

// MARK: CORE DATA OPERATIONS
extension PokemonMainViewModel {
    func fetchSavedPokemons(searchText: String = "", filterType: FilterType = .name) {
        self.myAppManager.isLoadingViewVisible = true
        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        
        if !searchText.isEmpty {
            switch filterType {
            case .name:
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                break
            case .type:
                fetchRequest.predicate = NSPredicate(format: "ANY types.name CONTAINS[cd] %@", searchText)
                break
            case .id:
                if let id = Int64(searchText) {
                    fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
                }
                break
            }
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            detailPokemon = entities.map { entity in
                PokemonDetailModel(
                    id: Int(entity.id),
                    name: entity.name ?? "Unknown",
                    sprites: SpriteImages(front_default: entity.spritesURL),
                    types: (entity.types as? Set<PokemonTypeEntity>)?
                        .sorted { $0.slot < $1.slot }
                        .map { type in
                        PokemonTypeSlot(
                            slot: Int(type.slot),
                            type: PokemonType(name: type.name ?? "unknown")
                        )
                    } ?? []
                )
            }
            self.myAppManager.isLoadingViewVisible = false
        } catch {
            self.myAppManager.isLoadingViewVisible = false
            currentError = .getCoreDataError(message: error.localizedDescription)
           
        }
    }
    
    private func savePokemonsToCoreData() {
        for pokemon in detailPokemon {
            let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(pokemon.id))
            
            do {
                if let existingPokemon = try viewContext.fetch(fetchRequest).first {
                    existingPokemon.name = pokemon.name
                    existingPokemon.spritesURL = pokemon.sprites.front_default
                    if let existingTypes = existingPokemon.types as? Set<PokemonTypeEntity> {
                        for type in existingTypes {
                            viewContext.delete(type)
                        }
                    }
                    for typeSlot in pokemon.types {
                        let typeEntity = PokemonTypeEntity(context: viewContext)
                        typeEntity.slot = Int64(typeSlot.slot)
                        typeEntity.name = typeSlot.type.name
                        existingPokemon.addToTypes(typeEntity)
                    }
                } else {
                    let pokemonEntity = PokemonDetailEntity(context: viewContext)
                    pokemonEntity.id = Int64(pokemon.id)
                    pokemonEntity.name = pokemon.name
                    pokemonEntity.spritesURL = pokemon.sprites.front_default
                    
                    for typeSlot in pokemon.types {
                        let typeEntity = PokemonTypeEntity(context: viewContext)
                        typeEntity.slot = Int64(typeSlot.slot)
                        typeEntity.name = typeSlot.type.name
                        pokemonEntity.addToTypes(typeEntity)
                    }
                }
            } catch {
                currentError = .coreDataError(message: error.localizedDescription)
            }
        }

        do {
            try viewContext.save()
            PersistenceController.shared.saveContext() 
            fetchSavedPokemons()
        } catch {
            currentError = .coreDataError(message: error.localizedDescription)
        }
    }
}

