function replaceWordsToBlank(words, node) {
    replaceWordsInTextNode(words, node);
    var child = node.firstChild;
    var next = undefined;
    while (child) {
        next = child.nextSibling;
        replaceWordsToBlank(words, child);
        child = next;
    }
}
 
function replaceWordsInTextNode(words, node) {
    if (node.nodeValue == null) return;
    if (!node.nodeValue.length) return;
    
    if (words.length == 0) return;
    
    for (let i = 0; i < words.length; i++) {
        var word = words[i];
        var nodeValue = node.nodeValue;
        if (nodeValue.includes(word)) {
            node.remove();
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
