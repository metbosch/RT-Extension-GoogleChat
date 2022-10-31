use strict;
use warnings;
use HTTP::Request::Common qw(POST); 
use LWP::UserAgent; 
use JSON; 
package RT::Extension::GoogleChat;

our $VERSION = '0.010';

=head1 NAME

RT-Extension-GoogleChat - Integration with GoogleChat webhooks

=head1 DESCRIPTION

This module is designed for *Request Tracker 5* integrating with *Google Chat* webhooks.
It was modified from the Andrew Wippler Slack integration (https://github.com/andrewwippler/RT-Extension-Slack).

=head1 RT VERSION

Works with RT5.
Probably also with RT4 (untested)

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt5/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::GoogleChat');

or add C<RT::Extension::GoogleChat> to your existing C<@Plugins> line.

=item Clear your mason cache

    rm -rf /opt/rt5/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

@metbosch E<lt>metbosch@outlook.comE<gt>

=head1 BUGS

All bugs should be reported via email to

    L<bug-RT-Extension-GoogleChat@rt.cpan.org|mailto:bug-RT-Extension-GoogleChat@rt.cpan.org>

or via the web at

    L<rt.cpan.org|http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-GoogleChat>.

=head1 LICENSE AND COPYRIGHT

The MIT License (MIT)

Copyright (c) 2022 @metbosch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



=cut
sub Notify { 
	my %args = @_; 
	my $payload = { 
		text => 'I have forgotten to say something', 
	}; 
	my $webhook_url; 

	foreach (keys %args) { 
		if ($_ ne 'url') {  
		  $payload->{$_} = $args{$_}; 
		} 
	} 
	if (!$payload->{text}) { 
		return; 
	} 
	my $payload_json = JSON::encode_json($payload); 

	$webhook_url = $args{url}; 
	if (!$webhook_url) { 
		$RT::Logger->info('GoogleChat webhook URL not found'); 
		return; 
	} 

	my $ua = LWP::UserAgent->new(); 
	$ua->timeout(10); 

	#$RT::Logger->info('Pushing notification to GoogleChat: '. $payload_json); 
	my $response = $ua->post($webhook_url,
	  'Content-Type' => 'application/json; charset=UTF-8',
	  'Content' => $payload_json
	);
	if ($response->is_success) { 
		return;
	} else { 
		$RT::Logger->error('Failed to push notification to GoogleChat ('. 
		$response->code .': '. $response->message .')'); 
	} 
} 

1; 
