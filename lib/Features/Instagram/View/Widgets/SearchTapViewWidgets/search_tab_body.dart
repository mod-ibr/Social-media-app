import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchTabBody extends StatelessWidget {
  SearchTabBody({Key? key}) : super(key: key);

  final List<String> images = [
    "https://imgflip.com/s/meme/Unpopular-Opinion-Puffin.jpg",
    "https://imgflip.com/s/meme/Grumpy-Cat.jpg",
    "https://imgflip.com/s/meme/Lazy-College-Senior.jpg",
    "https://imgflip.com/s/meme/Evil-Toddler.jpg",
    "https://imgflip.com/s/meme/College-Freshman.jpg",
    "https://imgflip.com/s/meme/confession-kid.jpg",
    "https://imgflip.com/s/meme/I-Should-Buy-A-Boat-Cat.jpg",
    "https://imgflip.com/s/meme/Unhelpful-High-School-Teacher.jpg",
    "https://imgflip.com/s/meme/Engineering-Professor.jpg",
    "https://imgflip.com/s/meme/Surprised-Koala.jpg",
    "https://imgflip.com/s/meme/Business-Cat.jpg",
    "https://imgflip.com/s/meme/Unpopular-Opinion-Puffin.jpg",
    "https://imgflip.com/s/meme/Grumpy-Cat.jpg",
    "https://imgflip.com/s/meme/Lazy-College-Senior.jpg",
    "https://imgflip.com/s/meme/Evil-Toddler.jpg",
    "https://imgflip.com/s/meme/College-Freshman.jpg",
    "https://imgflip.com/s/meme/confession-kid.jpg",
    "https://imgflip.com/s/meme/I-Should-Buy-A-Boat-Cat.jpg",
    "https://imgflip.com/s/meme/Unhelpful-High-School-Teacher.jpg",
    "https://imgflip.com/s/meme/Engineering-Professor.jpg",
    "https://imgflip.com/s/meme/Surprised-Koala.jpg",
    "https://imgflip.com/s/meme/Business-Cat.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchWidget(),
        _gridViewWidget(),
      ],
    );
  }

  Widget _item(pos) {
    return Card(elevation: 2, child: Image.network(images[pos]));
  }

  Widget _searchWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      height: 45,
      child: CupertinoSearchTextField(
        onChanged: (String value) {
          print('The text has changed to: $value');
        },
        onSubmitted: (String value) {
          print('Submitted text: $value');
        },
      ),
    );
  }

  Widget _gridViewWidget() {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) => _item(index),
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
        crossAxisSpacing: 0.0,
      ),
    );
  }
}
