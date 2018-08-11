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
<h1>Internet Access Using A Raspberry Pi's Serial Port</h1>
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
and anyone just morbidly curious may wish to read on! In this post, I will
discuss the following, all based on my own configuration:</p>

<ul>
<li>How to set up Point-to-Point Protocol (PPP) between two computers, one
with Ethernet/Wifi, and the other with nothing but a serial port.</li>
<li>Setting up boot scripts on both peers of the PPP link.</li>
<li>How to use the same serial port for both PPP and interactive login.</li>
</ul>

<h2>Background</p>
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
decided to set aside some time to figure out how PPP works. From what
I read, PPP is more robust, not to mention that I simply found more documentation on PPP in the CODE(man)
pages of the userland on my Pi- more on that later. _Yes, sometimes I read
CODE(man) pages. Why are you looking at me like that?_</p>

<p>Even after I made a concious effort to set up the serial port correctly,
I needed basically one-on-one help on a mailing list to get the connection working.
I hope that putting this information all in one place will help others succeed in
their PPP endeavors, not just with the Raspberry Pi, but <em>all</em> their vintage or
Ethernet-lacking SBCs! Once you get an initial setup working, I think you'll
find subsequent setups fairly simple.</p>

<h2>Prerequisites</h2>
<p>At the bare minimum, you need the following to try my setup yourself:</p>
<ul>
  <li>Your target computer running some Unix variant, containing at minimum one
     unused serial TX/RX pair as I/O (thankfully, this is extremely common).</em>
  <li>Another host (gateway?) computer with an unused serial TX/RX pair, and existing Internet
    connection of some sort; wireless or Ethernet is fine. _Strictly speaking,
    your host computer simply needs to be able to send and receive packets to
    your gateway succesfully for this setup to work._</li>
  <li>Some method of connecting the your host and target's serial lines together.
  I just use wires I bought from LINK(https://www.adafruit.com/product/1951, Adafruit),
  but a USB-to-serial connection should work just as well.</li>
<p>In addition, I would recommend:</p>
<ul>
    <li>Two USB-to-serial converters if this is your first setup. These are
    useful to still have access to your remote machine if setup fails.</li>
</ul>

<h2>Theory</h2>
<p>If you're not interested in the details, feel free to skip this section. You
can always come back to it later if you're curious and/or stuck.</p>

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
_specially, OSI layer 3 and above, as PPP is layer 2 like Ethernet_ data over
the local's Internet connection on behalf of a remote machine that
lacks both Ethernet and Wifi.</p>

<h3>Proxy ARP</h3>
<p>Internet Protocol is focused on getting data from a source to a destination, but
IP doesn't care how the data transfer physically occurs. Details
of <em>how</em> to get data from a source to a destination are left to other
lower-level protocols, like Ethernet, Wifi, and PPP.</p>

<p>In the case of machines using Ethernet and Wifi, hardware MAC addresses
and TCP/IP (Layer 3) work together to uniquely identify machines that can send
and receive data over a network in between (and including!) the initial source
and ultimate destionation. For instance, if a source machine wants to
send data to a specific machine over Ethernet with data using _encapsulating_ IP, the source machine asks all other
machines on the network for which MAC address corresponds to which IP address.
The source machine caches the IP to MAC address mappings for when it needs to send
data using IP over Ethernet to these machines once again. This is known as
Address Resolution Protocol (ARP).</p>

<p>Point-to-Point Protocol, a Layer 2 protocol like Ethernet, does not have
a concept of MAC addresses/ARP. Assuming we have a solution to convert
the bits/voltages sent over a serial line to the bits/voltages sent over an Ethernet
cable, _we do, of course, have a solution. That's the whole point of this blog post!_

, it's still not possible to tell the Ethernet/Wifi portion of a network that a machine using PPP exists;
there isn't a MAC address to send! The solution to this problem is a technology called proxy ARP.<p>

A machine implementing proxy ARP uses its own MAC address in response to ARP
requests for another machine that is not visible to an Ethernet. Software on the machine implementing proxy ARP
must know how to specially handle TCP/IP

CODE(pppd) and LINK(https://github.com/rsmarples/parpd, parpd) are two pieces
of software implementing Proxy ARP.<p>

<h2>My Setup</h2>
<p>At home, I NetBSD on my Raspberry Pi and I have it attached to an ASUS Tinkerboard
running the LINK(https://dietpi.com, DietPi) Debian Linux variant. For simply
creating a PPP connection, your combination of OS choice doesn't really matter
as long as the user and kernel mode portion of CODE(pppd) is present on both
systems (so basically, you need to be running a Unix variant).</p>

<p>However, tailoring your PPP setup to your liking <em>is</em> OS/machine-dependent.
In my case, my Tinkerboard has (pppd) configured as a systemd service, and my
Raspberry Pi listens for a PPP connection or a serial console login attempt.
I also customize the pppd CODE(if-up) script on my Pi to get the time from an NTP
server, since my Pi doesn't have an RTC.</p>

<p>I will explain how to apply these customizations for the curious, but anyone
reading will need to decide for themselves whether my setup applies to them, and
which parts. Even if none of my personal configuration applies, I hope I can
provide some inspiration for many distinct use-cases of PPP!</p>

<h3>Host Config</h3>
<h3>Target Config</h3>


<p> * Look up proxy ARP j-core convo.



_I need to test this at some point, but as I recall, enabling proxy ARP but
NOT IP forwarding allowed me to access my machine locally via SSH, but unable
to access the Internet_s</p>

<h2>Debugging</h2>
<p>Unfortunately, it's been nearly a year since I first set up a PPP connection,
and I don't exactly remember all the issues I ran into before finally having success.
However, I do remember the following guidelines that helped me.</p>
<ul>
  <li>Use CODE(`pppd''`s') debugging log level to your advantage.</li>
  <li>Try setting up a PPP connection over two USB-to-serial ports on an alternate UART first.</li>
  <li>If running NetBSD, the default UART speed for any new entries in CODE(/etc/ttys) is 9600,
  not 115200. This caused me a lot of pain.</li>
  <li>*Link NetBSD mailing list here*</li>
</ul>

<h2>Getty</h2>
<p>Without getting into fine details, _From reading Unix v7 man pages and source,
  it seems historically, init would wait for a TTY to open before passing control
  to getty. Getty could then modify the TTY- such as baud rate- as it saw fit,
  while waiting for a username. v7 CODE(gettytab) is hardcoded in the CODE(getty) binary.
  FreeBSD's getty, on the other hand, opens and
  initializes ttys, reads CODE(/etc/gettytab) as well as calls CODE(login)._
  traditionally CODE(init) calls CODE(getty) for each
  entry in CODE(/etc/ttys) (BSD), CODE(/etc/inittab) (System V Init), or via
  a CODE(getty) service (systemd). CODE(getty) prints a banner, waits for a
  username to be input, possibly adjusting tty parameters, and then invokes CODE(login).</p>

  <p>A terminal/serial line already waiting for a username or running a shell after CODE(login) is
  invoked would not be able understand PPP packets. Most programs whose standard input
  is connected to the serial line would perceive PPP packets as garbage, excepting
  CODE(pppd), obviously. So it seems that you must choose between either allowing
  console login or a PPP connection over a given serial line.
</p>

<p>However, certain variants of getty are capable of multiplexing PPP packets
  and user login operation. In particular, FreeBSD and NetBSD CODE(getty) have
  this feature, and the Linux CODE(mgetty) can enable it through via the non-default
  compile time define CODE(-DAUTO_PPP). _I'm unaware of any Linux CODE(getty)
  which has PPP packet handling enabled by default._ In fact, automatic PPP detection
  as described in the man pages of NetBSD was what finally convinced me to try
  PPP in the first place!</p>


<h2>Footnotes</h2>

</div>
