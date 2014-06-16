#!/usr/bin/perl

package iMSCP::Importer::AbstractImporter;

use strict;
use warnings;

use iMSCP::Debug;
use iMSCP::Config;
use iMSCP::Execute;
use iMSCP::File,
use iMSCP::Dir;
use iMSCP::Database;
use iMSCP::Dialog;

use parent 'Common::Object';

=head1 DESCRIPTION

 i-MSCP importer abstract class.

=head1 PUBLIC METHODS

=over 4

=item setData()

=cut

sub setData
{
	my $this = $_[0];
}

=item ValidateVersion()

 Validate remote software version for compatibility with the importer

 Return int 1 on success, 0 on failure

=cut

sub ValidateVersion
{
	fatal(sprintf('%s must implement the ValidateVersion() method', ref($_[0])));
}

=item

 Validate remote database access

 Return int 1 on success, 0 on failure

=cut

sub validateDatabaseAccess()
{
	my $this = $_[0];
}

=item validateFileAccess()

 Validate remote file access

 Return int 1 on success, 0 on failure

=cut

sub validateFileAccess
{
	fatal(sprintf('%s must implement the validateFileAccess() method', ref($_[0])))
}

=back

=head1 PRIVATE METHODS

=over 4

=item init()

 Initialize instance

 Return self

=cut

sub _init
{
	my $this = $_[0];

	# Database
	$this->{'databaseHost'} = '';
	$this->{'databaseUser'} = '';
	$this->{'databasePassword'} = '';
	$this->{'databaseName'} = '';
	$this->{'databasePrefix'} = '';
	$this->{'database'} = '';

	# Files
	$this->{'webFilesPath'} = '';
	$this->{'mailFilesPath'} = '';

	# Methods (object type => method names)
	$this->{'methods'} = [];

	# Limits for items per run (int[])
	$this->{'limits'} = [];

	# Default limit for items per run
	$this->{'defaultLimit'} = 50;

	# Selected import data
	$this->{'selectedData'} = [];

	# Additional data
	$this->{'additionalData'} = [];
}

=back

=head1 AUTHOR

 Laurent Declercq <l.declercq@nuxwin.com>

=cut

1;
