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
    
    ## timestamp start
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,
    $yday,$isdst)=localtime(time);
    printf "%4d-%02d-%02d %02d:%02d:%02d\n",
    $year+1900,$mon+1,$mday,$hour,$min,$sec;
    
    my $args = $job->arg();
    
    #print STDERR Dumper $args;

    my $mech = WWW::Mechanize->new();
    
    my $url         = $args->{'url'};
    # my $form        = $args->{'form'};
    # my $uri         = $args->{'uri'};
    my ($form, $uri);
    if ($args->{'form'}) { $form = $args->{'form'}; $uri = undef; }
    if ($args->{'uri'}) { $uri = $args->{'uri'}; $form = undef; }
    my $website_id  = $args->{'id'};
    
    my $point_id;
    
    #print STDERR "\$uri == $uri -- \$form == $form\n";
    
    if ($uri) { 
        $point_id = _insert_point_of_interest( $website_id, $uri ); 
        _try_dir_traversal_attack( $point_id, $url, $uri, $mech );
    }
    elsif ($form) { 
        $point_id = _insert_point_of_interest( $website_id, $form ); 
        _try_xss_attacks( $point_id, $url, $form, $mech );
        _try_sql_injection_attacks( $point_id, $url, $form, $mech );
    }
    
    ## timestamp end
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,
    $yday,$isdst)=localtime(time);
    printf "%4d-%02d-%02d %02d:%02d:%02d\n",
    $year+1900,$mon+1,$mday,$hour,$min,$sec;
    
    $job->completed();
}

sub _insert_point_of_interest {
    my ($website_id, $object) = @_;
    
    my $schema = Norris::Web::Model::DB->new();
    
    my $url;
    if ( ref($object) =~ m/HTML::Form/ ) {
        $url = $object->action();
    } 
    else {
        $url = $object;
    }
    
    my $point_of_interest = $schema->resultset('PointsOfInterest')->create({
        'url' => $url,
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
        q[3,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>] => q[3,83\)\)\/\/\\";alert\(String\.fromCharCode\(88,83,83\)\)\/\/--><\/SCRIPT>\">\'><SCRIPT>alert\(String\.fromCharCode\(88,83,83\)\)<\/SCRIPT>],
        q[';alert(String.fromCharCode(88,83,83))//\';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>] => q[\';alert(String.fromCharCode(88,83,83))//\\\';alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//\\\";alert(String.fromCharCode(88,83,83))//-->\">\'>]
    );
    
    my @form_inputs = $form->inputs();
    
    while ( my ($key, $value) = each(%xss_attack_vectors) ) {
    
        foreach my $form_input (@form_inputs) {
            #print STDERR $form_input->name() .'\n';
            $form->value( $form_input->name(), $key );
            #print STDERR $form->value( $form_input->name() ) . "\n";
        }
    
        my $request = $form->click();
    
        #print STDERR $request;
    
        eval { $mech->request( $request ) };
    
        if ( $mech->success() ) {
        
            #print STDERR "request was successful\n";
                
            #print STDERR Dumper $mech->response->code();
            #print STDERR Dumper $mech->content();
        
            if ( $mech->content() =~ m/$value/gm ) {
                #print STDERR "--- XSS VULNERABILITY FOUND ---\n";
                _insert_vulnerability( $point_id, 'XSS', $value );
                last;
            } else {
                #print STDERR "--- NO XSS FOUND ---\n";
            }
        
        }
    }
}

sub _try_sql_injection_attacks {
    my ($point_id, $url, $form, $mech) = @_;

    my $vector = "'";

    my @form_inputs = $form->inputs();
    
    foreach my $form_input (@form_inputs) {
        $form->value( $form_input->name(), $vector );
        #print STDERR '$form->value( $form_input->name() ) == '. $form->value( $form_input->name() ) . "\n";
    }
    
    #print STDERR Dumper $form;
    
    my $request = $form->click();
    
    #print STDERR Dumper $request;
    
    eval { $mech->request( $request ) };
    
    if ( $mech->status() =~ m/5\d\d/) {
        _insert_vulnerability( $point_id, 'SQLi', $vector );
    }
    
    if ( $mech->success() ) {
        #print STDERR "request was successful\n";
            
        #print STDERR Dumper $mech->response->code();
        
        #print STDERR $mech->content();
        
        
        if ( ($mech->content() =~ m/SQL/gi && $mech->content() =~ m/error/gi) || $mech->status() =~ m/5../gi || $mech->content() =~ m/Microsoft Access Driver/gi || $mech->content() =~ m/Syntax error/gi || $mech->content() =~ m/Incorrect syntax/gi ) {
            #print STDERR "--- SQLi VULNERABILITY FOUND -> Point ID = $point_id ---\n";
            
            #print STDERR $mech->content();
            
            _insert_vulnerability( $point_id, 'SQLi', $vector );
        } else {
            #print STDERR "--- NO SQLi FOUND ---\n";
        }
    }
}

sub _try_dir_traversal_attack {
    my ($point_id, $url, $uri, $mech) = @_;
    
    my ($param, $value) = $uri->query_form;
    
    #print STDERR "\$param == $param - \$value == $value \n";
    
    my $request;
    for(1..15) {
        $request = '../'x$_ . 'etc/passwd';
        #print STDERR $request . "\n";
        
        $uri->query_form( $param => $request );
        
        #print STDERR $uri->as_string . "\n";
        
        eval { $mech->get( $uri->as_string ) };
        
        if ( $mech->success() ) {
            #print STDERR "page request successful \n";
            if ( $mech->content() =~ m/root/gi ) {
                #print STDERR "--- Directory Traversal Vulnerability Found ---\n";
                _insert_vulnerability( $point_id, 'Directory_Traversal', $uri->as_string );
                last;
            }
        }   
    }
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
