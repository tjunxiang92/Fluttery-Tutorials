import 'package:flutter/material.dart';
import 'package:flutter_rocks_movie_details/actor_scroller.dart';
import 'package:flutter_rocks_movie_details/arc_banner_image.dart';
import 'package:flutter_rocks_movie_details/models.dart';
import 'package:flutter_rocks_movie_details/movie_detail_header.dart';
import 'package:flutter_rocks_movie_details/photo_scroller.dart';
import 'package:flutter_rocks_movie_details/poster.dart';
import 'package:flutter_rocks_movie_details/rating_information.dart';
import 'package:flutter_rocks_movie_details/storyline.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;
  MovieDetailsPage(this.movie);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new MovieDetailHeader(movie),
            new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Storyline(movie.storyline),
            ),
            new PhotoScroller(movie.photoUrls),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
              child: new ActorScroller(movie.actors),
            ),
          ],
        ),
      )
    );
  }
}

