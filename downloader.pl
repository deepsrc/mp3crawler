#!usr/bin/perl
use strict;

# Use LWP::Debug qw(+);

use WWW::Mechanize;
use HTTP::Cookies;
use List::MoreUtils qw(uniq);

my $mech = WWW::Mechanize->new();
my $flevel_mech = WWW::Mechanize->new();
my $slevel_mech = WWW::Mechanize->new();
my $cj = HTTP::Cookies->new(file => "./cookies.txt");
my $resp = HTTP::Response->new();
$mech->cookie_jar($cj);

# Handling Command line

print "You have chosen to download songs of the movie:- \'$ARGV[0]\'\n";

# Defining Variables

# 2012 Movies
# my $url = "http://www.apunkabollywood.net/browser/category/view/7038/2012";

# 2011 Movies
my $url = "http://www.apunkabollywood.net/browser/category/view/6372/2011";

CRAWL_PAGE ();

sub CRAWL_PAGE 
{
   $mech->get( $url );
   my $movie_name = lc($ARGV[0]);
   my @all_links = $mech->find_all_links( url_regex => qr/$movie_name/i );
   print $movie_name."\n";

   foreach my $link ( @all_links )
   {
       my $href = $link->url();
       print $href."\n";

       $flevel_mech->get( $link->url() );  
       my @flevel_links = $flevel_mech->find_all_links( url_regex => qr/download.get/i );
       my @uniq_flevel_links = uniq( @flevel_links );
       my $loop_count = 1;

       foreach my $dlink ( @uniq_flevel_links )
       {
           if ( ( $loop_count % 2 ) != 0 )
           { 
               my $dlhref = $dlink->url();
               print "        ".$dlhref."\n";
    
               $slevel_mech->get( $dlink->url() );
               my $mp3_link = $slevel_mech->find_link( url_regex => qr/mp3/i );
    
               print "                ".$mp3_link->url()."\n";
    
               my $final_link = $mp3_link->url();
    
               if ($final_link =~ /\.mp3\.1/)
               {
                   print "Need not download the one with .1 extension\n";
               }
               else
               {
                   `wget "$final_link"`;
               }
           }
           $loop_count++;
       }
   }
}
