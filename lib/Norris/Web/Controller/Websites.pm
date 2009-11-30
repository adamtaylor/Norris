package Norris::Web::Controller::Websites;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Data::Dumper;

=head1 NAME

Norris::Web::Controller::Websites - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 base

=cut

sub base : Chained('/'): PathPart('websites'): CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash( websites_rs => $c->model('DB::Websites') );
}

=head2 add

Add a new website.

=cut

sub add : Chained('base'): PathPart('add'): Args(0) {
    my ($self, $c) = @_;
    
    if (lc $c->req->method eq 'post') {
        my $params = $c->req->params;
        
        my $websites_rs = $c->stash->{websites_rs};
        
        my $new_website = $websites_rs->create({
            url => $params->{url},
            name => $params->{name},
        });
        
        return;
    }
}

=head2 index

View a list of all the websites stored in the application.

=cut

sub index : Chained('base'): PathPart('index'): Args(0) {
    my ($self, $c) = @_;
    
    
    return
}

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
