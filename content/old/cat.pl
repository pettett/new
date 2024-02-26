#!/usr/bin/perl
use Storable;
use Switch;
use CGI qw(:standard);

print header;

my @books = @{retrieve("cat.dat")};

$searchfield = param("f");
$search = param("search");
if(($searchfield eq "status" ||
    $searchfield eq "num" ||
    $searchfield eq "box" ||
    $searchfield eq "author" ||
    $searchfield eq "title")&& $search ne ""){
    @books = grep {$_->{$searchfield} =~ /$search/i} @books; 
}

$sort = param('s');
if($sort eq "status" ||
    $sort eq "num" ||
    $sort eq "box" ||
    $sort eq "author" ||
    $sort eq "title" ){
    if(param(dir) eq "d"){
        @books = sort {$b->{$sort} cmp $a->{$sort}} @books;
    }
    else{
        @books = sort {$a->{$sort} cmp $b->{$sort}} @books;
    }
}

open(HEAD,"head.txt");
while(<HEAD>){print $_;}
close(HEAD);


print   start_form,
        h2("Search"),
        "Search: ",textfield('search'),
        popup_menu(-name=>'f',
	       -values=>['status','num','box','title','author'],
     	       -labels=>{'status'=>'Status',
                 'num'=>'Number',
                 'box'=>'Box',
                 'title'=>'Title',
                 'author'=>'Author'},
                -default=>'author'),
        p,
        submit("Search"),
        end_form;
print "<table style=\"font-family:monospace\">\n";
print "<thead>\n";
print "<tr>\n";
print tablehead('status','Status');
print tablehead('num','Number');
print tablehead('box','Box');
print tablehead('author','Author');
print tablehead('title','Title');
print "</tr>\n";
print "</thead>";
print "<tbody>\n";
foreach(@books){
	    print "<tr>";
	    print "<td>" . $_->{'status'} . "</td>\n";
	    print "<td>" . $_->{'num'} . "</td>\n";
	    print "<td>" . $_->{'box'} . "</td>\n";
	    print "<td>" . $_->{'author'} . "</td>\n";
	    print "<td>" . $_->{'title'} . "</td>\n";
	    print "</tr>";
}
print "</tbody></table>\n";
print "</body></html>\n";

sub tablehead(){
    my ($s, $name) = @_;
    return "<th><a href=\"?dir=a&s=" . $s . "&f=" . $searchfield . "&search=" . $search . "\">&lt;</a>" .
           $name .
           "<a href=\"?dir=d&s=" . $s . "&f=" . $searchfield . "&search=" . $search . "\">&gt;</a></th>"
}
