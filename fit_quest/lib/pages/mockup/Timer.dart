import 'package:fit_quest/common/common.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FitTimer extends StatefulWidget {
  final Duration initialDuration;
  final Duration interval;
  final Color backgroundColor;
  final Color progressColor;
  final TextStyle? textStyle;
  final bool autoStart;
  final bool showControls;
  final VoidCallback? onComplete;
  final ValueChanged<Duration>? onTick;

  const FitTimer({
    super.key,
    required this.initialDuration,
    this.interval = const Duration(seconds: 1),
    this.backgroundColor = Colors.grey,
    this.progressColor = UI.primary,
    this.textStyle,
    this.autoStart = false,
    this.showControls = true,
    this.onComplete,
    this.onTick,
  });

  @override
  State<FitTimer> createState() => FitTimerState();
}

class FitTimerState extends State<FitTimer> {
  late Duration _remaining;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();

    _remaining = widget.initialDuration;
    if (widget.autoStart) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Public control methods
  void start() {
    if (_isRunning) return;
    _start();
  }

  void pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.initialDuration;
      _isRunning = false;
    });
  }

  Duration get remainingTime => _remaining;
  bool get isRunning => _isRunning;

  void _start() {
    _timer = Timer.periodic(widget.interval, (timer) {
      setState(() {
        _remaining -= widget.interval;
        widget.onTick?.call(_remaining);

        if (_remaining <= Duration.zero) {
          _remaining = Duration.zero;
          _isRunning = false;
          timer.cancel();
          widget.onComplete?.call();
        }
      });
    });
    setState(() => _isRunning = true);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        widget.initialDuration.inMilliseconds > 0
            ? 1 -
                (_remaining.inMilliseconds /
                    widget.initialDuration.inMilliseconds)
            : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: widget.backgroundColor,
                color: widget.progressColor,
              ),
            ),
            Common.text(
              data: _formatDuration(_remaining),

              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
        if (widget.showControls) _buildControls(),
      ],
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRunning)
              IconButton(
                icon: Icon(
                  _remaining > Duration.zero ? Icons.play_arrow : Icons.replay,
                ),
                onPressed: () => _remaining > Duration.zero ? start() : reset(),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(UI.primary),
                ),
              ),

            if (_isRunning)
              IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
                onPressed: pause,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(UI.primary),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: reset,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(UI.background),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
