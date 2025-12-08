
import 'package:playables_api/src/models/models.dart';

abstract class PlayablesApi {
  const PlayablesApi();

  Stream<List<Playable>> getPlayables();
  Future<void> editPlayable(String id, String name);
  Future<void> addFile(String filePath);
  Future<void> deletePlayable(String id);
  Future<void> close();
}
