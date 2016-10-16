/* vim: ft=css */
/* -*- mode: css -*- */

body {
    font-size: 1em;
    line-height: 1.4em;
    font-family: "Courier New", Courier, monospace;
}

img {
    max-width:100%;
}

table {
    margin: 2em auto;
}

.container {
    display: inline-flex;
    flex-wrap: no-wrap;
    width: 100%;
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
}

#nav, #side {
    padding: 1em;
    flex-grow: 1;
    flex-shrink: 0;
    flex-basis: content;
}

#jumptop, #undergirder {
    text-align: center;
}
