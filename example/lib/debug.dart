import 'package:flutter/material.dart';
// ignore: implementation_imports - for debugging, not used in the actual package
import 'package:flutter_typeahead/src/common/base/floater.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  AxisDirection direction = AxisDirection.down;
  bool anchorTop = true;
  bool anchorBottom = false;
  bool anchorLeft = true;
  bool anchorRight = true;
  _DebugScenario scenario = _DebugScenario.basic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _ControlBar(
          direction: direction,
          anchorTop: anchorTop,
          anchorBottom: anchorBottom,
          anchorLeft: anchorLeft,
          anchorRight: anchorRight,
          scenario: scenario,
          onDirectionChanged: (v) => setState(() => direction = v),
          onAnchorTopChanged: (v) => setState(() => anchorTop = v),
          onAnchorBottomChanged: (v) => setState(() => anchorBottom = v),
          onAnchorLeftChanged: (v) => setState(() => anchorLeft = v),
          onAnchorRightChanged: (v) => setState(() => anchorRight = v),
          onScenarioChanged: (v) => setState(() => scenario = v),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: ClipRect(
          child: _DebugOverlay(
            scenario: scenario,
            direction: direction,
            anchor: _anchor,
          ),
        ),
      ),
    );
  }

  FloaterAnchor get _anchor => FloaterAnchor.only(
        top: anchorTop,
        bottom: anchorBottom,
        left: anchorLeft,
        right: anchorRight,
      );
}

enum _DebugScenario {
  basic('Basic'),
  scrollable('Scrollable'),
  pageView('PageView'),
  nearEdge('Near Edge');

  const _DebugScenario(this.label);
  final String label;
}

class _ControlBar extends StatelessWidget {
  const _ControlBar({
    required this.direction,
    required this.anchorTop,
    required this.anchorBottom,
    required this.anchorLeft,
    required this.anchorRight,
    required this.scenario,
    required this.onDirectionChanged,
    required this.onAnchorTopChanged,
    required this.onAnchorBottomChanged,
    required this.onAnchorLeftChanged,
    required this.onAnchorRightChanged,
    required this.onScenarioChanged,
  });

  final AxisDirection direction;
  final bool anchorTop, anchorBottom, anchorLeft, anchorRight;
  final _DebugScenario scenario;
  final ValueChanged<AxisDirection> onDirectionChanged;
  final ValueChanged<bool> onAnchorTopChanged;
  final ValueChanged<bool> onAnchorBottomChanged;
  final ValueChanged<bool> onAnchorLeftChanged;
  final ValueChanged<bool> onAnchorRightChanged;
  final ValueChanged<_DebugScenario> onScenarioChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SegmentedButton<AxisDirection>(
            segments: const [
              ButtonSegment(
                  value: AxisDirection.down,
                  icon: Icon(Icons.arrow_downward, size: 16)),
              ButtonSegment(
                  value: AxisDirection.up,
                  icon: Icon(Icons.arrow_upward, size: 16)),
              ButtonSegment(
                  value: AxisDirection.left,
                  icon: Icon(Icons.arrow_back, size: 16)),
              ButtonSegment(
                  value: AxisDirection.right,
                  icon: Icon(Icons.arrow_forward, size: 16)),
            ],
            selected: {direction},
            onSelectionChanged: (v) => onDirectionChanged(v.first),
          ),
          const SizedBox(width: 8),
          FilterChip(
              label: const Text('T'),
              selected: anchorTop,
              onSelected: onAnchorTopChanged),
          FilterChip(
              label: const Text('B'),
              selected: anchorBottom,
              onSelected: onAnchorBottomChanged),
          FilterChip(
              label: const Text('L'),
              selected: anchorLeft,
              onSelected: onAnchorLeftChanged),
          FilterChip(
              label: const Text('R'),
              selected: anchorRight,
              onSelected: onAnchorRightChanged),
          const SizedBox(width: 8),
          PopupMenuButton<_DebugScenario>(
            initialValue: scenario,
            onSelected: onScenarioChanged,
            itemBuilder: (context) => [
              for (final s in _DebugScenario.values)
                PopupMenuItem(value: s, child: Text(s.label)),
            ],
            child: Chip(label: Text(scenario.label)),
          ),
        ],
      ),
    );
  }
}

