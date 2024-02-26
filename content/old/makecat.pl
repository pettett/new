#!/usr/bin/perl

use Storable;

open(IN,"cat.txt");
my @books = ();
while(<IN>){
    s/&amp;/&/g;
    m/(.) (.{5}) {2}(.{3}) {3}(.{20})(.{4})(.*)/;
    my %book = (
        status => $1,
        num    => $2,
        box    => $3,
    );
    if($5 eq "The " || $5 eq "  A "){
        $book{'author'} = $4;
        $book{'title'} = $6 . ", " . $5;
    }
    else{
        $book{'author'} = $4 . $5;
        $book{'title'} = $6;
    }
    $book{'status'} =~ s/^\s+|\s+$//g;
    $book{'num'} =~ s/^\s+|\s+$//g;
    $book{'box'} =~ s/^\s+|\s+$//g;
    $book{'title'} =~ s/^\s+|\s+$//g;
    $book{'title'} =~ s/^(The )(.*)/$2, The/;
    $book{'author'} =~ s/^\s+|\s+$//g;
    @books = (@books, \%book);
}
close(IN);

store(\@books, "cat.dat");

print "Done!";
