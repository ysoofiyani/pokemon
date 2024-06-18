import 'package:pokemon/models/pokemon.dart';

class HomePageData {
  PokemonListData? data;
  List<String> favoritesPokemons;

  HomePageData({
    required this.data,
    required this.favoritesPokemons,
  });

  HomePageData.initial()
      : data = null,
        favoritesPokemons = [];

  HomePageData copyWith(
      {PokemonListData? data, List<String>? favoritesPokemons}) {
    return HomePageData(
      data: data ?? this.data,
      favoritesPokemons: favoritesPokemons ?? this.favoritesPokemons,
    );
  }
}
