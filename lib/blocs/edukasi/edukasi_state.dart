import 'package:equatable/equatable.dart';
import 'package:kjm_app/model/article.dart';

abstract class EdukasiState extends Equatable {
  const EdukasiState();

  @override
  List<Object> get props => [];
}

class EdukasiInitial extends EdukasiState {}

class EdukasiLoading extends EdukasiState {}

class EdukasiLoaded extends EdukasiState {
  /*final Contact contact;

  EdukasiLoaded({required this.contact});

  @override
  List<Object> get props => [contact];
  */
  final List<Article> articles;
  final List<Article> filteredArticles;

  const EdukasiLoaded({required this.articles, required this.filteredArticles});

  @override
  List<Object> get props => [articles, filteredArticles];
}

class EdukasiError extends EdukasiState {
  final String message;

  const EdukasiError({required this.message});

  @override
  List<Object> get props => [message];
}
