define(`STRIKE', <s class="strike">$1</s>)

<div id="main" role="main">
<div class="notice"><em>This post needs to be cleaned up a bit, and more pictures/visual aids added.
Some knowledge of basic physics is required to fill in the missing visual aids
in the interim (2016/3/24).</em></div>
<h1>Floppy Disk Theory of Operation- Overview</h1>
<h2>So... Why?</h2>
<p>Floppy disks are a <del>dying</del> dead medium. Once upon a time, they were used
as secondary storage for personal computers, synths, oscilloscopes, cartridge copiers-
you name it! But you don't see new products using them nowadays. Even electronics
hobbyists who need secondary storage for their microcontroller or FPGA projects
are likely to use SD cards or Compact Flash.</p>
<p>So why bother learning how they work? Well, I can think of two reasons:
<ul>
<li>Preservation of old software and data at risk of being lost forever.</li>
<li>Morbid curiosity.</li>
</ul>
</p>
<p>I fall into both categories to an extent. Sadly, I've found that information
on how to properly read and write floppy disks without a controller
sitting between the disk drive and your computer is sporadic. At least with SD
cards, there is a built-in microcontroller accessed via SPI, where you ask the
card for a particular region of data, and the microcontroller sends the
requested data back in nice byte format.</p>
<p>Without using a floppy disk controller, which are long obsolete and also require
support logic which is <em>also</em> obsolete, getting data from a drive to a
representation suitable for computer RAM is involved. And unfortunately,
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

<h2>Overview/Concise Magnetism Review</h2>
<p>Floppy disks are a magnetic storage medium. Magnetism is an electrical phenomenon
based upon the movement of charged particles that induces a force (and the ability to do work) on nearby charged particles. The intensity
of the force produced on nearby particles can be visualized by a magnetic field.</p>
<p>The relation of a magnetic field's intensity, and the area over which the field
affects is known as a magnetic flux. When the magnetic flux changes, charged particles
in the spatial region of the flux will move, or induce a current, in an attempt
to restore the magnetic flux to its original value before the change occurred.</p>
<p>Controlling the rate at which the magnetic flux changes direction on one magnetic
surface (the disk), and measuring the magnetic surface's effect on current through a
separate, nearby surface (the head) forms the fundamentals of storing
and retrieving data with a floppy disk.</p>
<p>A circuit known as a Read/Write head creates a voltage from sensing a change in flux.
This voltage is maximized at the boundaries where the magnetic field completely
changes direction. The points in time at which flux transitions occur,
and amount of flux transitions (changes in direction) compared
to a reference amount of elapsed time, determine whether binary 0's or 1's are
read. During writes, the R/W coil is energized to create a pattern of magnetic flux
transitions, which get stored in the form of microscopic currents on the disk material.</p>
<p class="aside">
In this article, I use "R/W coil" and "set of R/W coils" interchangeably. Later, I will
show that R/W coils tend to be composed of three separate coils of wire: one for reading,
another for writing, and yet another for erasing.
</p>

<h2>Floppy Geometry</h2>
<p>Floppy disk material is logically divided into at least three different units:
<dl>
<dt>heads</dt>
<dd>A floppy disk drive is designed such that both sides of a floppy disk material
can be read or written by using multiple R/W coils. Each set of coils is attached
to an assembly within the floppy disk drive known as a head. In practice, the current side
being read or written is referenced by which head's coils are activated.</dd>
<dt>tracks</dt>
<dd>Data on a floppy disk surface is not spread evenly out across the disk surface. Rather,
magnetic transitions are concentrated on circles of specific radii away from the center hub of the disk.
These circles are called tracks. Data is written/read as magnetic transitions on the track pass under the head assembly.
Tracks form concentric circles, where the <a href="http://mathworld.wolfram.com/Annulus.html">annuli</a> do not
meaningfully contribute to net magnetization. For our floppy disk format, there are 40 tracks.</dd>
<dt>sectors</dt>
<dd>Tracks themselves are divided into units of a set number of bytes each, each called
a sector. The number of sectors per track for a floppy disk is configurable in software to support
various formats. The name sector is analogous to the geometric concept.</dd>
</dl>
</p>

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
tend to be stored using specific rules; I will also explain the rationale for
these rules.</p>

dnl <h2>Footnotes</h2>


</div>
