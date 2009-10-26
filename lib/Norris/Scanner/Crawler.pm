package Norris::Scanner::Crawler;

use TheSchwartz::Job;
use base qw( TheSchwartz::Worker );
use WWW::Mechanize;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    print STDERR "Workin' hard or hardly workin'? Hyuk!!\n";
    
    my $args = $job->arg();
    
    print STDERR "base_url = ". $args->{'base_url'}."\n";

    $job->completed();
}


1;