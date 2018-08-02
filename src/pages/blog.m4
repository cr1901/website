define(`xBLOGNAV', ``include(xBLOGNAV)''')dnl
define(`POST', `<li><a href="blog/$1.html">$2</a></li>')dnl
define(`DEAD_POST', `<li>$2</li>')dnl
dnl    include(blog/$1.m4)')dnl

<div id="main" role="main">
    <p>Anachronism is my blog where I discuss any electronics-related pursuits
    that tickle my fancy. As one might guess from the name, I have a tendency
    to uncomfortably mix the old with the new.</p>

    <div id=8-2018>
        <h1 class="date">August 2018</h1>
        <ul class="blog_list">
            DEAD_POST(`rpi-ppp', `Internet Access Using A Raspberry Pi''`s Serial Port')
        </ul>
    </div>

    <div id=9-2017>
        <h1 class="date">September 2017</h1>
        <ul class="blog_list">
            POST(`migen-port', `Porting a New Board To Migen')
        </ul>
    </div>

    <div id=10-2016>
        <h1 class="date">October 2016</h1>
        <ul class="blog_list">
            POST(`nmos-sample', `NMOS IC Reverse Engineering Sample')
        </ul>
    </div>

divert(-1)dnl
    <div id=8-2016>
        <h1 class="date">August 2016</h1>
        <ul class="blog_list">
            DEAD_POST(`bit-cells', `Floppy Disk Primer: Bit Cells')
        </ul>
    </div>

    <div id=4-2016>
        <h1 class="date">April 2016</h1>
        <ul class="blog_list">
            DEAD_POST(`floppy-pll', `Floppy Disk Primer IV: MFM Decoder PLL Design')
            DEAD_POST(`floppy-fm', `Floppy Disk Primer III: FM and MFM Encoding')
            DEAD_POST(`floppy-tf', `Floppy Disk Primer II: R/W Head Transfer Function')
        </ul>
    </div>
divert(0)dnl

    <div id=2-2016>
        <h1 class="date">February 2016</h1>
        <ul class="blog_list">
            POST(`floppy-intro', `Floppy Disk Primer I: Overview')
            POST(`floppy-lit', `Floppy Disk Primer Nulla: Literature')
        </ul>
    </div>
</div>


xBLOGNAV
