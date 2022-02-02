function replaceWordsToBlank(words, node) {
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
                replaceWordsToBlank(words, child);
                child = next;
            }
            break;
        case Node.TEXT_NODE:
            replaceWordsInTextNode(words, node);
            break;
    }
}
 
function replaceWordsInTextNode(words, textNode) {
    if (textNode.nodeType !== Node.TEXT_NODE)
        return;
    
    if (!textNode.nodeValue.length)
        return;
    
    if (words.length == 0) return;
    
    for (let i = 0; i < words.length; i++) {
        var enginner = new RegExp(words[i], "gi");
        var nodeValue = textNode.nodeValue;
        var newNodeValue = nodeValue.replace(enginner, "");
        if (nodeValue !== newNodeValue) {
            textNode.remove();
        }
    }
}

browser.runtime.sendMessage({
    type: "content"
},
    function(response) {
    if (response.words) {
        replaceWordsToBlank(response.words, document.body);
    }
});
