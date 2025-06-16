part of site_ratings_module;

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;

  const StarRating({
    this.starCount = 5,
    this.rating = .0,
    this.color = SLInternalText.ratedStarColor,
    this.size = 24,
  });

  Widget buildStar(BuildContext context, int index) {
    Widget icon;
    if (index >= rating) {
      // Full grey stars
      icon = UnratedStar(
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      // Half gold stars
      icon = PartialStar(
        size: size,
      );
    } else {
      // Full gold stars
      icon = RatedStar(
        color: color,
        size: size,
      );
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        starCount,
        (index) => buildStar(context, index),
      ),
    );
  }
}

class RatedStar extends StatelessWidget {
  final Color color;
  final double size;

  const RatedStar({
    this.color = SLInternalText.ratedStarColor,
    this.size = SLInternalText.rateStarSize,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: SLSemanticStrings.ratedStar,
      child: Icon(
        Icons.star,
        color: color, // SiteLocatorConstants.ratedStarColor,
        size: size,
      ),
    );
  }
}

class UnratedStar extends StatelessWidget {
  final double size;

  const UnratedStar({this.size = SLInternalText.rateStarSize});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: SLSemanticStrings.unratedStar,
      child: Icon(
        Icons.star,
        color: SLInternalText.unratedStarColor,
        size: size,
      ),
    );
  }
}

class PartialStar extends StatelessWidget {
  final double size;

  const PartialStar({this.size = SLInternalText.rateStarSize});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: SLSemanticStrings.partialStar,
      child: Icon(
        Icons.star_half,
        color: SLInternalText.ratedStarColor,
        size: size,
      ),
    );
  }
}
