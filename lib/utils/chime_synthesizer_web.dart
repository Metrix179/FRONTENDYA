import 'dart:html' as html;
import 'package:flutter/foundation.dart';

void playMascotChime() {
  try {
    final ctx = html.AudioContext();
    // 4-note ascending chime: C5 (523.25 Hz) -> E5 (659.25 Hz) -> G5 (783.99 Hz) -> C6 (1046.50 Hz)
    final notes = [523.25, 659.25, 783.99, 1046.50];
    final double now = ctx.currentTime?.toDouble() ?? 0.0;

    for (int i = 0; i < notes.length; i++) {
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();

      osc.type = 'sine';
      osc.frequency?.value = notes[i];

      final startTime = now + (i * 0.15);
      final stopTime = startTime + 0.6;

      gain.gain?.setValueAtTime(0.2, startTime);
      gain.gain?.exponentialRampToValueAtTime(0.001, stopTime);

      osc.connect(gain);
      gain.connect(ctx.destination!);

      osc.start(startTime);
      osc.stop(stopTime);
    }
  } catch (e) {
    debugPrint('Web audio chime synth error: $e');
  }
}
