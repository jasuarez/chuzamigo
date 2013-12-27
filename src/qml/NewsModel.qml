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
