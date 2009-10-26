package Norris::Scanner::Crawler;

use TheSchwartz::Job;
use base qw( TheSchwartz::Worker );
use WWW::Mechanize;
use Data::Dumper;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    print STDERR "Workin' hard or hardly workin'? Hyuk!!\n";
    
    my $args = $job->arg();
    
    print STDERR "base_url = ". $args->{'base_url'}."\n";
    print STDERR "process = ". $args->{'process'}."\n";
    print STDERR "urls_seen = ". $args->{'urls_seen'}."\n";

    my $mech = WWW::Mechanize->new();
    
    my $url = $args->{'process'};
    
    $mech->get( $url );
    
    if ( $mech->success() ) {
        print STDERR "grabbed the URL successfully, about to find_all_links\n";
    
        $links = $mech->find_all_links( url_abs_regex => qr/$url.*/i);
        
        #print STDERR Dumper \$links;
        
        foreach my $link (@{$links}) {
            print STDERR $link->url ."\n";
        }
    }

    $job->completed();
}


1;