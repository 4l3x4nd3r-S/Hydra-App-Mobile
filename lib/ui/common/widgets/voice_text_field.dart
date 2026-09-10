import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool hasError;
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color onSurfaceVariantColor;
  final Color borderColor;

  const VoiceTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.hasError = false,
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.onSurfaceVariantColor,
    required this.borderColor,
  });

  @override
  State<VoiceTextField> createState() => _VoiceTextFieldState();
}

class _VoiceTextFieldState extends State<VoiceTextField> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          if (mounted) setState(() => _isListening = false);
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          _previousText = widget.controller.text;
          if (_previousText.isNotEmpty && !_previousText.endsWith(' ')) {
            _previousText += ' ';
          }
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              widget.controller.text = _previousText + val.recognizedWords;
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
            });
          },
          localeId: 'es_ES',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          maxLength: 250,
          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
          style: TextStyle(color: widget.onSurfaceColor, fontSize: 13),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            labelStyle: TextStyle(
                color: widget.hasError ? const Color(0xFFDC2626) : widget.primaryColor, 
                fontWeight: FontWeight.bold, fontSize: 13),
            hintStyle: TextStyle(color: widget.onSurfaceVariantColor.withValues(alpha: 0.5)),
            filled: true,
            fillColor: widget.hasError ? const Color(0xFFFEF2F2) : widget.surfaceColor,
            contentPadding: const EdgeInsets.fromLTRB(16, 16, 48, 32), // padding right for mic
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.hasError ? const Color(0xFFDC2626) : widget.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.hasError ? const Color(0xFFDC2626) : widget.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.hasError ? const Color(0xFFDC2626) : widget.primaryColor, width: 1.5),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? const Color(0xFFDC2626) : widget.primaryColor,
              ),
              onPressed: _listen,
              tooltip: _isListening ? 'Detener grabación' : 'Dictar por voz',
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 14,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return Text(
                '${value.text.length}/250',
                style: TextStyle(
                  color: widget.onSurfaceVariantColor.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
