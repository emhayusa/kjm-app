import 'package:equatable/equatable.dart';

abstract class EdukasiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchArticles extends EdukasiEvent {}

class FilterArticles extends EdukasiEvent {
  final String filterText;

  FilterArticles(this.filterText);

  @override
  List<Object> get props => [filterText];
}
