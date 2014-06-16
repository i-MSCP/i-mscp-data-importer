#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib", '/var/www/imscp/engine/PerlLib';

use iMSCP::Debug;
use iMSCP::Requirements;
use iMSCP::Bootstrapper;
use iMSCP::Dialog;

use version;

$ENV{'LC_MESSAGES'} = 'C';
$ENV{'IMSCP_CLEAR_SCREEN'} = 0;

# Global variable that holds questions
%main::questions = () if ! %main::questions;

newDebug('imscp-data-importer.log');

# Entering in silent mode
silent(1);

# Bootstrap environment
my $bootstrapper = iMSCP::Bootstrapper->getInstance();
$bootstrapper->boot();

# Check for i-MSCP process
for(
	'imscp-backup-all', 'imscp-backup-imscp', 'imscp-dsk-quota', 'imscp-srv-traff', 'imscp-vrl-traff',
    'awstats_updateall.pl'
) {
	if(! $bootstrapper->getInstance()->lock("/tmp/$_.lock", 'nowait')) {
		iMSCP::Dialog->factory()->msgbox(<<EOF);

At least one i-MSCP process is currently running on your system You must wait until the end of any i-MSCP processes.

EOF
		exit 0;
	}
}

# Check for i-MSCP version
if($main::imscpConfig{'BuildDate'} < 20140608 && qv($main::imscpConfig{'Version'} < qv('v1.1.11') {
	iMSCP::Dialog->factory()->msgbox(<<EOF);

    Your i-MSCP version is not compatible with this importer. Please update your system to i-MSCP 1.1.11 first.

EOF
}

exit 0;
