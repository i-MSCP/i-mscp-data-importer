#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib", '/var/www/imscp/engine/PerlLib';

use iMSCP::Debug;
use iMSCP::Requirements;
use iMSCP::Bootstrapper;
use iMSCP::Dialog;

$ENV{'LC_MESSAGES'} = 'C';

# Do not clear screen at end of script
$ENV{'IMSCP_CLEAR_SCREEN'} = 0;

newDebug('imscp-data-importer.log');

# Entering in silent mode
silent(1);

# Ensure that this script is run by root user
iMSCP::Requirements->new()->user();

# Bootstrap environment
my $bootstrapper = iMSCP::Bootstrapper->getInstance();
$bootstrapper->boot('nolock' => 'yes');

my @locks = (
	'imscp-backup-all', 'imscp-backup-imscp', 'imscp-dsk-quota', 'imscp-srv-traff', 'imscp-vrl-traff',
	'awstats_updateall.pl', 'imscp'
);

my @runningProcesses = ();

for(@locks) {
	if(! $bootstrapper->getInstance()->lock("/tmp/$_.lock", 'nowait')) {
		 push @runningProcesses, ($_ eq 'imscp') ? 'i-MSCP backend' : $_;
	}
}

if(@runningProcesses) {
	my $runningProcesses = join "\n", @runningProcesses;

	iMSCP::Dialog->factory()->msgbox(<<EOF);

The following i-MSCP processes are already running on your system:

$runningProcesses

You must wait until the end of the i-MSCP processes and re-run the installer.
EOF

	exit 0;
}

exit 0;
