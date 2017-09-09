dnl/* vim: ft=css */
dnl/* -*- mode: css -*- */
dnl
/* CSS - Cascading Style Sheet */
/* Palette color codes */
/* Palette URL: http://paletton.com/#uid=13z0u0k8su61LPO4GD1cVpwhPlc */
dnl
define(PRI_COLOR_1, `rgba(117,137,155,1)')dnl
define(PRI_COLOR_2, `rgba(212,218,224,1)')dnl
define(PRI_COLOR_3, `rgba(162,176,188,1)')dnl
define(PRI_COLOR_4, `rgba( 82,108,132,1)')dnl
define(PRI_COLOR_5, `rgba( 53, 83,109,1)')dnl
dnl
define(COMP_COLOR_1, `rgba(240,214,177,1)')dnl
define(COMP_COLOR_2, `rgba(255,249,241,1)')dnl
define(COMP_COLOR_3, `rgba(255,240,218,1)')dnl
define(COMP_COLOR_4, `rgba(203,169,121,1)')dnl
define(COMP_COLOR_5, `rgba(169,130, 75,1)')dnl
dnl
define(TEXT_COLOR_1, `rgba(0,0,0,0.5)')dnl
define(TEXT_COLOR_2, `rgba(255,255,255,0.5)')dnl
dnl
/* Generated by Paletton.com Â© 2002-2014 */
/* http://paletton.com */

body {
    font-size: 1em;
    line-height: 1.4em;
    font-family: "Verdana";
    background-color: PRI_COLOR_2;
    color: TEXT_COLOR_1;
}

img {
    max-width:100%;
}

table {
    margin: 2em auto;
}

h1, h2, h3 {
    color: PRI_COLOR_4;
}

.container {
    display: inline-flex;
    flex-wrap: no-wrap;
    width: 100%;
}

a {
    color: PRI_COLOR_5;
    text-decoration: none;
}

a:visited {
    color: COMP_COLOR_2;
}

ul {
    list-style-type: none;
}

#main, #nav, #side, #jumptop, #error-text {
    background-color: PRI_COLOR_3;
}

#error-text {
    padding-top: 1em;
}

#error-text > p {
    display: inline-block; /* Collapsing margins. */
}

#undergirder {
    background: linear-gradient(PRI_COLOR_3, PRI_COLOR_2);
}


@media (max-width: 1023px) {
    .container {
        flex-direction: column;
    }

    #nav:first-child {
        content: " Consulting"
    }

    #nav li {
        padding-right: 1em;
        float: left;
        list-style-type: none;
    }

    p.aside {
        float: none;
        width: auto;
    }
}

@media (min-width: 1024px) {
    .container {
        flex-direction: row;
    }

    #me-img > img {
        max-width: 360px;
        max-height: auto;
    }

    /* #nav:first-child {
        text-align: center;
    } */

    #nav h1 {
        text-align: center;
    }
}

#nav, #side {
    padding: 1em;
    flex-grow: 1;
    flex-shrink: 0;
    flex-basis: content;
}

#null-side {
    padding: 0em;
    flex-grow: 1;
    flex-shrink: 0;
    flex-basis: content;
}


#jumptop, #undergirder {
    text-align: center;
}

#undergirder > p {
    display: inline-block; /* Collapsing margins. */
}
