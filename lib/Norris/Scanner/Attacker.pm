package Norris::Scanner::Attacker;
use strict;
use warnings;
use TheSchwartz::Job;
use base qw( TheSchwartz::Worker );
use WWW::Mechanize;
use Data::Dumper;
use URI;
use lib '../../';
use Norris::Web::Model::DB;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    
    my $args = $job->arg();
    
    #print STDERR Dumper $args;

    my $mech = WWW::Mechanize->new();
    
    my $url     = $args->{'url'};
    my $form    = $args->{'form'};
    my $id      = $args->{'id'};
    
    #insert_point_of_interest( $id, $form );
    try_xss_attacks( $id, $url, $form, $mech );
    #try_sql_injection_attacks( $id, $form );
    
    $job->completed();
}

sub insert_point_of_interest {
    my ($id, $form) = @_;
    
    my $schema = Norris::Web::Model::DB->new();
    
}

sub try_xss_attacks {
    my ($id, $url, $form, $mech) = @_;
    
    my @xss_attack_vectors = (
      
        "<script>alert('XSS')</script>",
        "'';!--\"<XSS>=&{()}\"",
        
    );
    
    my @form_inputs = $form->inputs();
    
    foreach my $form_input (@form_inputs) {
        #print STDERR $form_input->name() .'\n';
        $form->value( $form_input->name(), $xss_attack_vectors[0] );
    }
    
    my $request = $form->click();
    
    #print STDERR $request;
    
    eval { $mech->request( $request ) };
    
    if ( $mech->success() ) {
        
        print STDERR "request was successful\n";
                
        print STDERR Dumper $mech->response->code();
        print STDERR Dumper $mech->content();
        
    }
    
    
    
}

sub try_sql_injection_attacks {
    my ($id, $form) = @_;
    
}

1;
