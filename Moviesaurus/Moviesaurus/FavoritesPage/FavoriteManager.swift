//
//  FavoriteController.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 3.08.2022.
//

import Foundation
import UIKit
import CoreData

struct FavoriteManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllFavoriteMovies() -> [FavoriteMovie] {
        do {
            let items = try context.fetch(FavoriteMovie.fetchRequest())
            return items
        } catch { return [] }
    }
    
    func addToFavorites(movie: Movie?) {
        if let movieToBeInserted = movie {
            if !isMovieInFavorites(movie: movieToBeInserted) {
                let newFavoriteMovie = FavoriteMovie(context: context)
                if let id = movie?.id {
                    newFavoriteMovie.id = Int64(id)
                }
                if let title = movie?.title {
                    newFavoriteMovie.title = title
                }
                if let releaseDate = movie?.releaseDate {
                    newFavoriteMovie.releaseDate = releaseDate
                }
                if let imdb = movie?.voteAverage {
                    newFavoriteMovie.imdb = imdb
                }
                if let posterPath = movie?.posterPath{
                    newFavoriteMovie.posterPath = posterPath
                }
                do {
                    try context.save()
                } catch {print(error)}
            }
        }
    }
    
    func deleteFromFavorites(movie: Movie) {
        if let id = movie.id {
            do {
                let items = getAllFavoriteMovies()
                for item in items {
                    if item.id == id {
                        context.delete(item)
                    }
                }
                do {
                    try context.save()
                } catch { print(error) }
            }
        }
    }
    
    func deleteAllFavoriteMovies() {
        do {
            let items = try context.fetch(FavoriteMovie.fetchRequest())
            for item in items {
                context.delete(item)
            }
            do {
                try context.save()
            } catch { print(error) }
        } catch { print(error) }
    }
    
    func isMovieInFavorites(movie: Movie) ->Bool {
        if let id = movie.id {
            do {
                let items = try context.fetch(FavoriteMovie.fetchRequest())
                for item in items {
                    if item.id == id {
                        return true
                    }
                }
            } catch {}
        }
        return false
    }
}

