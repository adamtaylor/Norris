package Norris::Web::View::Web;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    # Set the location for TT files
    # INCLUDE_PATH => [
    #         Norris::Web->path_to( 'root', 'src', 'websites' ),
    #     ],
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER   => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'page.tt',
    );

=head1 NAME

Norris::Web::View::Web - TT View for Norris::Web

=head1 DESCRIPTION

TT View for Norris::Web.

=head1 SEE ALSO

L<Norris::Web>

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
