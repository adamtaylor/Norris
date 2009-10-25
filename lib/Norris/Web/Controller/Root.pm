package Norris::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Norris::Web::Controller::Root - Root Controller for Norris::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

Display the default template index.tt.

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 default

If an unknown URL is requested responde with a 404 Page not found.

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 scan

Handle the form submission on the index page.

=cut

sub scan :Local {
    my ( $self, $c ) = @_;
    my $url = $c->req->body_params->{url};
    $c->model('TheSchwartz')->insert( 'Norris::Scanner::Crawl', $url );
    $c->stash(
        url => $url,
        result => $url,
        template => 'index.tt',
    )
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
    my $errors = scalar @{$c->error};
    if ( $errors ) {
        $c->res->status(500);
        $c->res->body('internal server error');
        $c->clear_errors;
    }
}

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
