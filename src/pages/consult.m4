define(`LINK', `<a href="$1">$2</a>')dnl

<div id="main" role="main">
<h1>Consulting Services</h1>
<p>I have been freelancing on and off since September 2015. I offer
software and hardware development services such as:
<ul>
<li>Desktop GUI applications using Qt 5</li>
<li>Javascript widgets</li>
<li>FPGA design synthesis</li>
<li>Vintage code base maintenance</li>
<li>Windows port of a POSIX codebase</li>
<li>Classifier training using MATLAB</li>
</ul>
</p>
<p>I am most comfortable working with: Python 3, C (including embedded and ISO-compliant), Javascript,
and MATLAB codebases. I additionally have C++, some Rust, and some WebGL experience.</p>

<p>My services are tailored to individuals and companies with open source
code bases who need a feature (this includes FPGA IP) or internal tool implemented.
Please feel free to <a href="mailto:wjones@wdj-consulting.com">email me</a> to discuss any work that
you need done and rates.</p>

<h2>Client Projects</h2>
<h3>Solvespace.js</h3>
<p>LINK(http://solvespace.com/index.pl, Solvespace) is an open source 3D CAD constraints solver. I
implemented a THREE.js canvas for displaying models exported from the main program
in any browser that supports WebGL. The canvas supports touchscreen interfaces
using the extremely useful hammer.js library.</p>

<!-- <h3>ARTIQ</h3>

<h3>HDMI2USB</h3> -->

<h2>Other Projects</h2>
<p>Outside of freelancing, I also work on open source software and hardware. I
wish for electronics designs and electrical engineering knowledge to be more open
and readily available to the enthused hobbyist, as it was in the past.</p>

<p>I have a number of long-term electronics projects. I wish to share my experience
creating electronic designs with the world, regardless of their immediate utility. I contribute to making the world of
electronics more open by open-sourcing my hardware and software. Through my pursuits, I also
contribute to other's open source projects dedicated to keeping the world of
electronics open for study at all levels of abstraction, from full system designs
to individual transitors.</p>

<p>Many of my projects have a vintage electronics component. Projects by others that
I work on are dedicated to opening parts of the electronics industry that historically have
never been transparent to even dedicated hobbyists, such as FPGAs and IC fabrication.</p>

<h3>Migen</h3>
<p>LINK(https://github.com/m-labs/migen, Migen) is a hardware description language (HDL) based on Python that generates Verilog.</p>
<p>Migen automates error-prone mistakes I make in Verilog such as finite-state-machine creation,
and simulation, FPGA, and ASIC-compatible initial value instantiation. In addition to
generating vendor-independent Verilog, Migen provides a unified build system to target
any supported FPGA development board. Adding a custom PCB is relatively simple, being
very similar to writing a user-constraints file (UCF).</p>
<p>Migen also provides useful clock-domain crossing and FIFO primitives as part of itsstandard library that I would
otherwise have to import from external HDL projects.</p>
<p>My contributions to Migen include:
<ul>
<li>Xilinx ISE support for Windows</li>
<li>Windows iverilog VPI support (pre 1.0 API)</li>
<li>Project IceStorm backend</li>
</ul>

<h3>MiSoC</h3>
<p>LINK(https://github.com/m-labs/misoc, MiSoC) is a system-on-a-chip (SoC) designer based on Migen.
MiSoC provides a build system, a set of C and Rust libraries, and a number of Wishbone-compliant peripherals
to connect to an external Verilog or VHDL CPU core (with a Wishbone wrapper). Using MiSoC, it
is easy to create a microcontroller or even an embedded Linux platform on a number
of FPGA development boards. A simple generic SoC is provided as an example to port
to custom hardware or unsupported development boards.</p>

<p>Besides the SPI core refactor, my contributions to MiSoC specifically are mainly
limited to Windows support. As of Decemeber 2016, I am currently using MiSoC's LatticeMico32 support to
create a small SoC which interfaces with a Verilog YM2151 implementation.</p>

</div>