class _DebugOverlay extends StatefulWidget {
  const _DebugOverlay({
    required this.scenario,
    required this.direction,
    required this.anchor,
  });

  final _DebugScenario scenario;
  final AxisDirection direction;
  final FloaterAnchor anchor;

  @override
  State<_DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<_DebugOverlay> {
  late final OverlayEntry _scenarioEntry;

  @override
  void initState() {
    super.initState();
    _scenarioEntry = OverlayEntry(builder: _buildScenario);
  }

  @override
  void didUpdateWidget(covariant _DebugOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scenarioEntry.markNeedsBuild();
  }

  @override
  void dispose() {
    _scenarioEntry.dispose();
    super.dispose();
  }

  Widget _buildScenario(BuildContext context) {
    return switch (widget.scenario) {
      _DebugScenario.basic =>
        _BasicScenario(direction: widget.direction, anchor: widget.anchor),
      _DebugScenario.scrollable =>
        _ScrollableScenario(direction: widget.direction, anchor: widget.anchor),
      _DebugScenario.pageView =>
        _PageViewScenario(direction: widget.direction, anchor: widget.anchor),
      _DebugScenario.nearEdge =>
        _NearEdgeScenario(direction: widget.direction, anchor: widget.anchor),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [_scenarioEntry],
    );
  }
}

class _DebugFloater extends StatefulWidget {
  const _DebugFloater({
    required this.direction,
    required this.anchor,
    this.targetSize = const Size(200, 60),
  });

  final AxisDirection direction;
  final FloaterAnchor anchor;
  final Size targetSize;

  @override
  State<_DebugFloater> createState() => _DebugFloaterState();
}

class _DebugFloaterState extends State<_DebugFloater> {
  final FloaterLink link = FloaterLink();
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    link.dispose();
    super.dispose();
  }

  void _onScroll() {
    link.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Floater(
      link: link,
      direction: widget.direction,
      anchor: widget.anchor,
      builder: (context) {
        final data = Floater.of(context);
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${data.size.width.round()}x${data.size.height.round()}\n'
                '${data.effectiveDirection.name}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                    ),
              ),
            ),
          ),
        );
      },
      child: FloaterTarget(
        link: link,
        child: Container(
          width: widget.targetSize.width,
          height: widget.targetSize.height,
          decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(color: Colors.orange.shade800, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            'target',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class _BasicScenario extends StatelessWidget {
  const _BasicScenario({
    required this.direction,
    required this.anchor,
  });

  final AxisDirection direction;
  final FloaterAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _DebugFloater(direction: direction, anchor: anchor),
    );
  }
}

class _ScrollableScenario extends StatelessWidget {
  const _ScrollableScenario({
    required this.direction,
    required this.anchor,
  });

  final AxisDirection direction;
  final FloaterAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < 5; i++) const SizedBox(height: 100),
          Center(
            child: _DebugFloater(direction: direction, anchor: anchor),
          ),
          for (int i = 0; i < 20; i++) const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _PageViewScenario extends StatelessWidget {
  const _PageViewScenario({
    required this.direction,
    required this.anchor,
  });

  final AxisDirection direction;
  final FloaterAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        for (int i = 1; i <= 3; i++)
          Container(
            color: Colors.grey.withValues(alpha: 0.05 * i),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Page $i',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _DebugFloater(direction: direction, anchor: anchor),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _NearEdgeScenario extends StatelessWidget {
  const _NearEdgeScenario({
    required this.direction,
    required this.anchor,
  });

  final AxisDirection direction;
  final FloaterAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _DebugFloater(
          direction: direction,
          anchor: anchor,
          targetSize: const Size(120, 40),
        ),
      ),
    );
  }
}
