package Norris::Web::Model::TheSchwartz;

use strict;
use warnings;
use parent 'Catalyst::Model';
use TheSchwartz;

=head1 NAME

Norris::Web::Model::TheSchwartz - Catalyst Model

=head1 DESCRIPTION

A wrapper for using TheSchwartz from within our Models.

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub COMPONENT {
    return TheSchwartz->new( database => {
                                            dsn => 'dbi:mysql:norris_jobs',
                                            user => 'root',
                                            pass => ''
                                            } );
}

1;
