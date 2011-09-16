import QtQuick 1.1

XmlListModel {

    namespaceDeclarations: 'declare namespace dc = "http://purl.org/dc/elements/1.1/";' +
                           'declare namespace wfw = "http://wellformedweb.org/CommentAPI/";' +
                           'declare namespace meneame = "http://meneame.net/faq-es.php";'
    source: ''
    query: '/rss/channel/item'

    XmlRole { name: 'mnm_link_id'; query: 'meneame:link_id/string()' }
    XmlRole { name: 'mnm_user'; query: 'meneame:user/string()' }
    XmlRole { name: 'mnm_votes'; query: 'meneame:votes/number()' }
    XmlRole { name: 'mnm_negatives'; query: 'meneame:negatives/number()' }
    XmlRole { name: 'mnm_karma'; query: 'meneame:karma/number()' }
    XmlRole { name: 'mnm_comments'; query: 'meneame:comments/number()' }
    XmlRole { name: 'mnm_url'; query: 'meneame:url/string()' }
    XmlRole { name: 'title'; query: 'title/string()' }
    XmlRole { name: 'link'; query: 'link/string()' }
    XmlRole { name: 'comments'; query: 'comments/string()' }
    XmlRole { name: 'pubDate'; query: 'pubDate/string()'; isKey: true }
    XmlRole { name: 'dc_creator'; query: 'dc:creator/string()' }

    // Categories are ignored at the moment

    XmlRole { name: 'guid'; query: 'guid/string()' }
    XmlRole { name: 'description'; query: 'description/string()' }
    XmlRole { name: 'wfw_commentRss'; query: 'wfw:commentRss/string()' }
}
