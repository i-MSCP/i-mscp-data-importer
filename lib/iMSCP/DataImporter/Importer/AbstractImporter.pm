#!/usr/bin/perl

package iMSCP::DataImporter::Importer::AbstractImporter;

use strict;
use warnings;

=item importDataSet()

 Imports a data set

 Param $oldId mixed
 Param $data array_ref
 Param $additionalData array_ref
 Return mixed new Id
=cut

sub import
{
	my ($this, $oldID, $data, $additionalData) = @_;

	$data ||= [];
	$additionalData ||= [];
}

=item

 Returns database object class name.

=cut

sub getClassName
{
	my $this = $self;

	return $this->{'className'};
}

=item

=cut

sub _init
{
	my $this = $_[0];

	$this->{'className'} = '';

	$this;
}

1;
