import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/views/models/home_page_data.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_page_controller.dart';

class PokemonCard extends ConsumerWidget {
  const PokemonCard({
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
        return _card(
          false,
          data,
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return _card(
          true,
          null,
        );
      },
    );
  }

  Widget _card(
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: pokemon?.sprites?.frontDefault == null
                  ? null
                  : NetworkImage(
                      pokemon!.sprites!.frontDefault!,
                    ),
              maxRadius: 35,
            ),
            Text(pokemon?.name ?? 'No Name'),
          ],
        ),
      ),
    );
  }
}
