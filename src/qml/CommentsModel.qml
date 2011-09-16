import QtQuick 1.1

XmlListModel {

    namespaceDeclarations: 'declare namespace dc = "http://purl.org/dc/elements/1.1/";' +
                           'declare namespace wfw = "http://wellformedweb.org/CommentAPI/";' +
                           'declare namespace meneame = "http://meneame.net/faq-es.php";'
    source: ''
    query: '/rss/channel/item'

    XmlRole { name: 'mnm_comment_id'; query: 'meneame:comment_id/string()' }
    XmlRole { name: 'mnm_link_id'; query: 'meneame:link_id/string()' }
    XmlRole { name: 'mnm_order'; query: 'meneame:order/number()' }
    XmlRole { name: 'mnm_user'; query: 'meneame:user/string()' }
    XmlRole { name: 'mnm_votes'; query: 'meneame:votes/number()' }
    XmlRole { name: 'mnm_karma'; query: 'meneame:karma/number()' }
    XmlRole { name: 'mnm_url'; query: 'meneame:url/string()' }
    XmlRole { name: 'title'; query: 'title/string()' }
    XmlRole { name: 'link'; query: 'link/string()' }
    XmlRole { name: 'pubDate'; query: 'pubDate/string()'; isKey: true }
    XmlRole { name: 'dc_creator'; query: 'dc_creator/string()' }
    XmlRole { name: 'guid'; query: 'guid/string()' }
    XmlRole { name: 'description'; query: 'description/string()' }
}
