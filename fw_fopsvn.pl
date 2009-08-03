#!/usr/bin/perl

# This script (sculpted from publish.pl) will check the last tarball (which must be there)
# based on the fw_fop xml version number and then run svn log against all updates since
# fw_fop was last published.
#
$rver = "2.5";
$fwbranch = "branches/2.6";
$fw_fop = "fw_fop";

$moddir = 'fw_fop';

my $reldir = "release/";

	open FH, "$moddir/module.xml"; 
	$newxml = "";
	$vers = "unset";
	while (<FH>) {
		if ($vers == 'unset' && /<version>(.+)<\/version>/) { $vers = $1; }
		$newxml .= $_;
	}
	close FH;

	die "Don't know version of $moddir" if ($vers eq "unset");
	# Automatically check in any files that were modified but weren't checked into SVN

	# Now we know the version. Get the svnversion.txt from the last update.
	$filename = "../../$reldir"."$rver/$fw_fop-$vers.tgz";
	print "CHECKING VERSION: ..... ";
	#print "CHECKING VERSION WITH: tar -zxOf $filename $moddir/svnversion.txt: ...  ";
	system("tar -zxOf ".$filename." ".$moddir."/svnversion.txt");
	print "Geting svn log since that version for $rver : .... \n\n";
	$svnver = system("svn log http://svn.freepbx.org/freepbx/$fwbranch/amp_conf/htdocs_panel -r `tar -zxOf ".$filename." ".$moddir."/svnversion.txt | sed -e s/SVN\\\ VERSION://`:HEAD");

