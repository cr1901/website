define(`LQ',`changequote(<,>)`dnl'
changequote`'')dnl
define(`RQ',`changequote(<,>)dnl`
'changequote`'')dnl
define(LINK_CONTAINER, `<div class="link-container" style="display:flex; padding: 0.5em; flex-direction: column;">
<div class="title">
  <span style="padding: 1em;">$1</span>
  <span style="padding: 1em;"><a href="$2">$3</a></span>
</div>
<div class="desc" style="padding: 1em;">
  $4
</div>
</div>')

<div id="main" role="main">
<h1>Floppy Disk Notes</h1>

<p>What follows is a set of links that I've collected over the past year that
give technical information on how to encode/decode floppy disks signals, as
well as the theory of operation behind this dying medium.</p>

<p>I find reading these documents important for preservation purposes,
especially since computer programmers of the past relied on these engineering
details for copy protection purposes.</p>

<p>Additionally, a deep understanding of internals may one day help to recover
data that is thought to be lost using statistical analysis of the read signal.</p>

<p>Links are ordered relatively in the order I read them/I recommend reading them,
and sections tend to build upon each other.</p>

<h2>General</h2>
LINK_CONTAINER(`The Floppy User Guide',
http://www.hermannseib.com/documents/floppy.pdf,
link,
`A good technical overall technical description of how a floppy drive accesses data.')

<h2>Floppy Drive</h2>
LINK_CONTAINER(`SA800/801 Diskette Storage Drive Theory of Operations',
http://www.mirrorservice.org/sites/www.bitsavers.org/pdf/shugart/SA8xx/50664-0_SA800_801_Theory_of_Operations_Apr76.pdf,
bitsavers,
`Without question, the most important document on this list.
If you read any document, read this. It`'RQ()s not quite enough information to build
a floppy drive from scratch, but it`'RQ()s enough to bring someone interested up to
speed. Hard to believe this document is 40 years old in 2016!')

LINK_CONTAINER(`SA850/SA450 Read Channel Analysis Internal Memo',
http://www.mirrorservice.org/sites/www.bitsavers.org/pdf/shugart/_specs/SA850_450_Read_Channel_Analysis_Dec79.pdf,
bitsavers,
`Includes a floppy drive transfer function based on experiments Shugart did in
the late 70`'RQ()s'.)

<h2>Phase-Locked Loop (PLLs)</h2>
LINK_CONTAINER(`Phaselock Techniques, Floyd M. Gardner',
http://www.fulviofrisone.com/attachments/article/466/Phaselock%20Techniques%20(Gardner-2005).pdf,
link,
`A monograph on analog PLLs. Does not discuss All-Digital PLLs (ADPLLs).')

LINK_CONTAINER(`NXP Phase Locked Loops Design Fundamentals Application Note',
http://www.nxp.com/files/rf_if/doc/app_note/AN535.pdf,
link,`')

<h2>Encodings</h2>
<h3>MFM</h3>
LINK_CONTAINER(`Floppy Disk Data Separator Design Guide for the DP8473',
http://bitsavers.trailing-edge.com/pdf/national/_dataSheets/DP8473/AN-505_Floppy_Disk_Data_Separator_Design_Guide_for_the_DP8473_Feb89.pdf,
bitsavers,
`')

LINK_CONTAINER(`Encoding/Decoding Techniques Double Floppy Disc Capacity',
ftp://ftp.eskimo.com/home/mzenier/cd-8002-1.pdf,
eskimo,
`Gives background on more complicated physical phenomenon associated with floppy
drive recording, such as magnetic domain shifting.')

<h3>RLL</h3>
LINK_CONTAINER(`IBM`'RQ()s Patent for (1,8)/(2,7) RLL',
http://www.google.com/patents/US3689899,
`3,689,899',
`I`'RQ()m not aware of any floppy formats that use (2,7) RLL, but hard drives
that descend from MFM floppy drive encodings do use RLL. RLL decoding is far more
involved than FM/MFM.')

<h3>GCR</h3>
<p style="padding: 1em;">TODO when I have time to examine non-IBM formats.</p>

<h2>Track Formats</h2>
<h3>IBM 3740 (FM, Single Density)</h3>
<p style="padding: 1em;">TODO. Described in Shugart's Theory of Operations manual.</p>

<h3>IBM System 34 (MFM, Double Density)</h3>
<p style="padding: 1em;">TODO. Described in various documents on this page, but I've not yet found
a document dedicated to explaining the format.</p>

<h2>Floppy Disk Controller ICs</h2>
<h3>NEC 765</h3>
LINK_CONTAINER(`765 Datasheet',
http://www.classiccmp.org/dunfield/r/765.pdf,
link,
`The FDC used in IBM PCs. It is not capable of writing raw data at the level
of the IBM track formats. Thus, attempting to write copy-protected floppies is likely
to fail with this controller.')

LINK_CONTAINER(`765 Application Note',
https://archive.org/details/bitsavers_necdatashe79_1461697,
archive.org,
`')

<h3>TI TMS279X</h3>
LINK_CONTAINER(`TMS279X Datasheet',
http://www.swtpc.com/mholley/DC_5/TMS279X_DataSheet.pdf,
link,
`Includes a diagram of the IBM System 34 track format.')

<h3>NI DP8473</h3>
LINK_CONTAINER(`DP8473 Datasheet',
https://www.engineering.uiowa.edu/sites/default/files/ees/files/NI/pdfs/00/93/DS009384.pdf,
link,
`A successor to the 765 that is capable of handing formats such as 1.2MB High
Density (HD) disks.')

LINK_CONTAINER(`Design Guide for DP8473 in a PC-AT',
http://www.textfiles.com/bitsavers/pdf/national/_dataSheets/DP8473/AN-631_Design_Guide_for_DP8473_in_a_PC-AT_Dec89.pdf,
textfiles,
`')

<h2>Floppy Disk Controller Cards</h2>
LINK_CONTAINER(`IBM PC FDC Card (765)',
http://www.minuszerodegrees.net/oa/OA%20-%20IBM%205.25%20Diskette%20Drive%20Adapter.pdf,
minuszerodegrees.net,
`Includes schematics. The PLL circuit on the last page is in particular worth analyzing.')
</div>
