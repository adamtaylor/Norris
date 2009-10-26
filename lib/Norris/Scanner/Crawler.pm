package Norris::Scanner::Crawler;

use TheSchwartz::Job;
use base qw( TheSchwartz::Worker );
use WWW::Mechanize;
use Data::Dumper;
use URI;
use lib '../../';
use Norris::TheSchwartzWrapper;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    
    my $args = $job->arg();
    
    #print STDERR "base_url = ". $args->{'base_url'}."\n";
    print STDERR "--- process = ". $args->{'process'}." ---\n";
    #print STDERR "urls_seen = ". $args->{'urls_seen'}."\n";

    my $mech = WWW::Mechanize->new();
    
    my $base_url        = $args->{'base_url'};
    my $processing_url  = $args->{'process'};
    my $urls_seen_ref   = $args->{'urls_seen'};
    
    $mech->get( $processing_url );
    
    if ( $mech->success() ) {
        #print STDERR "grabbed the URL successfully, about to find_all_links\n";
        
        my $response = $mech->response();
                
        if ( $response->header( 'Content-Type' ) =~ /text\/html/ ) {
        
            $urls_seen_ref->{ $processing_url } = 1;
        
            $links = $mech->find_all_links( url_abs_regex => qr/$base_url.*/i);
            
            #print STDERR Dumper \$links;
            
            my $client = Norris::TheSchwartzWrapper->new();
            
            foreach my $link ( @{$links} ) {
                my $url = $class->_clean_url( $link->url );
                #print STDERR $url ."\n";
                
                if ( $urls_seen->{ $url }++ ) {
                    print STDERR "Skipping ". $url ." - already seen\n";    
                }
                else {
                    my $job_args = {
                        base_url => $base_url,
                        urls_seen => { $urls_seen_ref },
                        process => $url
                    };
                    $client->insert( 'Norris::Scanner::Crawler', $job_args );
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