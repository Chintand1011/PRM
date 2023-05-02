function OnClientShow(radWindow) {
    var TitleBar = radWindow.GetTitlebar();
    var parent = TitleBar.parentNode;
    var oUL = parent.getElementsByTagName('UL')[0];
    if (!(oUL.firstChild.id == "customprintbuttonID")) // Check if the element is already added
    {
        // If not - create and add the custom button
        oUL.style.width = "192px";
        var oLI = document.createElement("LI");
        oLI.id = "customprintbuttonID";
        var A = document.createElement("A");
        oLI.appendChild(A);
        A.className = "customprintbutton";
        A.href = "javascript:void(0)";
        A.title = "Print Content";
        A.onmousedown = printWin;
        oUL.insertBefore(oLI, oUL.firstChild);
        //this is required so that RadWindow can display its titlebar properly after being modified
        radWindow._updateTitleWidth();
    }
}

