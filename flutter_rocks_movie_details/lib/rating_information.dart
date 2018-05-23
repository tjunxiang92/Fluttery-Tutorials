import 'package:flutter/material.dart';
import 'package:flutter_rocks_movie_details/models.dart';

class RatingInformation extends StatelessWidget {
  final Movie movie;

  RatingInformation(this.movie);
  
  _renderStars(ThemeData theme) {
    var stars = <Widget>[];
    for (var i = 0; i < 5; i++) {
      var color = movie.starRating > i ? theme.accentColor : Colors.black12;
      stars.add(
        new Icon(
          Icons.star,
          color: color,
        ),
      );
    }

    return new Row(children: stars);
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption.copyWith(color: Colors.black45);

    var numericRating = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          movie.rating.toString(),
          style: textTheme.title.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.accentColor,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: new Text(
            'Ratings',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );

    var starRating = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _renderStars(theme),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child: new Text(
            'Grade now',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );

    return new Row(
      children: [
        numericRating,
        new Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: starRating,
        ),
      ],
    );
  }

  
}