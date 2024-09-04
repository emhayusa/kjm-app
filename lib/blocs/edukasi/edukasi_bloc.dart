import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/model/article.dart';
import 'package:kjm_security/repositories/edukasi_repository.dart';
import 'edukasi_event.dart';
import 'edukasi_state.dart';

class EdukasiBloc extends Bloc<EdukasiEvent, EdukasiState> {
  final EdukasiRepository edukasiRepository;

  EdukasiBloc({required this.edukasiRepository}) : super(EdukasiInitial()) {
    on<FetchArticles>(_onFetchArticles);
    on<FilterArticles>(_onFilterArticles);
  }

  Future<void> _onFetchArticles(
      FetchArticles event, Emitter<EdukasiState> emit) async {
    emit(EdukasiLoading());
    try {
      //final contact = await faqRepository.fetchContact();
      //emit(FaqLoaded(contact: contact));
      final List<Article> articles = await edukasiRepository.fetchArticles();
      emit(EdukasiLoaded(articles: articles, filteredArticles: articles));
    } catch (e) {
      emit(EdukasiError(message: e.toString()));
    }
  }

  void _onFilterArticles(FilterArticles event, Emitter<EdukasiState> emit) {
    if (state is EdukasiLoaded) {
      final currentState = state as EdukasiLoaded;
      final filteredArticles = currentState.articles
          .where((article) => article.title
              .toLowerCase()
              .contains(event.filterText.toLowerCase()))
          .toList();
      emit(EdukasiLoaded(
          articles: currentState.articles, filteredArticles: filteredArticles));
    }
  }
}
