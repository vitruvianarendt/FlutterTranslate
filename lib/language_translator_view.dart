import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguageTranslatorView extends StatefulWidget {
  const LanguageTranslatorView({Key? key}) : super(key: key);

  @override
  _LanguageTranslatorViewState createState() => _LanguageTranslatorViewState();
}

class _LanguageTranslatorViewState extends State<LanguageTranslatorView> {
  String? _translatedText;
  final _controller = TextEditingController();
  final _sourceLanguage = TranslateLanguage.english;
  final _targetLanguage = TranslateLanguage.german;
  late final _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
  final _defaultText = 'What, if some day or night a demon were to steal after you into your loneliest loneliness and say to you: "This life as you now live it and have lived it, you will have to live once more and innumerable times more" ... Would you not throw yourself down and gnash your teeth and curse the demon who spoke thus? Or have you once experienced a tremendous moment when you would have answered him: "You are a god and never have I heard anything more divine."';
  String? _elapsedTime;
  @override
  void dispose() {
    _onDeviceTranslator.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Translator'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                  child: Text('Enter text (source: ${_sourceLanguage.name})')),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      )),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _defaultText,
                        hintMaxLines: 15,
                        hintStyle: const TextStyle(fontSize: 14.0),

                  ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(height: 1.0),
                  ),
                ),
              ),
              Center(
                  child: Text(
                      'Translated Text (target: ${_targetLanguage.name})')),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                  child: Column (
                    children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                            )),
                        child: Text ((_translatedText ?? ' '))
                    ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      Text(_elapsedTime ?? 'Elapsed Time: 0.0')
              ],
              )
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: _translateText, child: const Text('Translate'))
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _translateText() async {
    FocusScope.of(context).unfocus();
    String result;
    Stopwatch stopwatch = Stopwatch()..start();
    result  = await _onDeviceTranslator.translateText(_controller.text);
    if(_controller.text == '')
      {
        result  = await _onDeviceTranslator.translateText(_defaultText);
      }
    stopwatch.stop();
    setState(() {
      _translatedText = result;
      _elapsedTime = 'Time Elapsed ${stopwatch.elapsed}';
    });
  }
}