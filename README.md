# RT-Extension-GoogleChat
**Under development:** Integration with GoogleChat webhooks

## DESCRIPTION
This module is designed for *Request Tracker 5* integrating with *Google Chat* webhooks.
It was modified from the Andrew Wippler Slack integration (https://github.com/andrewwippler/RT-Extension-Slack).

### RT VERSION
Tested with RT version 5.0.3.
Probably, it also works with RT 4 (untested).

## INSTALLATION
    perl Makefile.PL
    make
    make install

May need root permissions

Edit your /opt/rt5/etc/RT_SiteConfig.pm, add this line:

	Plugin('RT::Extension::GoogleChat');

Clear your mason cache

	rm -rf /opt/rt5/var/mason_data/obj

Restart your webserver

## USAGE

Create a new script with your needed condition, with *User Defined* as action, and *Blank* as template.
Then, use the *Custom action preparation code* to call this extension as follows:

```perl
RT::Extension::GoogleChat::Notify(
  url => 'https://chat.googleapis.com/v1/spaces/<space_id>/messages?key=<api_key>&token=<api_token>',
  text => 'This is a message from RT!'
); 
```

### Obtain the Google Chat webhook URL

Please, refer to [official google chat documentation](https://developers.google.com/chat/how-tos/webhooks#step_1_register_the_incoming_webhook) for instructions about getting webhook url.

### Another custom action preparation code example

```perl
my $text; 
my $requestor; 
my $ticket = $self->TicketObj; 
my $queue = $ticket->QueueObj; 
my $url = join '', 
	RT->Config->Get('WebPort') == 443 ? 'https' : 'http', 
	'://', 
	RT->Config->Get('WebDomain'), 
	RT->Config->Get('WebPath'), 
	'/Ticket/Display.html?id=', 
	$ticket->Id; 
 
$requestor = $ticket->RequestorAddresses || 'unknown'; 
$text = sprintf('New ticket <%s|#%d> by %s: %s', $url, $ticket->Id, $requestor, $ticket->Subject); 

RT::Extension::GoogleChat::Notify(url => 'https://chat.googleapis.com/v1/spaces/<space_id>/messages?key=<api_key>&token=<api_token>', text => $text); 
```


## AUTHORS
 - [Maciek] (http://www.gossamer-threads.com/lists/rt/users/128413#128413)
 - Andrew Wippler
 - [@metbosch] (https://github.com/metbosch)
    

## LICENSE AND COPYRIGHT
    The MIT License (MIT)

    Copyright (c) 2022 @metbosch

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

