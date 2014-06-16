#!/usr/bin/perl

package iMSCP::DataImporter::Exporter::AbstractExporter;

use strict;
use warnings;

use iMSCP::Debug;
use DBI;

use parent 'Common::Object';

=head1 DESCRIPTION

 Abstract class for all exporters.

=head1 PUBLIC METHODS

=over 4

=item setData()

 Sets data

 Return self

=cut

sub setData
{
	my $this = $_[0];
}

=item ValidateVersion()

 Validate remote software version for compatibility with this importer

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

 Initialize the importer

 Return self

=cut

sub _init
{
	my $this = $_[0];

	# Database
	$this->{'databaseHost'} = '';
	$this->{'databasePort'} = '';
	$this->{'databaseUser'} = '';
	$this->{'databasePassword'} = '';
	$this->{'databaseName'} = '';
	$this->{'databasePrefix'} = '';

	# Files
	$this->{'webFilesPath'} = '';
	$this->{'mailFilesPath'} = '';

	# Methods (object type => method names)
	$this->{'methods'} = [];

	# Limits for items per run (int[])
	$this->{'limits'} = [];

	# Default limit for items per run
	$this->{'defaultLimit'} = 1000;

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
