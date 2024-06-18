import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/get_it.dart';
import 'package:pokemon/services/http_service.dart';
import 'package:pokemon/views/models/home_page_data.dart';

class HomePageController extends StateNotifier<HomePageData> {
  HomePageController(
    super._state,
  ) {
    loadData();
    pokemonScrollerController.addListener(_scrollListener);
  }

  final _httpService = getIt.get<HttpService>();
  final pokemonScrollerController = ScrollController();

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpService
          .get('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0');
      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(
          data: data,
        );
      }
    } else {
      if (state.data?.next != null) {
        Response? res = await _httpService.get(
          state.data!.next!,
        );
        if (res != null && res.data != null) {
          PokemonListData data = PokemonListData.fromJson(res.data);
          state = state.copyWith(
            data: data.copyWith(
              results: [
                ...?state.data?.results,
                ...?data.results,
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> _scrollListener() async {
    if (pokemonScrollerController.offset >=
            pokemonScrollerController.position.maxScrollExtent * 0.8 &&
        !pokemonScrollerController.position.outOfRange) {
      await loadData();
    }
  }

  void addFavoritePokemon(String url) {
    state = state.copyWith(
      favoritesPokemons: [
        ...state.favoritesPokemons,
        url,
      ],
    );
  }

  void removeFavoritePokemon(String url) {
    state = state.copyWith(
      favoritesPokemons:
          state.favoritesPokemons.where((e) => e != url).toList(),
    );
  }

  /// Providers
  final pokemonDataProvider = FutureProviderFamily<Pokemon?, String>(
    (ref, url) async {
      Response? res = await getIt.get<HttpService>().get(url);
      if (res != null && res.data != null) {
        return Pokemon.fromJson(res.data);
      }
      return null;
    },
  );
}
