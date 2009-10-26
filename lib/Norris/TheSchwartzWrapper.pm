package Norris::TheSchwartzWrapper;

use strict;
use warnings;
use base qw /TheSchwartz/;

sub new {
    my $class = shift;
    
    return $class->SUPER::new(
        databases => [ {
            dsn => 'dbi:mysql:norris_jobs',
            user => 'root',
            pass => ''
        } ],
            verbose => 1,
    );
}

1;