import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_api/library_api.dart';
import 'package:library_repository/library_repository.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc({required LibraryRepository libraryRepository})
    : _libraryRepository = libraryRepository,
      super(LibraryInitial()) {
    on<LibrarySubscriptionRequested>(_onSubscriptionRequested);
    on<LibraryAddNewFile>(_onAddNewFileRequested);
  }

  final LibraryRepository _libraryRepository;

  Future<void> _onSubscriptionRequested(
    LibrarySubscriptionRequested event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    await emit.forEach<List<LibraryFile>>(
      _libraryRepository.getFiles(),
      onData: (files) => LibrarySuccess(files: files),
      onError: (error, trace) => LibraryFailure(message: '$error, $trace'),
    );
  }

  Future<void> _onAddNewFileRequested(
    LibraryAddNewFile event,
    Emitter<LibraryState> emit,
  ) async {
    await _libraryRepository.addFile(event.filePath);
  }
}
