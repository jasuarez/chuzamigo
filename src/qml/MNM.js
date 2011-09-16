.pragma library

var RSS_PUBLISHED = 'http://www.meneame.net/rss2.php?status=published&nohtml'
var RSS_PENDING = 'http://www.meneame.net/rss2.php?status=queued&nohtml'
var RSS_COMMENTS = 'http://www.meneame.net/comments_rss2.php?nohtml&id='
var REFRESH_HEADER_TIMEOUT = 3000

function sanitizeText(text) {
    // "Save" existing <br /> into &lt;br /&gt;, remove all tags
    // and put the <br /> back there
    var sanitizedText = text.replace(/<br \/>/g, '&lt;br /&gt;').replace(/<.*?>/g, '').replace(/&lt;br \/&gt;/g, '<br />')
    return sanitizedText.replace(/etiquetas.*/g, '').replace(/&#187;&nbsp;autor.*/g, '')
}

function getDate(text) {
    var date = new Date(text)
    return date
}
