use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Norris::Web' }
BEGIN { use_ok 'Norris::Web::Controller::PointsOfInterest' }

ok( request('/pointsofinterest')->is_success, 'Request should succeed' );


