#!usr\bin\perl

open(my $fh, "<", "pbf_tabs.txt") or die "can't open pbr_tabs.txt";
my $header = "<style>
	table {
		width : 100%;
		position : absolute;

	}
	tr:nth-child(odd) {
		background: #f8f8f8;
	}
	#sold {
		background: #787878;
	}
	#rightcolumn {
	    position : fixed;
	    top      : 0;
	    right    : 0;
	    height   : 100%;
	    width    : 50%;
	}
	#leftcolumn {
	    position : absolute;
	    top      : 0;
	    left     : 0;
	    height   : 100%;
	    width    : 50%;
	}
</style>";

my $pageOUT = "$header<div id=\"leftcolumn\">\n<table>";
while( my $line = <$fh>)  {   
    my @row = split('\t',$line);
    #print @row[0]."\n";
    my $link ="";
    my $imgLink = "";
    #wont always be a link
    if(trim(@row[0]) ne "-") {
    	@row[1] = trim(@row[1]);
    	$link = "<a name=\"@row[1]\" href=\"@row[0]\" target=\"content\">@row[1]</a>";
    	my $comicNum = @row[0];
    	$comicNum =~ /.*\/([0-9]+)\/$/;
    	$comicNum = $1;
    	my $dashName = @row[1];
    	$dashName =~ s/\s/_/g;
    	$imgURL = "http://pbfcomics.com/archive_b/PBF$comicNum-$dashName.png";
    	$imgLink = "<a name=\"@row[1]img\" href=\"$imgURL\" target=\"content\">IMAGE</a>";

    	#$imgLink = http://pbfcomics.com/archive_b/PBF253-The_Last_Unicorns.jpg
    }
    else { $link = "@row[1]"; $imgLink = "-"}
    if ($row[3] !~ m/[0-9]/) {
	    $pageOUT.="\t<tr id=\"sold\">\n";
	}
	else {    $pageOUT.="\t<tr>\n"; }
    foreach ($link, @row[2..3]) {
    	$pageOUT.="\t\t<td>$_</td>\n";
    }
    $pageOUT.="\t</tr>\n";
}

$pageOUT.="</div>
<div id=\"rightcolumn\">
	<iframe name=\"content\" src=\"http://pbfcomics.com\" width = \"100%\" height = \"100%\" frameborder=\"0\">
</div>";
open (FILEOUT, '>pbrTABLE.html');
print FILEOUT $pageOUT;
close (FILEOUT) or die "can't write"; 

close $fh;

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };