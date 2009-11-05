package Norris::Scanner::Crawler;
use strict;
use warnings;
use TheSchwartz::Job;
use base qw( TheSchwartz::Worker );
use WWW::Mechanize;
use Data::Dumper;
use URI;
use lib '../../';
use Norris::TheSchwartzWrapper;

## todo refactor this...
sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    
    my $args = $job->arg();
    
    #print STDERR "base_url = ". $args->{'base_url'}."\n";
    #   print STDERR "--- process = ". $args->{'process'}." ---\n";
    #print STDERR "urls_seen = ". $args->{'urls_seen'}."\n";

    print STDERR Dumper $args;

    my $mech = WWW::Mechanize->new();
    
    my $base_url        = $args->{'base_url'};
    my $processing_url  = $args->{'process'};
    my $urls_seen_ref   = $args->{'urls_seen'};
    
    my @queue = ();
    
    my $job_args = {
                        base_url => $base_url,
                        process => $processing_url,
                        urls_seen => $urls_seen_ref,
                    };
    
    print STDERR Dumper $job_args;
    
    
    unshift(@queue, $job_args);
    
    while ( @queue >= 1 ) {
    
        $job_args = shift(@queue);
        
        my $base_url = $job_args->{'base_url'};
        my $processing_url = $job_args->{'process'};
        my $urls_seen_ref = $job_args->{'urls_seen'};
    
        eval { $mech->get( $processing_url ) };
        
        if ( $mech->success() ) {
            #print STDERR "grabbed the URL successfully, about to find_all_links\n";
            
            my $response = $mech->response();
                    
            if ( $response->header( 'Content-Type' ) =~ /text\/html/ ) {
                
                my $client = Norris::TheSchwartzWrapper->new();
            
                $urls_seen_ref->{ $processing_url } = 1;
            
                my $links = $mech->find_all_links( url_regex => qr/^$base_url.*/i);
                
                #my $forms = $mech->forms();
                #
                #if ( defined($forms) ) {
                #    foreach my $form (@{$forms}) {
                #        print STDERR "form action = ". $form->action() ."\n";
                #        my $job_args = {
                #            url => $processing_url,
                #            form => $form
                #        };
                #        #$client->insert( 'Norris::Scanner::Attacker', $job_args );
                #    }
                #}
                
                #print STDERR Dumper \$links;
                
                
                foreach my $link ( @{$links} ) {
                    my $url = $class->_clean_url( $link->url );
                    #print STDERR $url ."\n";
                    
                    if ( $urls_seen_ref->{ $url }++ ) {
                        #print STDERR "Skipping ". $url ." - already seen\n";    
                    }
                    else {
                        my $job_args = {
                            base_url => $base_url,
                            urls_seen => $urls_seen_ref ,
                            process => $url
                        };
                        
                        print STDERR Dumper $job_args;
                        
                        unshift(@queue,$job_args);
                        
                        #$client->insert( 'Norris::Scanner::Crawler', $job_args );
                    }
                }
            
            }
        }
    
    }

    $job->completed();
}

## todo move code into resuable helper
sub _clean_url {
    my $class = shift;
    my $url   = shift;
    
    my $u = URI->new($url)->canonical;
    
    $u->fragment(undef);
    
    return $u->as_string;
}


1;

1;
