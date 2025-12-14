part of 'library_bloc.dart';

sealed class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

final class LibraryInitial extends LibraryState {}

final class LibraryLoading extends LibraryState {}

final class LibrarySuccess extends LibraryState {
  final List<LibraryFile> files;

  const LibrarySuccess({required this.files});

  @override
  List<Object> get props => [...super.props, files];
}

final class LibraryFailure extends LibraryState {
  final String message;

  const LibraryFailure({required this.message});

  @override
  List<Object> get props => [...super.props, message];
}
