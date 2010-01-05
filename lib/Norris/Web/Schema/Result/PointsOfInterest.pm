package Norris::Web::Schema::Result::PointsOfInterest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("points_of_interest");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "url",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-19 13:46:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h/Of4XhISYBmg2ICusBCcg
__PACKAGE__->has_many(
    "point_of_interest_vulnerability",
    "Norris::Web::Schema::Result::PointOfInterestVulnerability",
    { "foreign.point_of_interest_id" => "self.id" },
);

__PACKAGE__->many_to_many('vulnerabilities','point_of_interest_vulnerability','vulnerability');

__PACKAGE__->has_many(
    "website_point_of_interest",    
    "Norris::Web::Schema::Result::WebsitePointOfInterest",
    { "foreign.point_of_interest_id" => "self.id" },
);

__PACKAGE__->many_to_many('websites', 'website_point_of_interest', 'website');


1;
