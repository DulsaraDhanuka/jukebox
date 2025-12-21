part of 'library_bloc.dart';

sealed class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

final class LibrarySubscribe extends LibraryEvent {
  const LibrarySubscribe();
}

final class LibraryAddNewFile extends LibraryEvent {
  const LibraryAddNewFile({required this.filePath});

  final String filePath;

  @override
  List<Object> get props => [...super.props, filePath];
}