// to format resource info

var licences = {
    "CC0": { "name": "CC0", "url": "https://creativecommons.org/publicdomain/zero/1.0" },
    "CC-BY-SA-3.0": { "name": "CC BY-SA 3.0", "url": "https://creativecommons.org/licenses/by-sa/3.0/" },
    "CC-BY-NC-ND-3.0": { "name": "CC BY-NC-ND 3.0", "url": "https://creativecommons.org/licenses/by-nc-nd/3.0/" },
    "OFL": { "name": "OFL", "url": "http://scripts.sil.org/OFL" },
}

var resources = [
            {
                "description": qsTr("Background"),
                "name": "Rice paper 2",
                "url": "http://subtlepatterns.com/rice-paper-2/",
                "author": "Atle Mo",
                "authorUrl": "http://atle.co/",
                "licence": "CC-BY-SA-3.0",
                "additionalInfo": ""
            },
            {
                "description": qsTr("Decorative"),
                "name": "Ivy",
                "url": "https://pixabay.com/pl/ivy-wirowa%C4%87-upadek-design-okr%C4%85g-303546/",
                "author": "Clker-Free-Vector-Images",
                "authorUrl": "https://pixabay.com/pl/users/Clker-Free-Vector-Images-3736/",
                "licence": "CC0",
                "additionalInfo": qsTr("Colors changed")
            },
            {
                "description": qsTr("Icons"),
                "name": "Devine",
                "url": "http://findicons.com/pack/1579/devine/1",
                "author": "ipapun",
                "authorUrl": "http://ipapun.deviantart.com/",
                "licence": "CC-BY-NC-ND-3.0",
                "additionalInfo": ""
            },
            {
                "description": qsTr("Font"),
                "name": "Josefin Sans",
                "url": "http://www.1001freefonts.com/josefin_sans.font",
                "author": "Santiago Orozco",
                "authorUrl": "http://www.1001freefonts.com/designer-santiago-orozco-fontlisting.php",
                "licence": "OFL",
                "additionalInfo": ""
            },
]

function formatLink(description, address) {
    return "<a href=\"" + address + "\">" + description + "</a>";
}

function getInfo() {
    var infoString = ""
    var indent = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

    for (var i=0; i<resources.length; ++i)
    {
        var item = resources[i];
        var licence = licences[item.licence]

        infoString += "<u>" + item.description + ":</u>" + "<br/>";
        infoString += indent + formatLink(item.name, item.url)
                + " " + qsTr("by") + " " + formatLink(item.author, item.authorUrl)
                + " " + qsTr("under") + " " + formatLink(licence.name, licence.url) + "<br/>";
        if (item.additionalInfo.length)
        {
            infoString += indent + "<i>" + item.additionalInfo + "</i>" + "<br/>";
        }
    }
    return infoString;
}
