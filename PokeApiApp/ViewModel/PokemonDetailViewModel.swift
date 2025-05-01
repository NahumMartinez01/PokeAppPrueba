//
//  PokemonDetailViewModel.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import Foundation

class PokemonDetailViewModel : ObservableObject {
    @Published var detailPokemon: PokemonDetailModel?
    
    private var appServices: AppServicesProtocol
    private var myAppManager: MyAppManager
    
    init(appServices: AppServicesProtocol = AppServices.shared, myAppManager: MyAppManager = MyAppManager.shared) {
        self.appServices = appServices
        self.myAppManager = myAppManager
    }
    
 

}
