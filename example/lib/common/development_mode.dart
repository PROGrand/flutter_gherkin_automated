//TODO: transform to riverpod provider.
class DevelopmentMode {
  static bool _useFastData = false;
  static bool _showErrors = false;
  static bool _minimizeDelays = false;

  static get useFastData => _useFastData;
  static get showErrors => _showErrors;
  static get minimizeDelays => _minimizeDelays;

  static void initialize(
      {bool useFastData = false,
      bool showErrors = false,
      bool minimizeDelays = false}) {
    DevelopmentMode._useFastData = useFastData;
    DevelopmentMode._showErrors = showErrors;
    DevelopmentMode._minimizeDelays = minimizeDelays;
  }
}
