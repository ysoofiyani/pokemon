import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/views/models/home_page_data.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_page_controller.dart';

class PokemonListTile extends ConsumerWidget {
  const PokemonListTile({
    super.key,
    required this.pokemonURL,
    required this.homePageController,
    required this.homePageData,
  });
  final String pokemonURL;
  final HomePageController homePageController;
  final HomePageData homePageData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      homePageController.pokemonDataProvider(
        pokemonURL,
      ),
    );

    return pokemon.when(
      data: (data) {
        return _tile(
          false,
          data,
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return _tile(
          true,
          null,
        );
      },
    );
  }

  Widget _tile(
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        title: Text(pokemon?.name ?? 'Loading'),
        subtitle: Text('Has ${pokemon?.moves?.length ?? 0} movies'),
        leading: pokemon?.sprites?.frontDefault == null
            ? const CircleAvatar()
            : CircleAvatar(
                backgroundImage: NetworkImage(pokemon!.sprites!.frontDefault!),
              ),
        trailing: IconButton(
          onPressed: () {
            if (homePageData.favoritesPokemons.contains(pokemonURL)) {
              homePageController.removeFavoritePokemon(pokemonURL);
            } else {
              homePageController.addFavoritePokemon(pokemonURL);
            }
          },
          icon: Icon(
            homePageData.favoritesPokemons.contains(pokemonURL)
                ? Icons.favorite
                : Icons.favorite_border,
          ),
        ),
      ),
    );
  }
}
