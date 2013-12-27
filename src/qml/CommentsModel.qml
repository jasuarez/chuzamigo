/**************************************************************************
 *   Chuzamigo 
 *   Copyright (C) 2013 Juan A. Suarez Romero <jasuarez@igalia.com>
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

import QtQuick 1.1

XmlListModel {

    namespaceDeclarations: 'declare namespace dc = "http://purl.org/dc/elements/1.1/";' +
                           'declare namespace wfw = "http://wellformedweb.org/CommentAPI/";' +
                           'declare namespace chuza = "http://chuza.gl/faq-es.php";'
    source: ''
    query: '/rss/channel/item'

    XmlRole { name: 'mnm_comment_id'; query: 'chuza:comment_id/string()' }
    XmlRole { name: 'mnm_link_id'; query: 'chuza:link_id/string()' }
    XmlRole { name: 'mnm_order'; query: 'chuza:order/number()' }
    XmlRole { name: 'mnm_user'; query: 'chuza:user/string()' }
    XmlRole { name: 'mnm_votes'; query: 'chuza:votes/number()' }
    XmlRole { name: 'mnm_karma'; query: 'chuza:karma/number()' }
    XmlRole { name: 'mnm_url'; query: 'chuza:url/string()' }
    XmlRole { name: 'title'; query: 'title/string()' }
    XmlRole { name: 'link'; query: 'link/string()' }
    XmlRole { name: 'pubDate'; query: 'pubDate/string()'; isKey: true }
    XmlRole { name: 'dc_creator'; query: 'dc_creator/string()' }
    XmlRole { name: 'guid'; query: 'guid/string()' }
    XmlRole { name: 'description'; query: 'description/string()' }
}
