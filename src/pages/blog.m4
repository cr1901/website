dnl define(`xBLOGNAV', ``include(xBLOGNAV)'')dnl
define(`POST', `<li><a href="blog/$1.html">$2</a></li>')dnl
define(`DEAD_POST', `<li>$2</li>')dnl 
dnl    include(blog/$1.m4)')dnl


<div id="main" role="main">
    <p>Anachronism is my blog where I discuss any electronics-related pursuits
    that tickle my fancy. As one might guess from the name, I have a tendency
    to uncomfortably mix the old with the new.</p>

    <div id=2-2016>
        <h2>February 2016</h2>
        <ul>
            DEAD_POST(`floppy-pll', `Floppy Disk Primer IV: MFM Decoder PLL Design')
            DEAD_POST(`floppy-fm', `Floppy Disk Primer III: FM and MFM Encoding')
            DEAD_POST(`floppy-tf', `Floppy Disk Primer II: R/W Head Transfer Function')
            POST(`floppy-intro', `Floppy Disk Primer I: Overview')
            POST(`floppy-lit', `Floppy Disk Primer Nulla: Literature')
        </ul>
    </div>
</div>

include(xBLOGNAV)