#!/usr/bin/perl

package iMSCP::DataImporter::Application;

use iMSCP::Debug;
use iMSCP::Bootstrapper;
use iMSCP::HooksManager;
use iMSCP::Database;
use iMSCP::Dialog;
use version;
use parent 'Common::SingletonClass';

=head1 DESCRIPTION

 iMSCP Data Importer Application package.

 This is the central package for the i-MSCP Data Importer.

=head1 PUBLIC METHODS

=over 4

=item run()

 Run application

 Return self

=cut

sub run
{
	my $this = $_[0];

	$this;
}

=cut

=item getDB()

 Returns the database object

 Return database object

=cut

sub getDB
{
	my $this = $_[0];

	$this->{'dbObj'};
}

=item getDialog()

 Returns the dialog object

 Return Dialog object

=cut

sub getDialog
{
	my $this = $_[0];

	$this->{'dialogObj'};
}

=back

=head1 PRIVATE METHODS

=over 4

=item _init()

 Initialize instance

 Return self

=cut

sub _init
{
	my $this = $_[0];

	# Init debug
	newDebug('imscp-data-importer.log');

	# Entering in silent mode
	silent(1);

	# Bootstrap environment
	$this->{'bootstrapper'} = iMSCP::Bootstrapper->getInstance()->boot({'nolock' => 'yes'});

	# Init dialog
	$this->initDialog();

	# Say welcome
	$this->sayWelcome();

	# Check for requirements
	unless($this->checkRequirements()) {
		exit 0;
	}

	# Start initialization
	$this->initDB();

	iMSCP::HooksManager->getInstance()->trigger('initialized', $this);

	$this;
}

=item sayWelcome()

 Say welcome

 Return self

=cut

sub sayWelcome
{
	my $this = $_[0];

	my $dialog = $this->getDialog();

	$dialog->set('yes-label', 'Continue');
	$dialog->set('no-label', 'Abort');

	if($dialog->yesno(<<EOF)) {

Welcome to the i-MSCP Data Importer Dialog.

This importer allow to import data from another control panel located on a remote server.

Just follow the given instructions in next dialogs.

\\ZbNote:\\Zn For any help, post on our forum at http://forum.i-mscp.net

Thank you for choosing i-MSCP.

EOF

		$this->getDialog()->msgbox("\nData importer dialog has been aborted...");
		exit 0;
	}

	$this;

}

=item checkRequirements()

 Check requirements

 Returns int 1 if all requirements are meets, 0 otherwise

=cut

sub checkRequirements
{
	my $this = $_[0];

	my $bootstrapper = $this->{'bootstrapper'};

	# Check for i-MSCP version (this system)
	if(!int($main::imscpConfig{'BuildDate'}) < 20140608) {
		$this->getDialog()->set('ok-label', 'ok');
		$this->getDialog()->msgbox(<<EOF);

Your i-MSCP version is not compatible with this importer. Please update your system to i-MSCP 1.1.11 first.

EOF
	}

	# Check for i-MSCP processes
	for(
		'imscp-backup-all', 'imscp-backup-imscp', 'imscp-dsk-quota', 'imscp-srv-traff', 'imscp-vrl-traff',
    	'awstats_updateall.pl', 'imscp'
	) {
		if(!$bootstrapper->lock("/tmp/$_.lock", 'nowait')) {
			$this->getDialog()->set('ok-label', 'ok');

			$this->getDialog()->msgbox(<<EOF);

At least one i-MSCP process is currently running on your system. You must wait until the end of any i-MSCP process.

EOF
			exit 0;
		}
	}

	$this;
}


=item initDB()

 Initialize database object

 Return self

=cut

sub initDB
{
	my $this = $_[0];

	$this->{'dbObj'} = iMSCP::Database->factory();

	$this;
}

=item initDialog()

 Initialize dialog object

 Return self

=cut

sub initDialog
{
	my $this = $_[0];

	$this->{'dialogObj'} = iMSCP::Dialog->factory();
	$this->{'dialogObj'}->set('title', 'i-MSCP Data Importer Dialog');
	$this->{'dialogObj'}->set('backtitle', 'i-MSCP Data Importer');

	$this;
}


=back

=head1 AUTHOR

 Laurent Declercq <l.declercq@nuxwin.com>

=cut

1;
