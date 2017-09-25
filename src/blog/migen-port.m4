dnl -*- mode: html -*-
debugmode(`lt')
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
<h1>Porting a New Board To Migen</h1>
<p>*Taps mic* Is this thing on? So it's really been 11 months since I last
wrote something? I really need to change that! I'm going to <em>attempt</em>
to write smaller articles in between my larger, more involved ones to keep
me motivated to keep writing.</p>

<p>So today, I'm going to write about a simpler topic I meant to discuss last
year, but never got around to it: How to get started with
LINK(https://github.com/m-labs/migen, Migen) on your Shiny New FPGA Development
Board! This post assumes you have previous experience with Python 3 and experience
synthesizing digital logic on FPGAs with Verilog. <em>However, no Migen experience is assumed!</em>
Yes, you can port your a development board to Migen without having used Migen before!
</p>

<h2>What Is Migen- And Why Use It?</h2>
<p>Migen is a Python library (framework, maybe?) to build digital circuits
either for simulation, synthesis on an FPGA, or ASIC fabrication (the latter
of which is mostly untested). Migen is LINK(https://github.com/SpinalHDL, one)
LINK(http://www.myhdl.org, of) LINK(https://chisel.eecs.berkeley.edu, many)
attempts to solve some deficiences with Verilog and VHDL, the languages most
commonly used in industry to develop digital integrated circuits (ICs). If necessary,
a designer can use and import Verilog/VHDL directly into their designs using one of
the above languages too.</p>

<p>All the languages
above either emit Verilog or an LINK(https://github.com/freechipsproject/firrtl, Intermediate Representation)
that can be transformed into Verilog/VHDL. I can think of a few reasons why:</p>

<ol>
<li>FPGA synthesis/ASIC front-ends are typically proprietary, can't be readily modified,
and mostly only support Verilog and VHDL as input.</li>
<li>Many issues with Verilog, such as synthesis-simulation behavior mismatch, don't
occur if Verilog can be emitted in a controlled manner, as is done with the above
languages.`'FN(1)</li>
<li>From my own experience looking at yosys, which can be used as the front-end Verilog compiler
to an LINK(http://www.clifford.at/icestorm/, open-source synthesis toolchain),
there is little gain to targeting a file format meant for FPGA
synthesis (or ASIC fabrication) directly from a higher-level language.
Targeting the synthesis file format directly must be shown to be bug-free with respect
to having generated Verilog <em>and then</em> generating the synthesis file format
from the Verilog; this is nontrivial.
</ol>

<p>The Migen manual discusses its rationale for existing, but the important
reasons that apply to me personally are that Migen:</p>
<ul>
<li>Avoids simulation-synthesis
behavior mismatches in generated output.</li>
<li>Makes it easy to automate
digital logic design idioms that are tedious in Verilog alone, such as
Finite-State Machines and Asynchronous FIFOs.</li>
<li>Prevents classes of bugs in Verilog code, such as ensuring each signal
has an initial value and unused cases in CODE(switch) statements are handled.</li>
<li>Handles assignments satisfying
"same sensitivity list, multiple always blocks" by concatenating them all into a single
CODE(always) block, whereas Verilog forbids this for synthesis. In my experience,
this increases code clarity.</li>
</ul>

<p>As an added bonus, I can write
a Migen design once and, within reason, generate a bitstream of my design
without needing a separate User-Constraints File (UCF) for each board that Migen
supports. This facilitates design reuse by others who may not have the same
board as I do, but has a new board with the required I/O peripherals anyway.</p>

<p>For the above reasons, I am far more productive writing HDL than I ever was
writing Verilog.`'FN(2)</p>

<h3>Choice of Tools Disclaimer</h3>
<p>Of the linked languages above, I have only personally used Migen. Migen was the first
Verilog alternative I personally discovered when I started using FPGAs for projects
again in 2015 (after a 3 year break). When I first saw the typical code
structure of a Migen project, I immediately felt at home writing my own basic
designs, and could easily predict which Migen code would emit which Verilog
constructs without reading the source. In fact, I ported my own Shiny New FPGA Development
Board I just bought to Migen before I even tested my first Migen design!</p>

<p>Because of my extremely
positive first impressions, and time spent learning Migen's more complicated
features, I've had little incentive to learn a new HDL. That said, I maintain it
is up to the reader to experiment and decide which HDL works best for their FPGA/ASIC projects.
I only speak for my own experiences, and the point of me writing this post is
to make porting a new board to Migen easier than when I learned how to do it.
The code re-use aspect of Migen is important to me, and when done correctly,
a port to a new board is very low-maintenance.</p>

<h2>Leveraging Python To Build FPGA Applications</h2>
<p>To motivate how to port a new development board, I need to show Migen code
right now. If you haven't seen Migen before now, don't panic! I'll briefly
explain each section:</p>

<pre><code id="rot">from migen import *
from migen.build.platforms import icestick
from migen.fhdl import verilog

class rot(Module):
    def __init__(self):
        self.clk_freq = 12000000
        self.ready = Signal(1)
        self.rot = Signal(4)
        self.divider = Signal(max=self.clk_freq)
        self.D1 = Signal(1)
        self.D2 = Signal(1)
        self.D3 = Signal(1)
        self.D4 = Signal(1)
        self.D5 = Signal(1)

        ###
        self.comb += [j.eq(self.rot[i]) for i, j in enumerate([self.D1, self.D2, self.D3, self.D4])]
        self.comb += [self.D5.eq(1)]

        self.sync += [
            If(self.ready,
                If(self.divider == int(self.clk_freq) - 1,
                    self.divider.eq(0),
                    self.rot.eq(Cat(self.rot[-1], self.rot[:-1]))
                ).Else(
                    self.divider.eq(self.divider + 1)
                )
            ).Else(
                self.ready.eq(1),
                self.rot.eq(1),
                self.divider.eq(0)
            )
        ]
</code></pre>

<p>If you've never seen Migen code before, and/or are unfamiliar with its
layout, I'll explain some of the more interesting points here in comparison
to Verilog:</p>
<ul>
<li>CODE_BLOCK(`from migen import *
from migen.build.platforms import icestick')
<p>Migen by default exports a number
of primitives to get started writing CODE(Module)s.  Other Migen constructs, such
as a library of useful building blocks (CODE(migen.genlib)) and Verilog code
generation (CODE(migen.fhdl.verilog)) must be imported manually. CODE(migen.build.platforms)
contains all the FPGA development platforms Migen supports; the goal of this blog post
will be to reimplement the LINK(http://www.latticesemi.com/icestick, iCEstick)
development board for use from Migen.</p></li>

<li>CODE_BLOCK(`class rot(Module):')
<p>A CODE(Module) is the basic unit describing digital behavior in Migen. Connections
between CODE(Module)s are typically made by declaring instance variables that
can be shared between CODE(Modules), and using CODE(submodules). Submodule syntax
is described in the manual, and is required to share connections between modules.</p></li>

<li>CODE_BLOCK(`self.ready = Signal(1)')
<p>A CODE(Signal) is the basic data type in Migen. Unlike
Verilog, which requires keywords to distinguish between data storage (CODE(reg))
and connections/nets (CODE(wire)), Migen can infer from a signal's usage
whether or not the signal stores data. The CODE(1) indicates the signal is one-bit
wide.</p></li>

<li>CODE_BLOCK(`self.divider = Signal(max=self.clk_freq)

')
<p>In addition to providing a bit width, I can tell Migen the maximum a CODE(Signal)
is expected to take, and Migen will initialize its width to CODE(log2(max) + 1).
<em>However, nothing prevents the signal from exceeding max when run in a simulator or FPGA.</em></p></li>

<li>CODE_BLOCK(`###
self.comb += [j.eq(self.rot[i]) for i, j in enumerate([self.D1, self.D2, self.D3, self.D4])]

')
<p>By convention, data-type declarations are separated from code describing how code
should behave using CODE(`###'). Migen statements relating connections of
CODE(`Signal')s and other data
types must be appended to either a CODE(comb) or CODE(sync) attribute. Connections are
typically made using the CODE(eq) function of CODE(Signal)s.</p>

<p>CODE(comb), or
combinationial, statements are analogous to Verilog's CODE(assign) keyword or combinational CODE(`always @(*)')
blocks, depending on the Migen data type/construct. In combinational logic, the output immediately
changes in response to a changing or just-initialized) input without any concept of time (in theory).</p></li>


<li>CODE_BLOCK(`self.sync += [
        If(self.ready,
            If(self.divider == int(self.clk_freq) - 1,
                self.divider.eq(0),
                self.rot.eq(Cat(self.rot[-1], self.rot[:-1]))
            ).Else(
                self.divider.eq(self.divider + 1)
            )
        ).Else(
            self.ready.eq(1),
            self.rot.eq(1),
            self.divider.eq(0)
        )
    ]')

<p>By contrast, appending to the Migen CODE(sync), or synchronous, attribute emits
Verilog code whose output only changes in response to a <em>positive edge</em> clock
transition of a given clock, using
the following syntax: CODE(`module.sync.my_clk += [...]'). If the clock is omitted, the
clock defaults to CODE(sys). In synchronous/sequential logic, outputs do not change
immediately in response to a changing or just-initialized input; the output only registers a new value based
on its input signals in response to a low-to-high transition of another, usually periodic, signal.
Migen only emits CODE(`always @(posedge clk)') blocks, so a CODE(negedge) clock must
be created by inverting an existing clock, such as CODE(self.comb += [neg_clk.eq(~pos_clk)]).</p>

<p>As one might expect, CODE(`If().Elif().Else()') is analogous to Verilog CODE(if),
CODE(else if), CODE(else) blocks. Migen will generate the correct style of CODE(`always')
block to represent signal transitions regardless of whether the CODE(If()) statement is
part of a CODE(comb) or CODE(sync) block.</p></li>
</ul>

<p>I omitted discussing any Migen data types, input arguments to their constructors,
other features provided by the package, and common code idioms that I didn't use above
for the sake of keeping this blog post on point. Most of the
user-facing features/constructors are documented in the user manual. I can discuss
features (and behavior) not mentioned in the manual in a follow-up post.</p>

<h2>Adding a New Board</h2>
<p>The LINK(`#rot', above code) was adapted from the
LINK(`https://github.com/cseed/arachne-pnr/tree/master/examples/rot', rot.v)
example of Arachne PNR. In words, the above code turns on an LED, counts for 12,000,000
clock cycles, then turns off the previous LED and lights another of 4 LEDs. After 4 LEDs
the cycle repeats; a fifth LED is always kept on as soon as the FPGA loads its
bitstream.</p>

<p>Our goal is to get this simple Migen design to work on a new FPGA development board,
walking through the process. Since this example is tailored to the iCE40 FPGA family,
I'm choosing to port the iCEstick board to Migen... which already has a port...</p>

<h3>Interactive Porting</h3>
<p>My original intention was to write this blog post <em>while</em> I was
creating the CODE(icestick.py) platform file to be committed into CODE(migen.build).
Unfortunately, at the time, Migen did not have any support for targeting the
IceStorm synthesis toolchain.`'FN(3) So I ended up
LINK(https://ssl.serverraum.org/lists-archive/devel/2016-May/004205.html, implementing)
the IceStorm backend and doing my blog post as intended went by the wayside while
debugging.</p>

<p>That said, I'm going to attempt to simulate the process of adding a board
from the beginning. I will only assume that the IceStorm backend to Migen exists,
but the CODE(icestick.py) board file does not.</p>

<h3>We Need a Constraints File</h3>
<p>Before I can start writing a board file for iCEstick, we need to know which
FPGA pins are connected to what. For many boards, the manufacturer will provide
a full User-Constraints File (UCF) with this information. For demonstrative purposes`'FN(4)
however, I will examine the schematic diagram of iCEstick instead to create
my Migen board file. This can be found in a file provided by Lattice at a
changing URL called "icestickusermanual.pdf".</p>

<p>We need to know the format of FPGA PIN identifiers that Arachne PNR, the
place-and-route tool for IceStorm will expect as well. The format differs for
each of the FPGA manufacturers and even between FPGA families of the same
manufacturer; Xilinx, for example uses CODE([A-Z]?[0-9]*), as does the Lattice
ECP3 family. Fortunately, IceStorm uses pin numbers that correspond to the device
package, and these are easily visible on the schematic:<p>

IMG(icestick-schem, `One side (port) of connections of the iCE40 FPGA to
iCEstick peripherals. In this image, LED, IrDA, and one side of 600 mil
breadboard-compatible breakout connections can be seen.')

<p>If we examine the schematic and user manual, we will find the following
peripherals:</p>

<ul>
<li>5 LEDs</li>
<li>2x6 Digilient PMOD connector</li>
<li>IrDA transceiver</li>
<li>SPI Flash</li>
<li>FT2232H UART (one channel- the other is used for programming)</li>
<li>16 Additional I/O pins</li>
</ul>

<p>We might not have an actual <em>full</em> constraints file to work with due to
how CODE(arachne-pnr) works, but we have all the information to create a Migen board
file anyway, since we have the schematics. Armed with this information, we can
start creating a board file for iCEStick.</p>

<h3>Anatomy of a Migen Board File</h3>
<p>Relative to the root of the migen package, migen places board definition files
under the CODE(build/platforms) directory. <em>All paths in this section, unless
otherwise noted are relative to the package root.</em></p>

<h4>Platform Class</h4>
CODE_BLOCK(`from migen.build.generic_platform import *
from migen.build.lattice import LatticePlatform
from migen.build.lattice.programmer import IceStormProgrammer

class Platform(LatticePlatform):
    default_clk_name = "clk12"
    default_clk_period = 83.333

    def __init__(self):
        LatticePlatform.__init__(self, "ice40-1k-tq144", _io, _connectors,
            toolchain="icestorm")

    def create_programmer(self):
        return IceStormProgrammer()')

<p>A board file consists of the definition of Python CODE(class) conventionally named
CODE(Platform). CODE(Platform) should inherit from a class defined for each supported
FPGA manufacturer. As of this writing, Migen exports CODE(AlteraPlatform),
CODE(XilinxPlatform), and CODE(LatticePlatform), and more are possible in
the future. Vendor platforms are defined in a subdirectory under CODE(build)
for each vendor, in the file CODE(platform.py).</p>

<p>Each FPGA vendor in turn inherits from CODE(GenericPlatform), which
is defined in CODE(build/generic_platform.py) and exports a number of useful methods
for use in Migen code (I'll introduce them as needed). The CODE(GenericPlatform)
LINK(`https://github.com/m-labs/migen/blob/master/migen/build/generic_platform.py#L230', constructor)
accepts the following arguments:
</p>

<ul>
<li>CODE(device)- A string indicating the FPGA device on your board.FN(5) The
string format is vendor-toolchain specific; in the case of IceStorm, the format
is currently CODE(`"ice40-{1k,8k}-{package}"').</li>
<li>CODE(io)- A list of tuples of a specific format which I'll describe shortly.
The list represents all non-user-expandable I/O resources on your current board.
For instance, LEDs, SPI flash, and ADC connections to your FPGA would be placed
in the CODE(io) list.</li>
<li>CODE(connectors)- A list of tuples with a specific layout, which I'll describe
shortly. The list represents user-expandable I/O that by default is not connected
to any piece of hardware, such as LINK(https://en.wikipedia.org/wiki/Pmod_Interface, Pmod)
headers.</li>
<li>CODE(name)- I don't know what this input argument does exactly. Like other places in
Migen with a CODE(name) input argument, it's meant to control how variable names are generated
in the Verilog output. I don't believe it's used by any board file, so I'm ignoring it.</li>
<li>CODE(toolchain)- The same FPGA vendor can have multiple software suites for their FPGA families,
or third-party toolchains can exist. For instance, Xilinx has both the End-of-Life
ISE Toolchain and Vivado software available. Additionally, Lattice provides the Diamond
toolchain for their higher-end FPGAs while Project IceStorm is an unaffialited open-source synthesis flow
for the iCE40 family. Thus, the vendor platform constructors
LINK(`https://github.com/m-labs/migen/blob/master/migen/build/lattice/platform.py#L8', also supply)
a CODE(toolchain) keyword argument to choose which toolchain to eventually invoke.
In the case of iCEStick, we use Migen's CODE(icestorm) backend.</li>
</ul>

<p>A CODE(Platform) class definition should also define the class variables
CODE(default_clk_name) and CODE(default_clk_period), which are used by CODE(GenericPlatform).
CODE(default_clk_name) should match the name of a resource in the CODE(io) list
that represents a clock input to the FPGA. CODE(default_clk_period) is used by vendor-specific
logic in Migen to create a clock constraint in nanoseconds for CODE(default_clk_name). <em>The default
clock is associated with the CODE(sys) clock domain for CODE(sync) statements.</em></p>

<p>Lastly, the CODE(create_programmer) function should return a vendor-specific programmer.
Adding a programmer is beyond the scope of this article. If a
board can support more than one programming tool, the convention is to return
a programmer based on a
LINK(`https://github.com/m-labs/migen/blob/master/migen/build/platforms/minispartan6.py#L120-L126', CODE(programmer) class variable)
for the given board. This function can be omitted if no programmer fits, or
one can be created on-the-fly using CODE(GenericPlatform.create_programmer).</p>


<h4>Finalization</h4>
<p>Some platforms Migen supports, such as the
LINK(`https://github.com/m-labs/migen/blob/master/migen/build/platforms/lx9_microboard.py#L119-L131', LX9 Microboard),
have a CODE(do_finalize) method. Finalization in Migen allows a user to defer adding logic
to their design until overall resource usage is known. In particular, LX9 Microboard has
an Ethernet peripheral, and the Ethernet clocks should use separate timing constraints
from the rest of the design. The linked code detects whether the Ethernet
peripheral was used using CODE(GenericPlatform.lookup_request("eth_clocks")), and adds
appropriate platform constraints to the current design to be synthesized if necessary. If
the Ethernet peripheral was not used in the design, the extra constraints are not added,
and the CODE(ConstraintError) from CODE(lookup_request) is ignored.</p>

<p>Finalization operates on an internal Migen data structure
called CODE(Fragment)s. CODE(Fragment)s require knowledge of Migen internals to use properly, so
for the time being I suggest following the linked example if you need to add constraints conditionally.
Of course, timing constraints and other User Constraints File data can be added at any point in
your design manually using CODE(GenericPlatform.add_period_constraint) and
CODE(GenericPlatform.add_platform_command) respectively.</p>

<p>IceStick does not have any peripherals which need special constraints, and only
a single clock; Migen will automatically add a constraint for the default clock.
More importantly, in the case of IceStorm/iCEStick, only a global clock constraint
is supported due to limitations in specifying constraints. Therefore, I omit the CODE(do_finalize)
method for the iCEStick board file. However, one use I have found for CODE(do_finalize)
in platforms compatible with IceStorm is to automatically instantiate pins with
pullup resistors enabled. This gets around the limitations of Arachne PNR's constraints
file format without needing to instantiate Verilog primitives directly in the top
level of a Migen source file, and I can show code upon request.</p>

<h4>I/O and Connectors</h4>
<p>After defining a CODE(Platform) class for your board, all you need to do
is fill in a list of CODE(_io) and CODE(_connectors) in your board file, pass
them into your CODE(Platform)'s vendor-specific base class constructor, and
Migen will take care of the rest!</p>

<p>As I stated before, CODE(io) and CODE(connectors) input arguments to the
vendor-specific platform constructor are lists of tuples with a specific format.
Let's start with an I/O tuple:
</p>

CODE_BLOCK(`(io_name, id, Pins("pin_name", "pin_name") or Subsignal(...), IOStandard("std_name"), Misc("misc"))')

<p>An CODE(io_name) is the name of the peripheral, and should match the string
passed into the CODE(request) function to gain access to the peripheral's signals
from Migen. CODE(id) is a number to distinguish multiple copies of identically-functioning
peripherals, such as LEDs. For simple peripherals, CODE(Pins) is a helper class which
should contain strings corresponding to the vendor-specific pin identifiers where
the peripheral connects to the FPGA; in the case of IceStorm, there are just the pin
numbers as defined on the package pinout. I will discuss CODE(Subsignal)s in the next paragraph. These
tuple entries are used to create inputs and output names in the Migen-generated Verilog, and
provide a variable-name to FPGA pin mapping in a Migen-generated User Constraints File (UCF)</p>

<p>Without going into excess detail`'FN(6),
CODE(Subsignals) are a helper class to for resources
that use FPGA pins which can be seperated cleanly by purpose. The inputs to a CODE(Subsignal)
constructor are identical to an I/O tuple entry, except with CODE(id) omitted. The net effect
for the end user is that a resource is encapsulated as a class whose Migen CODE(Signals)
are accessed via the class' members, i.e. CODE(comb += [my_resource.my_sig.eq(5)]). This is known
as a CODE(Record) in Migen. CODE(Records) also come with a number of useful
LINK(https://github.com/m-labs/migen/blob/master/migen/genlib/record.py, methods)
for constructing Migen statements quickly. Think of them as analogous to C
CODE(structs). It is up to your judgment whether an I/O peripheral should use
CODE(Subsignals), but in general, I notice that Migen board files make heavy use
of them.</p>

<p>The remaining inputs to an I/O tuple entry are optional. CODE(IOStandard) is another helper class
which contains a toolchain-specific string that identifies which voltages/logic
standard should use. And lastly, the CODE(Misc) helper class contains a space-separated
string of other information that should be placed into the User Constraints File along
with CODE(IOStandard). Such information includes
LINK(`https://github.com/m-labs/migen/blob/master/migen/build/platforms/mercury.py#L35', slew rate)
and whether pullups should be enabled. <em>These are in fact currently ignored in
the IceStorm toolchain, but for my own reference I have filled them in as necessary.</em></p>

<p>A connector tuple is a bit simpler:</p>
CODE_BLOCK(`(conn_name, "pin_name, pin_name, pin_name,...")')

<p>CODE(conn_name) is analogous to CODE(io_name). The second element of a connector
tuple is a space-separated string of pin names matching the vendor's format
which indicates which pins on the FPGA are associated with that particular connector.
Ideally, the pins should be listed in some order that makes sense for the connector.</p>

<p>By default, pins that are associated with connectors are not exposed by
the CODE(Platform) via the CODE(request) method. Instead, a user needs to
notify the platform that they wish to use the connector as extra I/O using
the CODE(GenericPlatform.add_extension) method. Here is an example adding a
LINK(`PMOD I2C peripheral', https://blog.digilentinc.com/new-i2c-standard-for-pmods/)
using CODE(add_extension):</p>

CODE_BLOCK(my_i2c_device = [
    ("i2c_device", 0,
        Subsignal("sdc", Pins("PMOD:2"), Misc("PULLUP")),
        Subsignal("sda", Pins("PMOD:3"), Misc("PULLUP"))
    )
]

plat.add_extension(my_i2c_device)
plat.request("i2c_device")')

<p>Note that adding a peripheral using CODE(add_extension) is similar to adding
a peripheral to the CODE(io) list, except that the CODE(Pins()) element takes on
the form CODE("conn_name:index"). CODE(conn_name) should match a tuple in the
CODE(connectors) list, and CODE(index) is a zero-based index into the string
of FPGA pins associated with the connector. This allows you to create peripherals
on-the-fly that are (in theory) board and vendor-agnostic.</p>

<p>With the last concepts out of the way, let's jump right into creating the
CODE(_io) and CODE(_connectors) list for our Platform. Each listed peripheral
is implied to be a tuple inside CODE(_io = [...] or _connectors = [...]):

CODE_BLOCK(`("user_led", 0, Pins("99"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("98"), IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("97"), IOStandard("LVCMOS33")),
    ("user_led", 3, Pins("96"), IOStandard("LVCMOS33")),
    ("user_led", 4, Pins("95"), IOStandard("LVCMOS33")),')

<p>CODE(user_led)s are simple peripherals found on just about every development
board; iCEStick has 5 of them, all identical in function (but the 5th one is green!).
Resources with identical function that differ only in a pin should each be
declared in their own tuple, incrementing the CODE(id) index.</p>

<p>Resource signal names are by convention; if a resource does not yet exist, it's
up to you what you want to name the resource. However, I suggest looking at
other board files for prior examples. CODE(user_led), CODE(user_btn), CODE(serial.rx),
CODE(serial.tx), CODE(spiflash), and CODE(audio) are all commonly-used I/O names
used between board files.</p>

CODE_BLOCK(`("serial", 0,
        Subsignal("rx", Pins("9")),
        Subsignal("tx", Pins("8"), Misc("PULLUP")),
        Subsignal("rts", Pins("7"), Misc("PULLUP")),
        Subsignal("cts", Pins("4"), Misc("PULLUP")),
        Subsignal("dtr", Pins("3"), Misc("PULLUP")),
        Subsignal("dsr", Pins("2"), Misc("PULLUP")),
        Subsignal("dcd", Pins("1"), Misc("PULLUP")),
        IOStandard("LVTTL"),
    ),')

<p>Next we have another common peripheral- a UART/serial port. A UART peripheral
makes sense to divide using CODE(Subsignal)s, since each pin has a distinct purpose.
Although in practice most users will only use CODE(rx) and CODE(tx)`'FN(7), I include all
possible pins just in case. I don't remember why I included CODE(PULLUP) as
user constraints information. Note that it's perfectly okay to associate a constraint
with all CODE(Subsignal)s at once, as I do for the (unused) CODE(IOStandard).

CODE_BLOCK(`("irda", 0,
        Subsignal("rx", Pins("106")),
        Subsignal("tx", Pins("105")),
        Subsignal("sd", Pins("107")),
        IOStandard("LVCMOS33")
    ),')

<p>The infrared port on iCEStick is another serial port, sans most of the
control signals. I omit the optional I/O tuple/CODE(Subsignal) entries here, and
define the CODE(IOStandard) similarly to the previous CODE(serial) peripheral.</p>

CODE_BLOCK(`("spiflash", 0,
        Subsignal("cs_n", Pins("71"), IOStandard("LVCMOS33")),
        Subsignal("clk", Pins("70"), IOStandard("LVCMOS33")),
        Subsignal("mosi", Pins("67"), IOStandard("LVCMOS33")),
        Subsignal("miso", Pins("68"), IOStandard("LVCMOS33"))
    ),')

<p>CODE(spiflash) and its CODE(Subsignal) have standardized, self-explanatory names.
I suggest using these signal names when appropriate for all peripherals connected
via an LINK(https://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus, SPI bus).
I don't remember why I added the CODE(IOStandard) per-signal instead of all-at-once here,
but the net effect would be the same either way if IceStorm made use of CODE(IOStandard).</p>


CODE_BLOCK(`("clk12", 0, Pins("21"), IOStandard("LVCMOS33"))')

<p>Clock signals should be included as well, with at least one clock's CODE(io_name)
matching the CODE(default_clk_name). Migen may automatically CODE(request) a clock
for your design if certain conditions are met; for now, assume you don't have
to CODE(request) the clock.</p>

CODE_BLOCK(`("GPIO0", "44 45 47 48 56 60 61 62"),
    ("GPIO1", "119 118 117 116 115 114 113 112"),
    ("PMOD", "78 79 80 81 87 88 90 91")
]')

<p>And lastly we have the connectors. The connector pins for CODE(GPIO0-1) and
CODE(PMOD) are ordered in increasing pin order, which matches the order they
are laid out on their respective connectors. <em>This is a happy coincidence. Make sure
to check your schematic and order FPGA pins in connector order, not the other
way around!</em></p>
</p>


<h2>Building Our Design For Our "New" Board</h2>
<p>Now that we have created our board file, we now need to write the remaining
logic to attach the board's I/O to our <a href="#rot">rot top level</a>. Assuming
the CODE(rot) module is already defined, we can create a script that will synthesize
our design like so:</p>

CODE_BLOCK(`if __name__ == "__main__":
    plat = icestick.Platform()
    m = rot()
    m.comb += [plat.request("user_led").eq(m.D1) for l in [m.D1, m.D2, m.D3, m.D4, m.D5]]
    plat.build(m, run=True, build_dir="rot", build_name="rot_migen")
    # plat.create_programmer().flash(0, "rot/rot_migen.bin")')

<p>Once again, I will explain each line. It should be appended to the rot top level
and then run using your Python 3 interpreter:</p>

<ul>
<li>CODE_BLOCK(`plat = icestick.Platform()
m = rot()')
<p>We create our platform and our rot module here. CODE(plat) contains a number
of useful helper methods that help customize what is eventually sent to the
synthesis flow.</p></li>

<li>CODE_BLOCK(`m.comb += [plat.request("user_led").eq(m.D1) for l in [m.D1, m.D2, m.D3, m.D4, m.D5]]

')
<p>This list comprehension is how we actually connect our I/O to the LED rotation module.
CODE(`plat.request("user_led")') will create a Migen CODE(Signal) or CODE(Record) which
can be used to assign to CODE(Signals) and CODE(Records) in an existing CODE(Module).
CODE(GenericPlatform) does bookkeeping to figure out which CODE(Signals) should be considered
I/Os from the generated Verilog top level (and consequently, mapped to a User Constraints
File).</p>
<p>Repeatedly calling CODE(request) for a given resource
name will return a new CODE(Signal) or CODE(Record) of the same type, throwing a
CODE(ConstraintError) exception if there are no more available resources.</p></li>

<li>CODE_BLOCK(`plat.build(m, run=True, build_dir="rot", build_name="rot_migen")

')
<p>The CODE(GenericPlatform.build) function will emit Verilog output, a User Constraint File
specific to your design, a batch file or shell script to invoke the synthesis flow, and any
other files required as input to the synthesis toolchain. Optionally, Migen will invoke
the generated script to create your design if input argument CODE(run) is true.
CODE(build_dir) is self-explanatory, and CODE(build_name) controls the filename
of generated files.</p>
<p>I pass in my top level CODE(rot) CODE(Module) to the CODE(build) function.
CODE(GenericPlatform) has internal logic to detect which signals were declared as
I/O in the board file while generating Verilog input and output arguments.</p></li>

<li>CODE_BLOCK(`plat.create_programmer().flash(0, "rot/rot_migen.bin")

')
<p>This line is optional, but if included, Migen will invoke the CODE(iceprog)
FTDI MPSSE programmer for iCEStick automatically after creating a bitstream using
IceStorm. The first input argument is the start address to start programming, and
the second argument is the name of the output bitstream. The name can be inferred
from CODE(build_name) and the toolchain's default extension for bitstreams.</p></li>
</ul>

<p>If all goes well, and you were following along, you should now have a blinking
LED example on your iCEStick! The final iCEStick platform board file is here,
which you can use as a reference, and I've made the CODE(rot) top level available
as a gist.</p>

<h2>Happy Hacking!</h2>
<p>If you have read up to this point, you now have some grasp on the Migen
framework, and can now start using Migen in your own designs on your own
development (or even deployed) designs!</p>

<p>Porting Migen to support your design
takes relatively little effort, and you will quickly make up the time spent porting.
Besides automating HDL idioms that are tedious to write by hand (such as FSMs),
and generating Verilog that is free of certain bug classes, Migen saves time as it automates generating
input files and build commands for your synthesis toolchain, and then invoking the synthesis
flow automatically. Additionally, if you write your top-level CODE(Module) and glue code
correctly, you can have a single HDL design that runs on all platforms that Migen
supports, even between vendors, with much less effort than is required to do the
same in Verilog alone!`'FN(8)</p>

<p>Migen is certainly a step in the right direction for the future of hacking with
FPGAs, and I hope you as the reader give it a try with your Shiny New Development
Board like I did, and see whether your experiences were as positive as mine.</p>

<h2>Footnotes</h2>
FN_TARGET(1, `For better or worse, emitting Verilog requires someone intimately
familiar with the Verilog specification. Like all good specifications, it is
terse, and requires a lot of memorization. But both Yosys and Migen are by and
large the work of one individual each, so it can be done.')
FN_TARGET(2, `In the interest of fairness, 'LINK(https://github.com/olofk/fusesoc, fusesoc)` exists
now to alleviate the burdern of Verilog code-sharing. I was unaware of its existence when I started
using FPGAs again. I think Migen build integration would be an interesting project; in general, I find
setting up a board-agnostic Migen design easier than w/ FuseSoC, but importing Verilog code as a
package is still incredibly useful.')
FN_TARGET(3, `I erroneously assumed that because the Xilinx
backend code can use the yosys Verilog compiler that there was support for support for
yosys and by extension IceStorm in the Lattice backend. Not having had any Lattice
FPGAs before iCEstick (yes, I jumped on the FOSS FPGA toolchain bandwagon), I never
actually bothered to check beforehand!')
FN_TARGET(4, `Historically, I''`ve found that IceStorm Verilog code samples only define the pins
their designs actually use. Unlike Quartus or ISE, Arachne PNR will error out
instead of warn if constraints that are defined aren''`t actually used. Migen doesn''`t
have this issue because it will only generate constraints that are actually used
for Arachne PNR.')
FN_TARGET(5,  `Each
CODE(Platform) consists of a single FPGA and attached peripherals. I assume
a board with multiple FPGAs should implement a CODE(Platform) for each FPGA in a single board
file.')
FN_TARGET(6, `Subsignals also 'LINK(`https://github.com/m-labs/migen/blob/master/migen/build/generic_platform.py#L209-L221', modify)
`how signal names are generated for the remainder of the synthesis toolchain.')
FN_TARGET(7, `iCEStick disappoints me in that the engineers wired <em>nearly</em> all the
connections required to use the FT2232H in FT245 queue mode, which is much faster than
a serial port; most dev boards do not bother connecting anything besides serial TX
and RX, and possibly RTS/CTS. But alas, there''`s still not enough control connections
to use queue mode.')
FN_TARGET(8, `Portability of code gives me joy, and HDL portability
is no exception.')

<!-- <p>The t -->
</div>
