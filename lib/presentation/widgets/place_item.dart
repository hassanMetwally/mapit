import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../data/models/searched_place.dart';

class PlaceItem extends StatelessWidget {
  final SearchedPlace placePrediction;
  const PlaceItem({required this.placePrediction, super.key});

  @override
  Widget build(BuildContext context) {
    var subTitle = placePrediction.description
        .replaceAll(placePrediction.description.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.lightBlue),
                child: const Icon(
                  Icons.place,
                  color: AppColors.blue,
                ),
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${placePrediction.description.split(',')[0]}\n',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: subTitle.length > 1
                          ? subTitle.substring(1).trim()
                          : subTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
