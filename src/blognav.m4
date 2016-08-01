dnl define(`MONTH', `<a href="xPATH_TO_ROOT/blog.html#$1-$2">$1-$2</a>')dnl
define(`MONTH', `<li><a href="xPATH_TO_ROOT/blog.html#$1-$2">$1-$2</a></li>')dnl
define(`POST', `<li><a href="xPATH_TO_ROOT/blog/$1.html">$2</a></li>')dnl
define(`DEAD_POST', `<li>$2</li>')dnl

<div id="side" role="complementary">
    <ul>
        MONTH(4, 2016)
        MONTH(2, 2016)
    </ul>

<!-- <div class="blognav" id=4-2016>
    MONTH(4, 2016)
    <ul class="blog_list">
        DEAD_POST(`floppy-pll', `Floppy Disk Primer IV: MFM Decoder PLL Design')
        DEAD_POST(`floppy-fm', `Floppy Disk Primer III: FM and MFM Encoding')
        DEAD_POST(`floppy-tf', `Floppy Disk Primer II: R/W Head Transfer Function')
    </ul>
</div>

<ol class="blognav" id=2-2016>
    MONTH(2, 2016)
    <ul class="blog_list">
        POST(`floppy-intro', `Floppy Disk Primer I: Overview')
        POST(`floppy-lit', `Floppy Disk Primer Nulla: Literature')
    </ul>
</ol>  -->
</div>
