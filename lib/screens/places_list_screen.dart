import 'package:explorer/screens/places_detail_screen.dart';

import '../providers/greate_places.dart';
import '../screens/add_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatePlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatePlaces>(
                child: const Center(
                  child: Text('Got no places yet , start adding some!'),
                ),
                builder: (ctx, greatePlace, ch) => greatePlace
                        .getItemsPlaces.isEmpty
                    ? ch!
                    : ListView.builder(
                        itemCount: greatePlace.getItemsPlaces.length,
                        itemBuilder: (ctx, index) => ListTile(
                          onTap: () {
                            // Go to page detail ....
                            Navigator.of(context)
                                .pushNamed(PlacesDetailScreen.routeName,arguments: greatePlace.getItemsPlaces[index].id);
                          },
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              greatePlace.getItemsPlaces[index].image!,
                            ),
                          ),
                          title: Text(greatePlace.getItemsPlaces[index].title),
                          subtitle: Text(greatePlace
                                  .getItemsPlaces[index].location!.address ??
                              ''),
                        ),
                      ),
              ),
      ),
    );
  }
}
