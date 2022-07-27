import 'package:explorer/providers/greate_places.dart';
import 'package:explorer/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({Key? key}) : super(key: key);

  static const routeName = 'place-detail';
  
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments!;
    final selectedPlace = Provider.of<GreatePlaces>(context, listen: false)
        .selectPlaceById(id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            child: Image.file(
              selectedPlace.image!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Text(
            selectedPlace.location!.address!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                        initialLocation: selectedPlace.location!,
                        isSelecting: false,
                      )));
            },
            child: Text('View on Map'),
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}
