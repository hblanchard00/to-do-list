//
//  ContentView.swift
//  to do list
//
//  Created by Hugo Blanchard on 08/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDo.isCompleted) private var toDos: [ToDo]
    
    @State private var isAlertShowing = false
    @State private var toDoTitle = ""
    @State private var hideCompleted = false
    
    var filteredToDos: [ToDo] {
        hideCompleted ? toDos.filter{ !$0.isCompleted } : toDos
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                
                // Les éléments sont affichés sous forme de liste scrollable
                List {
                    ForEach(filteredToDos) { toDo in
                        HStack {
                            Button {
                                toDo.isCompleted.toggle()
                            } label: {
                                Image(systemName: toDo.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                            
                            Text(toDo.title)
                        }
                    }
                    .onDelete(perform: deleteToDos)
                    
                    Section {
                        Button(hideCompleted ? "Afficher les tâches terminées" : "Masquer les tâches terminées") {
                            hideCompleted.toggle() // Inverse l'état
                        }
                    }
                }
                .navigationTitle("Liste de tâches") // Titre de la page
                
                
                // L'utilisateur peut ajouter du contenu dans la liste
                .toolbar {
                    Button {
                        isAlertShowing.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                
                // L'utilisateur est en mesure d'ajouter du contenu. Il peut aussi annuler l'action et fermer l'alerte
                .alert("Créer une tâche", isPresented: $isAlertShowing) {
                    TextField("Remplacer jante", text: $toDoTitle)
                    
                    Button {
                        modelContext.insert(ToDo(title: toDoTitle, isCompleted: false))
                        
                        toDoTitle = "" // Avoir un titre vide par défaut
                    } label: {
                        Text("Créer")
                    }
                    
                    Button (role: .cancel) {
                        toDoTitle = "" // Avoir un titre vide par défaut
                    } label: {
                        Text("Annuler")
                    }
                }
                
                // Si la liste ne contient aucun élément, alors afficher un état vide
                .overlay {
                    if toDos.isEmpty {
                        ContentUnavailableView("Vous êtes à jour" , systemImage: "checkmark.circle")
                    }
                }
            }
            .tabItem{
                Label("List", systemImage: "list.bullet")
            }
            
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
            
        }
    }
    
    // Fonction pour supprimer un élément dans la liste
    
    func deleteToDos(_ indexSet: IndexSet) {
        for index in indexSet {
            let toDo = toDos[index]
            modelContext.delete(toDo)
        }
    }
}

#Preview {
    ContentView()
}
