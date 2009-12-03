package Norris::Web::Controller::PointsOfInterest;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Norris::Web::Controller::PointsOfInterest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Norris::Web::Controller::PointsOfInterest in PointsOfInterest.');
}


=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
