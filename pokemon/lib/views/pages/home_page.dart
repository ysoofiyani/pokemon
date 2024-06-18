import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/views/controllers/home_page_controller.dart';
import 'package:pokemon/views/models/home_page_data.dart';
import 'package:pokemon/views/widgets/pokemon_card.dart';
import 'package:pokemon/views/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(
    HomePageData.initial(),
  );
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homePageController = ref.watch(
      homePageControllerProvider.notifier,
    );
    final homePageData = ref.watch(
      homePageControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Text('All Pokemones'),
          ),
          if (homePageData.favoritesPokemons.isNotEmpty)
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.40,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: homePageData.favoritesPokemons.length,
                itemBuilder: (context, index) {
                  return PokemonCard(
                    pokemonURL: homePageData.favoritesPokemons[index],
                    homePageController: homePageController,
                    homePageData: homePageData,
                  );
                },
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                shrinkWrap: true,
                controller: homePageController.pokemonScrollerController,
                itemCount: homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  final url = homePageData.data?.results?[index].url;
                  if (url != null) {
                    return PokemonListTile(
                      pokemonURL: url,
                      homePageController: homePageController,
                      homePageData: homePageData,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
