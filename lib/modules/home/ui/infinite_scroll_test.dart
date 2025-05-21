import 'package:flutter/material.dart';

class InfiniteNestedList extends StatefulWidget {
  const InfiniteNestedList({super.key});

  @override
  State<InfiniteNestedList> createState() => _InfiniteNestedListState();
}

class _InfiniteNestedListState extends State<InfiniteNestedList> {
  final List<String> verticalItems = List.generate(20, (i) => "Vertical ${i + 1}");
  static const int _infiniteIndex = 100000;

  final Map<int, ScrollController> _horizontalControllers = {};

  @override
  void initState() {
    super.initState();
    // Delay is needed to let ListView attach
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < verticalItems.length; i++) {
        _horizontalControllers[i] =
            ScrollController(initialScrollOffset: _infiniteIndex * 100.0);
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _horizontalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nested Infinite Scroll")),
      body: ListView.builder(
        controller: ScrollController(initialScrollOffset: _infiniteIndex * 120.0),
        itemExtent: 120,
        itemBuilder: (context, verticalIndex) {
          final vIndex = verticalIndex % verticalItems.length;
          final horizontalItems = List.generate(10, (j) => "H ${j + 1}");

          return Column(
            children: [
              Text(verticalItems[vIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontalControllers.putIfAbsent(
                    vIndex,
                        () => ScrollController(initialScrollOffset: _infiniteIndex * 100.0),
                  ),
                  itemExtent: 100,
                  itemBuilder: (context, horizontalIndex) {
                    final hIndex = horizontalIndex % horizontalItems.length;
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        horizontalItems[hIndex],
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


