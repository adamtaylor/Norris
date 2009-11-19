package Norris::Web::Schema::Result::WebsitePointOfInterest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("website_point_of_interest");
__PACKAGE__->add_columns(
  "website_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
  "point_of_interest_id",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("website_id", "point_of_interest_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-19 13:46:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iBiEYzn35Yxz6BWYvhKOoQ

__PACKAGE__->belongs_to(
    "website_id",
    "Norris::Web::Schema::Result::Websites",
    { "id" => "website_id" }
);

__PACKAGE__->belongs_to(
    "point_of_interest",
    "Norris::Web::Schema::Result::PointsOfInterest",
    { "foreign.id" => "point_of_interest_id" }
);

1;
