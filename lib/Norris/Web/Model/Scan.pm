package Norris::Web::Model::Scan;

use strict;
use warnings;
use parent 'Catalyst::Model';

=head1 NAME

Norris::Web::Model::Scan - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub scan {
    my ( $self, $url ) = @_;
    return $url;
}

1;
