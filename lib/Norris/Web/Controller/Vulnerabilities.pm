package Norris::Web::Controller::Vulnerabilities;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Norris::Web::Controller::Vulnerabilities - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Norris::Web::Controller::Vulnerabilities in Vulnerabilities.');
}


=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
