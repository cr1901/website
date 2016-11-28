define(`STRIKE', <s class="strike">$1</s>)
define(`LINK', <a href="$1">$2</a>)
define(`VECTORIZE', `<figure>
<img src="/assets/img/nmos/Capture_$1.PNG">
<figcaption>$2</figcaption>
</figure>')
define(`SCHEM', `<figure>
<img src="/assets/img/nmos/NMOS-RE-Sample_$1.png">
<figcaption>$2</figcaption>
</figure>')

define(`TR', `<tr><td>$1</td><td>$2</td></tr>')
<!-- TODO: O_-->

<div id="main" role="main">
<h1>NMOS IC Reverse Engineering</h1>
<p>Recently, I was STRIKE(tricked) talked into examining the die of an integrated circuit (IC)- the YM2151,
a single-chip FM synthesizer. I like these old Yamaha chips, so I don't really mind
doing it, but it's definitely a long term project that I expect to take months.
However, one doesn't need to RE a significant portion of an IC to understand the basics of RE.
Information about a chip's operation can be gleamed by examining small units, and predicting
their relation to each other.</p>

<p>Information on doing IC reverse-engineering is still kind of limited, although projects like
LINK(`https://siliconpr0n.org', `siliconpr0n') and whatever LINK(`http://www.righto.com/2014/10/how-z80s-registers-are-implemented-down.html', Ken Shirriff)
is working on at any given time are changing that. Since I am learning how to RE ICs, I decided to
 document how I decoded a small ROM in the YM2151 that I <em>suspect</em> is
being used as part of the control state machine. This small ROM demonstrates
the basics of REing ICs, including:</p>
<ol>
<li>Separating the various layers of an IC die.</li>
<li>Mapping ROM inputs and outputs.</li>
<li>Manually reading out the ROM contents.</li>
</ol>

<h2>Obtaining a Die Image</h2>
<p>Before we can examine an IC die, we have to actually digitally capture an image
of the die. I will not be discussing this in detail, but getting a die image typically involves:</p>
<ol>
<li>Removing the IC package with corrosive chemicals, called decap.</li>
<li>Taking a number of pictures using a digital camera with a microscope.</li>
<li>Stitching all the individual images together to produce a full map of the IC die with individual transistors visible.</li>
</ol>

<p>I really don't have access to the equipment to do this even at a small scale,
but luckily this work was done previously in the case of YM2151 (20x magnification). I defer to
Travis Goodspeed's
article in section 9 of LINK(`https://archive.org/details/pocorgtfo04', `POC||GTFO #4') if interested in doing decap yourself.</p>

<figure>
<img alt="YM2151 die image." src="/assets/img/nmos/ym2151_die.png">
<figcaption>Die image of YM2151 at 20x magnification, full die. The full-size
image is 617MB (LINK(`https://siliconpr0n.org/map/yamaha/ym2151/mz_mit20x/', `Source')).</figcaption>
</figure>


<h2>What is NMOS?</h2>
<p>The YM2151 uses an LINK(`https://en.wikipedia.org/wiki/Depletion-load_NMOS_logic', `NMOS process'). The NMOS logic family uses n-type metal
oxide semiconductor field-effect transistors (MOSFETs) to create digital logic gates.
MOSFETs are four-terminal devices that either permit or prevent current from flowing between two of the terminals,
called the drain and source, depending on the voltage of the third terminal, called the gate, relative
to either the drain or source. The fourth terminal, called the body,
is negligible for now.</p>

<h3>MOSFET Schematic Symbols</h3>
<p>The below picture shows two different types of MOSFETS:
n-type depletion and n-type enhancement mode. On each MOSFET, the center terminal attached to the
left column is the gate input. The source and drain are the bottom and top terminals, respectively.
Each MOSFET has the source connected to a fourth terminal, which in turn connects to an
arrow pointing inward to the right column, indicating n-type MOSFETs. Put simply, the arrow direction
corresponds to device polarity at a specific area within the MOSFET. The source-body connection
is a side effect of the MOSFET symbol I used, and we can ignore it. A segmented right column
represents enhancement mode, and a solid right column represents depletion mode.</p>

<figure>
<img alt="Two NMOS Circuits showing the schematic symbols for MOSFETs." src="/assets/img/nmos/NMOS-Intro.png">
<figcaption>A depletion and enhancement mode n-type MOSFET circuit and an equivalent circuit.
The depletion mode MOSFET acts as a resistor, and the enhancement mode MOSFET as a switch.
A quick rationale on the schematic symbol is given in the above paragraph.
On is 5V, off 0V.</figcaption>
</figure>


<p>A MOSFET is a symmetrical device, so drain and source can be
labeled arbitrarily. However, according to Sedra and Smith, drain is by convention
always at a higher voltage than source.</p>

<h3>Quick "Theory" of MOSFETs</h3>
<p>"n-type" refers to the properties of the silicon that carries current through
a MOSFET. For the purposes of this blog post, I need not go into its properties.</p>

<p>In hand-calculations, a MOSFET has at least three LINK(`https://en.wikipedia.org/wiki/MOSFET#Modes_of_operation', `modes of operation').
I'm not interested in doing simulation in this blog post (maybe in the future I will!), but for completeness, the regions are:
</p>
<ul>
<li>Cutoff, no conduction from drain to source.</li>
<li>Triode, linear region, acts like a resistor.</li>
<li>Saturated, increasing gate voltage does not increase current.</li>
</ul>

<!-- <p>When operating MOSFETs as gates/switches, we are typically interested in cutoff
and the linear region so we can create voltage dividers with well-defined resistances.
This way, the entire circuit can operate at the proper on and off voltage ranges. This is
called "ratioed logic", according to LINK(`http://web.cs.mun.ca/~paul/transistors/node1.html', `this useful page')</p>
-->

<!-- http://ece424.cankaya.edu.tr/uploads/files/Chap16-1-NMOS-Inverter.pdf -->

<p>Both enchancement mode and depletion mode MOSFETs are used in the NMOS logic family.
Depletion-mode MOSFETs conduct current even when the gate and
source is at the same voltage; the gate must have a lower voltage than the source for cutoff to occur.
They are commonly, <em>but not exclusively</em>, used as pullup resistors, operating in the linear region and always on.</p>

<p>On the other hand, enhancement-mode MOSFETs are used to implement logic gates by either allowing current to pass
or not. They operate in cutoff and saturation. The gate must be at a higher voltage
than the source to conduct current. Voltage drop tends to be negligible in the enhancement-mode
MOSFETs; see ratioed logic in the previous link for more information.</p>

<p>With the above two paragraphs in mind, here is an exercise: How would you implement
an NMOS NOR gate (hint: MOSFETs in parallel)? NAND gate (hint: MOSFETs in series)? Inverter (NOT)
(hint: Look carefully at my MOSFET image)?
Notice how gates with inverters are easiest to implement?
I wonder if that's a reason active-low inputs and outputs are so common in these chips?</p>

<h3>Am <em>I</em> Dealing With NMOS?</h3>
<p>How does one detect an NMOS chip? To be honest, I was told ahead of time that
the YM2151 uses an NMOS process. The year that this chip was first produced (1984-5) is
also a hint. Howvever, when compared to a LINK(`https://siliconpr0n.org/map/yamaha/ymf262-m/mz_mit50xn/', `CMOS die') of a similar-era
Yamaha chip, I notice a few differences:</p>
<ul>
<li>Only one size of via in a CMOS die, many in NMOS.</li>
<li>No obvious indication of pullup MOSFETs in CMOS, prevalent in NMOS.</li>
<li>The CMOS die is more neatly organized, compared to NMOS.</li>
</ul>

<p>Right now, the above list probably isn't all that meaningful :P. I'll discuss
what I mean in the next section. As you may expect, my method of analysis only
works for ICs made with an NMOS process. However, this is still useful for
preserving many old chips where fully emulating their behavior is desired (YM2151)
or even required (security chips) to preserve hardware.</p>

<h2>IC Layers</h2>
<p>I decided to digitize (or vectorize) a ROM at the top of the chip, approximately
one third of the length longways.</p>

VECTORIZE(1, `Section of the YM2151 I intend to vectorize, before we begin any work.')

<p>ICs- well, not cutting-edge ones anyway- tend to be made by applying planar layers
of conducting and semiconductor material. Therefore, it tends to be safe to represent
each layer of material as a 2d layer in a vector image, not worrying about layer depth
or wells that would be apparent in a 3d cutaway. Each layer can thus be inferred and
by examining intersections and outlines left over during decap.</p>

<p>I can tell the above is a ROM from the equal-width strips of metal (remember,
metal tends to be consistently colored) and the circular "holes" distributed
throughout the metal strips. These "holes" are properly referred to as "vias". Vias
are drilled holes, forming a connection with any layer that intersects at their
location.</p>

<p>Additionally, there exist buried contacts that directly connect (typically? always?)
the poly and active layers. A metal layer can be placed on top of a buried contact without
creating a connection. Buried contacts can frequently be identified by a light square
outline where poly and active intersect, but this is not guaranteed. Sometimes buried
contacts must be inferred from context. The takeaway here is: vias and buried contacts
form two additional logical layers that need to be vectorized.</p>

<p>Buried contacts are different from MOSFET gates b/c a MOSFET gate is not a direct connection.
A gate has a layer of insulating oxide separating the polysilicon and the active layer/wells
underneath. However, it tends to be obvious from context and visual inspection which
type of connection exists, even without having a 3d cutaway view which would show the differences.</p>

<p>Not all ICs have the same number of layers or the same layer material type, but
in the case of NMOS, it's safe to divide an IC die into at least three layers:<p>
<ul>
<li>Metal, conducting material. Typically a whiteish hue that stands out, in the case of aluminum (which is what YM2151 uses).</li>
<li>Polysilicon, pure silicon. Used for MOSFET gates. Color cannot be assumed, but outlines are obvious.</li>
<li>Active, doped silicon used for drain and source. Color cannot be assumed, but outlines are obvious.</li>
</ul>

<h2>Let's Digitize!</h2>
<p>With the above out of the way, let's digitize the metal layer and vias of the ROM. Please note that
in some images that I may miss a section :P. I correct it in a later step unless otherwise noted.</p>

<table>
<caption>Layer Color Table</caption>
<thead>TR(Layer, Color)</thead>
<tbody>
TR(Metal, Yellow)
TR(Polysilicon, Red)
TR(Active, Blue)
TR(Via, Green)
TR(Buried Contact, Pink)
</tbody>
</table>

VECTORIZE(2, `Metal layer is easily visible. Here, the ROM matrix, ROM inputs and power and ground rails
are digitized. I will show how to infer the latter three shortly.')

VECTORIZE(3, `Here, we have digitized most of the vias of interest.')

<p>The image has become a bit crowded after digitizing the metal and via layers, so for
the time being I will disable them.</p>

<p>Let's start looking for transistors. I personally like to start with pullups, because
pullups have a very distinctive shape on an NMOS die, and the power rail can also
be inferred. As mentioned before, NMOS pullups are depletion-mode MOSFETs, and they have
very large gate widths to create a current path even without an applied gate voltage. Additionally,
to provide the pullup effect, there exists a connection to the active layer on the source side of the MOSFET that
looks like a hook.

<p>Pullup MOSFETs thus tend to look like "rectangles with a hook", with slightly more
emphasis on the hook to create the source-to-gate connection. We can now safely vectorize
the pullups, and immediate polysilicon traces emanating from the pullups.</p>
VECTORIZE(4, `We have vectorized our first MOSFET gate! A depletion mode MOSFET at that.')

VECTORIZE(5, `All pullups, polysilicon layer, vectorized. By process of elimination we know the remaining two
sides of the ROM are the inputs or outputs.')

<p>In our depletion mode pullups, the active layer consisting of source and drain runs through the
center of the wide gate. We can trace out the active layer completely now, but I deliberately
stopped short. The crossing of two layers near the pullups at the bottom is signficant.</p>
VECTORIZE(6, `We can start vectorizing the active layer that forms the source and drain of the pullups.')

<p>Notice that each strip of the metal layer connecting at the top of the ROM terminates in a via. The via connects
to a layer below, either active or poly, that runs across the length of the ROM. This layer abruptly terminates
after crossing the active layer that directly connects to the pullup's source. There was a transistor
formed due to that crossing during fabrication! We can safely assume them to be enhancement mode
transistors used as switches due to the gate size.</p>

<p>Our unknown layer <em>must</em> be poly because they form the gate of a transistor. Furthermore,
Because the metal at the top of the ROM attaches directly to the gate of a transistor for each input, the top
of the ROM must be our input. By process of elimination, the output of our ROM is on the right.</p>
VECTORIZE(7, `Our first enhancement mode transistors. Notice how much smaller the gate is for each compared
to depletion mode.')

<p>Now I decided to take a break from the poly and vectorize the buried contacts. The buried contacts
in this section are all visible as squares at poly and active crossings. Since a pullup <em>must</em> have
a buried contact to connect the gate and source, let's start with the pullups. Can you find the outline of the other buried
contacts before scrolling to the second image?</p>
VECTORIZE(8, `Some buried contacts due to pullup connections have been digitized.
All buried contacts of interest in this section are visible.')
VECTORIZE(9, `Remaining buried contacts of interest digitized.')


<p>Now, I finish the active layer, which by process of elimination is going to be
the remaining unvectorized traces. These form a number of enhancement-mode MOSFET
switches distributed through the ROM matrix. <em>Anywhere the poly crosses the
active layer is a transitor!</em></p>

VECTORIZE(11, `Remaining active layer forming the ROM matrix digitized. I accidentally
missed part of the active layer at the bottom of the second column when taking these images.')
<p>With the active layer (minus my mistake) digitized, the ROM has been fully vectorized.
I re-enable the metal and via layers to show the final result. Additionally, I vectorized a few
more sections all all layers, only one of which is relevant to the ROM.</p>

<p>The thick metal trace below the ROM which connects to the active layer of the ROM matrix
(at the source terminals of the enhancement mode MOSFETs immediately attached to depletion mode pullups),
is in fact a ground trace. From experience, I can expect the active columns running through
the ROM matrix to be connected to ground. I will explore why in the next section.</p>
VECTORIZE(13, `Fully vectorized ROM, plus some extra connections')


<h2>Schematic Capture</h2>
<p>I am arbitrarily labeling the leftmost and bottommost bus lines the LSBs of
the input and output, respectively. Thus, bit positions increase as one travels
from left to right and bottom to top of the ROM matrix.</p>

<p>Initially, I had intermediate images of my progress creating the schematic.
Unfortunately, for various formatting reasons (repeated transistor numbers, inconsistent resolution),
the intermediate images didn't turn out how I liked, so I removed them.</p>

<p>I created the schematic in a manner very similar to how I vectorized starting with the
pullups, then adding the inputs and their corresponding MOSFET switch connections.
Then I added the ROM outputs. Next, I added the remaining wires that run down the ROM
matrix columnwise, which attach to the source of the switch enhancement mode MOSFETs and pullup
depletion-mode MOSFETs respectively. I finished schematic capture by adding the additional
switch transistors that exist anywhere the active layer crosses poly within the matrix.</p>

<p>For each trio of column wires, the leftmost wire is the ROM input, the middle
wire is the active layer running across each row of the ROM matrix, and the rightmost
wire is attached to its corresponding pullup.</p>

<!-- <strong>I didn't realize that the thick trace below the ROM was a ground trace
until after I was done creating the schematic. So GND is not present until the
last image.</strong>

SCHEM(1, `Schematic considering only pullups.')
SCHEM(2, `Input bus lines and MOSFET inteface added to schematic.')
SCHEM(3, `')
SCHEM(4, `') -->
SCHEM(6, `Full schematic. This 5x10 ROM contains nearly 60 transistors!')

<p>I made a mistake when drawing the above schematic. By convention, the source
should be at a lower voltage than the drain, but for the transistors within the
ROM matrix, I accidentally swapped source and drain. In an IC, this does not
matter, as a MOSFET is symmetric and swapping source and drain does not affect
device operation (for our intents and purposes). However, without this disclaimer,
I'm sure I will confuse people. Perhaps the drain and source distinction is
best ignored for this schematic.</p>

<h2>Reading Out the ROM Contents</h2>
<p>With the above schematic, we can gleam some interesting information about
how the ROM works. I assume the ROM inputs are either always a valid 1 or 0,
because I am assuming that this ROM is driven by internal control logic.</p>

<p>If any given bus input is 0, the input will not turn on the switch transistors at
the bottom of the ROM, placed immediately before pullups. This means that the pullups
are not actively driven low, and the source terminal of the pullups remains at a
high logic value. The logical high is propogated to all transistors whose gates are
connected to the pullup source; these transistors are on. All transistors whose gates are
attached to the bus input are in cutoff and have no effect on circuit operation.</p>

</p>Notice that the metal corresponding to each bit output is attached to all transistors
in a row in parallel. This means that if <em>any</em> of the transistors in a given
row are on, the entire metal row, and consequently the output, is pulled low as well.
This is also called LINK(https://en.wikipedia.org/wiki/Wired_logic_connection, wired-AND).</p>

<p>In a similar manner, if any given bus input is 1, the input will turn on the switch
transistor and the logical level at the pullup source will be driven low. All transistors whose gates are
attached to the pullup source terminal will be in cutoff and will not drive the metal
strips low. However, because the bus input is logical high, any transistors whose gate
is attached to the bus input will drive its corresponding bit output low.</p>

<p>We now have enough information to devise boolean expressions and a truth
table for the entire ROM!</p>

<table>
<caption>Output Bits Driven Low For Each Input Bus Line</caption>
<thead>TR(Bus Line+Value, Output Bits Driven Low)</thead>
<tbody>
TR(`I_0 High',  `O_1, O_6, O_7')
TR(`I_0 Low',  `O_0, O_5, O_8, O_9')
TR(`I_1 High',  `O_0, O_3, O_6, O_7')
TR(`I_1 Low',  `O_1, O_4, O_5, O_8, O_9')
TR(`I_2 High',  `O_2, O_5')
TR(`I_2 Low',  `O_0, O_1, O_3, O_4, O_6, O_7, O_8, O_9')
TR(`I_3 High',  `O_1, O_2, O_3, O_6, O_7')
TR(`I_3 Low',  `O_0, O_4, O_5, O_8, O_9')
TR(`I_4 High',  `O_6')
TR(`I_4 Low',  `O_0')
</tbody>
</table>

<table>
<caption>Output Bus Line Equations</caption>
<thead>TR(Bus Line, Boolean Expression)</thead>
<tbody>
TR(`O_0', `~(~I_0 | I_1 | ~I_2 | ~I_3 | ~I_4)')
TR(`O_1', `~(I_0 | ~I_1 | ~I_2 | I_3)')
TR(`O_2', `~(I_2 | I_3)')
TR(`O_3', `~(I_1 | ~I_2 | I_3)')
TR(`O_4', `~(~I_1 | ~I_2 | ~I_3)')
TR(`O_5', `~(~I_0 | ~I_1 | I_2 | ~I_3)'')
TR(`O_6', `~(I_0 | I_1 | ~I_2 | I_3 | I_4)')
TR(`O_7', `~(I_0 | I_1 | ~I_2 | I_3)')
TR(`O_8', `~(I_0 | ~I_1 | ~I_2 | ~I_3)')
TR(`O_9', `~(I_0 | ~I_1 | ~I_2 | ~I_3)')
</tbody>
</table>


<table>
<caption>Extracted ROM Contents of Analyzed Section</caption>
<thead>TR(Input Bus, Output Bus)</thead>
<tbody>
TR(0b00000, 0b0000000100)
TR(0b00001, 0b0000000100)
TR(0b00010, 0b0000000100)
TR(0b00011, 0b0000000100)

TR(0b00100, 0b0011001000)
TR(0b00101, 0b0000001000)
TR(0b00110, 0b0000000010)
TR(0b00111, 0b0000000000)

TR(0b01000, 0b0000000000)
TR(0b01001, 0b0000000000)
TR(0b01010, 0b0000000000)
TR(0b01011, 0b0000100000)

TR(0b01100, 0b0000000000)
TR(0b01101, 0b0000000000)
TR(0b01110, 0b1100010000)
TR(0b01111, 0b0000010000)

TR(0b10000, 0b0000000100)
TR(0b10001, 0b0000000100)
TR(0b10010, 0b0000000100)
TR(0b10011, 0b0000000100)

TR(0b10100, 0b0010001000)
TR(0b10101, 0b0000001000)
TR(0b10110, 0b0000000010)
TR(0b10111, 0b0000000000)

TR(0b11000, 0b0000000000)
TR(0b11001, 0b0000000000)
TR(0b11010, 0b0000000000)
TR(0b11011, 0b0000100000)

TR(0b11100, 0b0000000000)
TR(0b11101, 0b0000000001)
TR(0b11110, 0b1100010000)
TR(0b11111, 0b0000010000)
</tbody>
</table>

<p> As we can see, a number of inputs result in zero state outputs, and the MSB only
changes the output of two ROM entries depending on whether its set or not. Perhaps
a number of these states are illegal and just given a default output?
I wonder what this ROM is used for? When I figure it out, I'll make an edit to this
page!</p>

<h2>Future Direction</h2>
<p>As readers can probably see by now, digitizing and REing old ICs is completely doable, if tedious.
Personally, I would say it's more mechanical than reversing a binary with IDA or radare2, once
you know what to look for. However, like REing a binary, it does take a long time to fully RE an IC.</p>

<p>There are tools to automate the schematic capture process of an IC, and aid in analysis as well.
Olivier Galibert's LINK(`https://github.com/galibert/dietools', `dietools') are one example that I hope to discuss
in future posts.</p>

<p><em>As of writing this post (October 12, 2016), my work in vectorizing and schematic capture of the
YM2151 can be found LINK(https://github.com/cr1901/ym2151-decap, here).</em></p>

<h3>Anecdote</h3>
<p>Back in 2011, I discovered that the MAME project was decapping ICs to defeat
security/protection circuits on old arcade boards that prevented them from being
emulated properly. The me in 2011 thought this was the most fascinating thing, the
"last bastion" of proper accurate emulation. I never thought I would have the
skill set required to do IC analysis.</p>

<p>Even up until summer 2016, I said that I wouldn't do IC reverse engineering,
despite preservation of old technology being important to me. I felt it was beyond
my comprehension, and that I would not be able to learn how to identify features in a reasonable
amount of time. With help from others, I was wrong, and I'm glad that I was. If you're on the fence about
learning a new technical subject, don't hesitate. We're all smart, and filled
with doubt. Others will be willing to help!</p>

<h3>Thanks</h3>
<p>I would like to thank members of siliconpr0n for looking over this post, especially
Olivier Galibert for correcting a few mistakes. Additionally, I'd like to thank
Digi-Key for their extremely useful LINK(http://www.digikey.com/schemeit/, Scheme-it) schematic
program, which I used to create the schematics (including the nice arrow!).</p>





</div>
