package Biber::Section::List;
#use feature 'unicode_strings';
use Biber::Utils;
use List::Util qw( first );

=encoding utf-8

=head1 NAME

Biber::Section::List

=head2 new

    Initialize a Biber::Section::List object

=cut

sub new {
  my ($class, %params) = @_;
  my $self = bless {%params}, $class;
  return $self;
}

=head2 set_label

    Sets the label of a section list

=cut

sub set_label {
  my $self = shift;
  my $label = shift;
  $self->{label} = lc($label);
  return;
}

=head2 get_label

    Gets the label of a section list

=cut

sub get_label {
  my $self = shift;
  return $self->{label};
}

=head2 set_type

    Sets the type of a section list

=cut

sub set_type {
  my $self = shift;
  my $type = shift;
  $self->{type} = lc($type);
  return;
}

=head2 get_type

    Gets the type of a section list

=cut

sub get_type {
  my $self = shift;
  return $self->{type};
}

=head2 get_listdata

    Gets all of the list metadata

=cut

sub get_listdata {
  my $self = shift;
  return [ $self->{sortscheme},
           $self->{keys},
           $self->{sortinitdata},
           $self->{extraalphadata},
           $self->{extrayeardata} ];
}

=head2 set_extrayeardata

    Saves extrayear field data for a key

=cut

sub set_extrayeardata {
  my $self = shift;
  my $key = shift;
  my $ed = shift;
  return unless defined($key);
  $self->{extrayeardata}{lc($key)} = $ed;
  return;
}

=head2 get_extrayeardata

    Gets the extrayear field data for a key

=cut

sub get_extrayeardata {
  my $self = shift;
  my $key = shift;
  return unless defined($key);
  return $self->{extrayeardata}{lc($key)};
}

=head2 set_extraalphadata

    Saves extrayear field data for a key

=cut

sub set_extraalphadata {
  my $self = shift;
  my $key = shift;
  my $ed = shift;
  return unless defined($key);
  $self->{extraalphadata}{lc($key)} = $ed;
  return;
}

=head2 get_extraalphadata

    Gets the extraalpha field data for a key

=cut

sub get_extraalphadata {
  my $self = shift;
  my $key = shift;
  return unless defined($key);
  return $self->{extraalphadata}{lc($key)};
}

=head2 set_sortdata

    Saves sorting data in a list for a key

=cut

sub set_sortdata {
  my $self = shift;
  my $key = shift;
  my $sd = shift;
  return unless defined($key);
  $self->{sortdata}{lc($key)} = $sd;
  return;
}

=head2 get_sortdata

    Gets the sorting data in a list for a key

=cut

sub get_sortdata {
  my $self = shift;
  my $key = shift;
  return unless defined($key);
  return $self->{sortdata}{lc($key)};
}


=head2 set_sortinitdata

    Saves sortinit data in a list for a key

=cut

sub set_sortinitdata {
  my $self = shift;
  my $key = shift;
  my $sid = shift;
  return unless defined($key);
  $self->{sortinitdata}{lc($key)} = $sid;
  return;
}


=head2 get_sortinitdata

    Gets the sortinit data in a list for a key

=cut

sub get_sortinitdata {
  my $self = shift;
  my $key = shift;
  return unless defined($key);
  return $self->{sortinitdata}{lc($key)};
}


=head2 set_sortscheme

    Sets the sortscheme of a list

=cut

sub set_sortscheme {
  my $self = shift;
  my $sortscheme = shift;
  $self->{sortscheme} = $sortscheme;
  return;
}

=head2 get_sortscheme

    Gets the sortscheme of a list

=cut

sub get_sortscheme {
  my $self = shift;
  return $self->{sortscheme};
}


=head2 add_filter

    Adds a filter to a list object

=cut

sub add_filter {
  my $self = shift;
  my ($type, $values) = @_;
  # Disjunctive filters are not simple values
  if ($type eq 'orfilter') {
    $self->{filters}{$type} = $values;
  }
  else {
    $self->{filters}{$type} = [ split(/\s*,\s*/,$values) ];
  }
  return;
}

=head2 get_filter

    Gets a specific filter from a list object

=cut

sub get_filter {
  my $self = shift;
  my $type = shift;
  return $self->{filters}{$type};
}

=head2 get_filters

    Gets all filters for a list object

=cut

sub get_filters {
  my $self = shift;
  return $self->{filters};
}


=head2 set_keys

    Sets the keys for the list

=cut

sub set_keys {
  my $self = shift;
  my $keys = shift;
  $self->{keys} = $keys;
  return;
}

=head2 get_keys

    Gets the keys for the list

=cut

sub get_keys {
  my $self = shift;
  return @{$self->{keys}};
}

=head2 instantiate_entry

  Do any dynamic information replacement for information
  which varies in an entry between lists. This is information which
  needs to be output to the .bbl for an entry but which is a property
  of the sorting list and not the entry per se so it can't be stored
  statically in the entry and must be pulled from the specific list
  when outputting the entry.

  Currently this means:

  * sortinit
  * extrayear
  * extraalpha

=cut

sub instantiate_entry {
  my $self = shift;
  my $entry = shift;
  my $key = shift;
  return '' unless $entry;

  my $entry_string = $$entry;

  my $sid = $self->get_sortinitdata($key);
  if (defined($sid)) {
    my $si = "\\field{sortinit}{$sid}";
    $entry_string =~ s|<BDS>SORTINIT</BDS>|$si|gxms;
  }

  my $eys;
  # Might not be set due to skip
  if (my $ey = $self->get_extrayeardata($key)) {
    $eys = "    \\field{extrayear}{$ey}\n";
  }
  $entry_string =~ s|^\s*<BDS>EXTRAYEAR</BDS>\n|$eys|gxms;

  my $eas;
  # Might not be set due to skip
  if (my $ea = $self->get_extraalphadata($key)) {
    $eas = "    \\field{extraalpha}{$ea}\n";
  }
  $entry_string =~ s|^\s*<BDS>EXTRAALPHA</BDS>\n|$eas|gxms;

  return $entry_string;
}


=head1 AUTHORS

François Charette, C<< <firmicus at gmx.net> >>
Philip Kime C<< <philip at kime.org.uk> >>

=head1 BUGS

Please report any bugs or feature requests on our sourceforge tracker at
L<https://sourceforge.net/tracker2/?func=browse&group_id=228270>.

=head1 COPYRIGHT & LICENSE

Copyright 2009-2011 François Charette and Philip Kime, all rights reserved.

This module is free software.  You can redistribute it and/or
modify it under the terms of the Artistic License 2.0.

This program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

1;

# vim: set tabstop=2 shiftwidth=2 expandtab:
