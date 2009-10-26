package Norris::Web::Model::TheSchwartz;

use strict;
use warnings;
use parent 'Catalyst::Model';
use lib '../../../../lib/';
use Norris::TheSchwartzWrapper;

=head1 NAME

Norris::Web::Model::TheSchwartz - Catalyst Model

=head1 DESCRIPTION

Provides access to TheSchwartzWrapper which in turn provides access to a
TheSchwartz object for handling the job queue.

By using the COMPONENT attribute it makes this model a wrapper, for a wrapper,
allowing things like $c->Model('TheSchwartz')->insert(...).

In other words, it opens up TheSchwartz's API to our controllers.

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub COMPONENT {
    return Norris::TheSchwartzWrapper->new();
}

1;
