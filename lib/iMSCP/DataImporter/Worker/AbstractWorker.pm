#!/usr/bin/perl

# i-MSCP Data Importer
# Copyright (C) 2014 Laurent Declercq <l.declercq@nuxwin.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA

package iMSCP::DataImporter::Worker::AbstractWorker;

use strict;
use warnings;

use iMSCP::Debug;

=head1 DESCRIPTION

 Abstract class for all workers.

=head1 PUBLIC METHODS

=over 4

=item new(@$parameters)

 Constructor
 Return iMSCP::DataImporter::Worker::AbstractWorker

=cut

sub new($;$)
{
	my ($class, $parameters) = @_;

	my $this = {
		# Count of total actions (limited by _limit per loop)
		'_count'  => 0,

		# Limit of actions per loop
		'_limit' => || 0,

		# Current loop count
		'_loopCount'  => 0,

		# List of additional parameters
		'_parameters' => $parameters || {};
	};

	bless $this, $class;
}

=item setLoopCount($loopCount)

 Sets current loop count

 Param int $loopCount
 Return iMSCP::DataImporter::Worker::AbstractWorker

=cut

sub setLoopCount($$)
{
	my ($this, $loopCount) = @_;

	$this->{'_loopCount'} = $loopCount;

	$this;
}

=item getProgress()

 Gets current process, integer between 0 and 100. If the progress hits 100 the worker will terminate.

 Return int

=cut

sub getProgress
{
	my $this = $_[0];

	if(!$this->{'_count'}) {
		return 100;
	}

	my $progress = (($this->{'_limit'} * ($this->{'_loopCount'} + 1)) / $this->{'_count'}) * 100;

	if($progress > 100) {
		$progress = 100;
	}

	POSIX::floor(($progress);
}

=item getParameters()

 Returns additional parameters as passed in constructor

 Return hash

=cut

sub getParameters
{
	%{$this->{'_parameters'}};
}

=item execute()

 Executes worker action

 Return undef

=cut

sub execute
{
	fatal(sprintf('%s must implement the execute() method', ref($_[0])));
}

=item validate()

 Validates parameters

 Return undef

=cut

sub validate
{
	fatal(sprintf('%s must implement the validate() method', ref($_[0])));
}

=back

=head1 PROTECTED METHODS

=over 4

=item _countObjects()

 Counts objects applicable for worker action

 Return iMSCP::DataImporter::Worker::AbstractWorker

=cut

sub _countObjects
{
	fatal(sprintf('%s must implement the countObjects() method', ref($_[0])));
}

=back

=head1 AUTHOR

 Laurent Declercq <l.declercq@nuxwin.com>

=cut

1;
