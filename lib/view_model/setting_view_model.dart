import 'package:shared_preferences/shared_preferences.dart';

class SettingViewModel {
  static const String _strukHeaderKey = 'struk_header';
  static const String _strukFooterKey = 'struk_footer';
  static const String _webHookKey = 'webhook';

  SharedPreferences? _prefs;

  SettingViewModel() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await _init();
    }
  }

  Future<String> getStrukHeader() async {
    await _ensureInitialized();
    return _prefs?.getString(_strukHeaderKey) ?? 'Pos Portal';
  }

  Future<String> getStrukFooter() async {
    await _ensureInitialized();
    return _prefs?.getString(_strukFooterKey) ?? 'Terima kasih atas kunjungan anda';
  }

  Future<String> getWebHook() async {
    await _ensureInitialized();
    return _prefs?.getString(_webHookKey) ?? '';
  }

  Future<bool?> setStrukHeader(String header) async {
    await _ensureInitialized();
    return await _prefs?.setString(_strukHeaderKey, header);
  }

  Future<bool?> setStrukFooter(String footer) async {
    await _ensureInitialized();
    return await _prefs?.setString(_strukFooterKey, footer);
  }

  Future<bool?> setWebHook(String webHook) async {
    await _ensureInitialized();
    return await _prefs?.setString(_webHookKey, webHook);
  }
}
