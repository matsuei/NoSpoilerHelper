function replaceEngineerToBlank(node) {
    switch (node.nodeType)
    {
        case Node.ELEMENT_NODE:
            if (node.tagName.toLowerCase() === "input" || node.tagName.toLowerCase() === "textarea") {
                return;
            }
        case Node.DOCUMENT_NODE:
        case Node.DOCUMENT_FRAGMENT_NODE:
            var child = node.firstChild;
            var next = undefined;
            while (child) {
                next = child.nextSibling;
                replaceEngineerToBlank(child);
                child = next;
            }
            break;
        case Node.TEXT_NODE:
            replaceTextInTextNode(node);
            break;
    }
}
 
function replaceTextInTextNode(textNode) {
    if (textNode.nodeType !== Node.TEXT_NODE)
        return;
    
    if (!textNode.nodeValue.length)
        return;
    
    var enginner = new RegExp("エンジニア", "gi");
    var nodeValue = textNode.nodeValue;
    var newNodeValue = nodeValue.replace(enginner, "");
    
    if (nodeValue !== newNodeValue) {
        textNode.nodeValue = newNodeValue;
    }
}

browser.runtime.sendMessage({
    type: "content"
},
    function(response) {
//    replaceEngineerToBlank(document.body);
    if (response.type) {
        replaceEngineerToBlank(document.body);
    }
});
