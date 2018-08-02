dnl -*- mode: html -*-
dnl https://pastebin.com/tpC6M4K6
dnl debugmode(`lt')
define(`HERE', `')
define(`_I', <s class="italics">$1</s>)
define(`LINK', <a href="$1">$2</a>)
define(`FN', `<a id="rev-fn-$1" href="#fn-$1"><sup>[$1]</sup></a>')
define(`FN_TARGET', `<p id="fn-$1"><a href="#rev-fn-$1">[$1]</a> $2</p>')
define(`CODE', `<code>$1</code>')
define(`CODE_BLOCK', `<pre><code>$1</code></pre>')
define(`IMG', `<figure>
<img src="/assets/img/$1.png">
<figcaption>$2</figcaption>
</figure>')

<div id="main" role="main">
<h1>Internet Access Using A Raspberry Pi''`s Serial Port</h1>
<p>Writing is hard, so I don't do it often unless motivated. Of course that's
no excuse for going <em>yet another</em> 11 months since my
LINK(`blog/migen-port.html', `last blog post'). Thanks to work, I have more
FPGA posts in the pipeline very soon. But tonight as of this writing (07-31-2018),
I was inspired by LINK(https://twitter.com/cr1901/status/1024066607142842369, a tweet),
my friend Andrew Wygle, and a broken left-CTRL key that reduced my productivity to nil
to write a warmup post.</p>

<h2>Why Not Just Use Wifi or Ethernet?</h2>
<p>This post discusses how to use the Raspberry Pi serial port to get an
Internet connection. If you're using a Model B series, there's probably no
reason at all to do this, and you'll be better served by the onboard Ethernet
port, onboard Wifi, or a Wifi dongle, if you wish. However, users of the Model A series
and the $5 RPi Zero (not the W series), _which omit the Ethernet port and Wifi_,
and anyone just morbidly curious may wish to read on! </p>

<p>I bought the Model A back in January 2014 because the
minimalism was aesthetically pleasing to me. At the time, I attached some
sort of Realtek Wifi dongle to access the Internet. I recall getting 300 kBps or
so connection speed (out of a theoretical 54 Mbps), but the dongle overheated
many times and eventually failed in early 2015. I've always kept my Pi running
on my workbench, even without an Internet connection, but between 2015 and 2017,
I used my Pi pretty minimally. <em>The truth of the matter is that in 2018,
an Internet connection is pretty essential for any machine which receives
even mild interactive use</em>. _And I get a lot of joy from putting vintage and
underpowered machines on the Internet!_</p>

<p>I've been curious about how to use "serial port Internet" since I got my first
vintage computer- a 1994 Packard Bell- in July 2010. The two link-layer protocols
used for this were Serial Line IP (SLIP) and the Point-to-Point Protocol (PPP).
Until the Raspberry Pi came out, I had found very little information about how
to actually set up an such an Internet connection. One day in September 2017, I
decided to set aside some time to figure out how PPP works, since from what
I read, PPP is more robust and I found more documentation on PPP in the CODE(man)
pages of the userland on my Pi- more on that later. _Yes, sometimes I read
CODE(man) pages. Why are you looking at me like that?_</p>

<p>Even after I made a concious effort to set up the serial port correctly,
I needed basically one-on-one help on a mailing list to get the connection working.
I hope that putting this information all in one place will help others succeed in
their PPP endeavors, not just with the Raspberry Pi, but _I(all) their vintage or
Ethernet-lacking SBCs! Once you get an initial setup working, I think you'll
find subsequent setups fairly simple.</p>

<h2>Prerequisites</h2>
<p>I would recommend:</p>
<ul>
    <li>Two USB-to-serial converters if this is your first setup. These are
    useful to still have access to your remote machine if setup fails.</li>
</ul>

<h2>Theory</h2>
<p>Point-to-Point protocol dates back to LINK(https://tools.ietf.org/html/rfc1134, RFC 1134) in
1989, as far as I can tell. As its name implies, PPP only connects two machines
together in and of itself, and without extra work, these two machines can only
tranfer data between each other utilizing PPP.</p>

<p>PPP was commonly used for modems and dialup connections. Since dialup
alowed users to connect to many machines, clearly there have ways around this
two-machine limitation for a long time. <em>While this would be an interesting topic to research, I don't know any of the details
about how PPP was used with dialup.</em> In the context of how <em>I</em>
utilize PPP to connect to the Internet, neither a modem _in the 56k sense, anyway_
or a phone company is involved!</p>

<p>Instead, I use a handy mature Unix daemon aptly called
CODE(pppd) to create PPP connections. CODE(pppd) consists of a user mode daemon
and kernel mode driver. The driver portion creates a network interface
called CODE(ppp[0-9]*) which can be accessed in a manner very similar to more
familiar interfaces such as CODE(eth[0-9]*) by using the Sockets API,
for instance.</p>

<p>The basic idea of how I get Internet via a serial port is to use a local machine
running CODE(pppd), which has either Ethernet or Wifi connections, to route
_specially, OSI layer 3 and above, as PPP is layer 2 like Ethernet_ data over the local's Internet connection on behalf of a remote machine that
lacks both Ethernet and Wifi.</p>

<h2>My Setup</h2>
<p>NetBSD and Linux</p>


<p> * Look up proxy ARP j-core convo.



_I need to test this at some point, but as I recall, enabling proxy ARP but
NOT IP forwarding allowed me to access my machine locally via SSH, but unable
to access the Internet_s</p>

<h2>Footnotes</h2>

</div>
