/**************************************************************************
 *    Meneamigo
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
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

.pragma library

var RSS_PUBLISHED = 'http://www.meneame.net/rss2.php?status=published&nohtml'
var RSS_PENDING = 'http://www.meneame.net/rss2.php?status=queued&nohtml'
var RSS_COMMENTS = 'http://www.meneame.net/comments_rss2.php?nohtml&id='
var ANON_VOTING_URL = 'http://meneame.net/backend/menealo.php'
var ANONYMOUS_USER_ID = 0
var BASE_URL = 'http://m.meneame.net'
var REFRESH_HEADER_TIMEOUT = 3000
var METHOD_AUTH = 'auth'
var METHOD_VOTE = 'vote'
var VOTE_AVAILABLE = 0
var VOTE_WAITING = 1
var VOTE_DONE = 2
var VOTE_ERROR = 3

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

function cleanUpComments(text) {
    return text.replace(/&#187;&nbsp;autor.*/g, '').replace(/http:\/\/mnmstatic.net\/img\/smileys\//g, '\/img\/smileys\/')
}

function startsWith(text, str) {
    return (text.match('^' + str) == str)
}

function getAnonymousVotingURL(sessionKey, linkId) {
    return ANON_VOTING_URL + '?id=' + linkId +
            '&user=' + ANONYMOUS_USER_ID +
            '&key=' + sessionKey +
            '&l=' + linkId +
            '&u=' + BASE_URL
}
