package Norris::Web::Schema::Result::Websites;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("websites");
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
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-19 13:46:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FvpOxS5cYjU6WE2/zxqwrg

_PACKAGE__->has_many(
    "points_of_interest",    
    "Norris::Web::Schema::Result::PointsOfInterest",
    { "foreign.website_id" => "self.id" },
);

1;
