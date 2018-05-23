import 'package:flutter/material.dart';
import 'package:flutter_rocks_movie_details/arc_banner_image.dart';
import 'package:flutter_rocks_movie_details/models.dart';
import 'package:flutter_rocks_movie_details/poster.dart';
import 'package:flutter_rocks_movie_details/rating_information.dart';

class MovieDetailHeader extends StatelessWidget {
  final Movie movie;

  MovieDetailHeader(this.movie);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Stack(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
            child: new ArcBannerImage(movie.bannerUrl),
          ),
        new Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: new Row(
            children: <Widget>[
              new Poster(
                url: movie.posterUrl,
                height: 140.0,
              ),
              new Column(
                children: <Widget>[
                  new Text(
                    movie.title,
                    style: textTheme.title,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new RatingInformation(movie),
                  ),
                  // TODO: build chips
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}