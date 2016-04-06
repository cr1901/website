define(`STRIKE', <span class="strike">$1</span>)

<div id="main" role="main">
<div class="notice"><em>This post needs to be cleaned up a bit, and more pictures/visual aids added.
Some knowledge of basic physics is required to fill in the missing visual aids
in the interim (2016/3/24).</em></div>
<h1>Floppy Disk Theory of Operation- Overview</h1>
<h2>So... Why?</h2>
<p>Floppy disks are a STRIKE(dying) dead medium. Once upon a time, they were used
for synths, oscilloscopes, cartridge copiers- you name it! But you don't see new products
made with them nowadays; even hobbyists are likely to use SD cards or Compact Flash
for mass storage for their electronics projects.</p>
<p>So why bother learning how they work? Well, I can think of two reasons:</p>
<ol>
<li>Preservation of old software and data at risk of being lost forever.</li>
<li>Morbid curiosity.</li>
</ol>
<p>I fall into both categories to an extent, but mostly the latter. However,
I have found that information on how to actually read disks without a computer
is sporadic.</p>
<p>Floppy disks are not like SD cards. There is no nice protocol like
SPI where you ask the drive for a particular region of data, and the drive sends
the requested data back in nice byte format. Getting data from a drive to a
representation suitable for computer RAM is involved. It's definitely different
from playing with microcontrollers and peripherals today, where there is usually
I2C or SPI to interface to the hardware-specific circuitry! And unfortunately,
because floppy disks have been obsolete for some time, getting information on
floppy drive physics and operation is also difficult.</p>
<p>I hope to change that a bit. This series of blog posts will discuss details on
floppy disk operation based upon documentation I have found/been pointed to over
the past year. For now, I will be focusing on IBM PC-compatible floppy disks of
the Single and Double Density kind (read: the kind that came with your XT or 286).
It will culminate with a <em>proof of concept</em> IBM PC floppy disk controller via FPGA.</p>
<p>An electronics enthusiast with knowledge in either FPGAs or microcontroller programming,
as well as some control theory, should be able to walk away from these blog posts
able to design a majority of a floppy disk controller.</p>

<h2>Overview</h2>
<p>Floppy disks are a magnetic storage medium. Magnetism is an electrical phenomenon
based upon the movement of charged particles (electrons, ions, etc) that induces
a force (and the ability to do work) on nearby charged particles. The intensity
of the force produced on nearby particles can be visualized by a magnetic field.</p>
<p>When a magnetic field changes intensity, it is often useful to examine how
the field is changing over a given area; the relation of a magnetic field, its
intensity, and the area over which it affects is known as a magnetic flux. When
the magnetic flux changes, charged particles in the region of the flux change
will be affected and move around, specifically induce a current, in an attempt
to restore the magnetic flux to its original condition.</p>
<p>Controlling the rate at which the magnetic flux changes direction (not just intensity),
and measuring it's effect on charged particles forms the fundamentals of storing
and retrieving data with a floppy disk.</p>
<p>A circuit known as a Read/Write head creates a voltage from sensing a change in flux.
This voltage is maximized at the boundaries where the magnetic field completely
changes direction. The points in time at which flux transitions occur,
and amount of flux transitions (changes in direction) compared
to a reference amount of elapsed time, determine whether binary 0's or 1's are
read. During writes, the R/W coil is energized to create a pattern of magnetic flux
transitions, which get stored in the form of microscopic currents on the disk material.</p>

<h2>Floppy Geometry</h2>
<p>Floppy disk material is logically divided into:</p>
<ul>
<li>tracks</li>
<li>heads</li>
<li>sectors</li>
</ul>

<p>The below image illustrates a diskette (darkest blue), the area swept out by
1 sector with 8 sectors per track (lighter blue), and the approximate area (I tried, anyway!)
that consists of a single sector for a single track at 48 tpi (lightest blue). A floppy disk has
two sides, and a disk controller uses the head number to choose which side to try
and read or write.</p>
<img alt="An illustration of floppy disk geometry with concentric circles." src="/assets/img/floppy_tracks.png">
<p>The magnetized particles of each track are ideally in the center of each track,
and are typically separated by regions with no magnetization, so that the R/W
head does not sense two conflicting sources of magnetism.</p>
<p>A R/W head is positioned to a given track using a stepper motor.
The floppy disk controller knows where to find data on a given track/sector by looking
for special patterns of 0's and 1's, or special regions of no transitions and
transitions, respecitively. The format of this control information is deferred
to another post.</p>

<p>In the next sections, I will show a real circuit model used for a floppy disks
based on experiments performed by Shugart in the 1970's. Then I will give some
meaning to the 0's and 1's stored on a floppy disk, as not all the binary data stored
on the disk material ends up appearing in RAM under normal circumstances. Well, unless
you have hardware to defeat copy protection :). The 0's and 1's on floppy medium
tend to be stored using specific rules. I will also explain the rationale for
these rules.</p>

</div>
