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


# You can replace this text with custom content, and it will be preserved on regeneration
1;
