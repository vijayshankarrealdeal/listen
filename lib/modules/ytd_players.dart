import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YtdPlayers extends ChangeNotifier {
  List<String> ids = ["TkYiJdwblQM", "5X0nM1a9obA", "9DxmZnvimvU"];
  String intialVId = "TkYiJdwblQM";
  final PageController controller = PageController();
  void changeVidoLink(String videoLink) {
    intialVId = videoLink;
    notifyListeners();
  }

  int _currentPage = 0; // Starting page index

  int get currentPage => _currentPage;

  void setPage(int page) {
    _currentPage = page;
    intialVId = ids[page];
    notifyListeners(); // Notify listeners to update UI
  }

  void nextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  YoutubePlayer players() {
    return YoutubePlayer(
      bufferIndicator: const CircularProgressIndicator(),
      showVideoProgressIndicator: true,
      controller: YoutubePlayerController(
        initialVideoId: intialVId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      ),
    );
  }
}
