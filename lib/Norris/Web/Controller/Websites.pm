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
    
    return;
}

=head2 delete

Delete a given website.

=cut

sub delete : Chained('base'): PathPart('delete'): Args(1) {
    my ($self, $c, $id) = @_;
    
    my $websites_rs = $c->stash->{websites_rs};
    
    my $website = $websites_rs->search( id => $id );
    $website->delete();
    
    $c->redirect('/websites/index/');
    
    return;
    
}

=head2 report

View a given website's vulnerability report.

=cut

sub report : Chained('base'): PathPart('report'): Args(1) {
    my ($self, $c, $id) = @_;
    
    my $websites_rs = $c->stash->{websites_rs};
    
    my $website = $websites_rs->search( id => $id );    
    
    #die Dumper $website;
    
    $c->stash( website_rs => $website );
    $c->stash( id => $id );
    
    ## count for pie chart
    my %count = ();
    my $total;
    foreach my $point ($website->find($id)->points_of_interest() ) {
        foreach my $vuln ($point->vulnerabilities) {
            $count{$vuln->type}++;
            print STDERR Dumper $vuln->type . ' ' . $count{$vuln->type} ."\n";
            $total++;
        }
    }

    while ( my ($type, $type_count) = each(%count) ) {
            $count{$type} = ( $count{$type} / $total ) * 100;
    }
   
    $c->stash( count => \%count );
    
    return;
}

=head1 AUTHOR

Adam Taylor

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
