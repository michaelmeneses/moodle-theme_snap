/**
 * This file is part of Moodle - http://moodle.org/
 *
 * Moodle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Moodle is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Moodle.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @package   theme_snap
 * @author    Juan Ibarra juan.ibarra@blackboard.com
 * @copyright Copyright (c) 2019 Blackboard Inc. (http://www.blackboard.com)
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * JS code to manage hide/show of full width messages drawer.
 */
define(['jquery'],
    function($) {
        // Array to control which popovers are open.
        var openedpopovers = [];
        // Maximum size in pixels to consider a mobile screen
        var maxWidth = 560;

        var getParam = function(name){
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regexS = "[\\?&]" + name + "=([^&#]*)";
            var regex = new RegExp(regexS);
            var results = regex.exec(window.location.href);
            if (results === null) {
                return "";
            }
            else {
                return results[1];
            }
        };

        return {
            init: function(userId) {
                // Listener for the admin block.
                var messageUserId = getParam('id');
                if (!messageUserId || userId === messageUserId) {
                    document.addEventListener("messages-drawer:toggle", function () {
                        if ($('#page-message-edit').length || $('#page-message-index').length) {
                            if ($('.block_settings').hasClass('state-visible') ||
                                $('.block_settings').hasClass('state-visible')) {
                                if ($(window).width() < maxWidth) {
                                    $('.message-drawer').hide();
                                } else {
                                    $('.message-drawer').animate({width: '50%'}, 0);
                                }
                            } else {
                                if ($(window).width() < maxWidth) {
                                    $('.message-drawer').show();
                                } else {
                                    $('.message-drawer').animate({width: '100%'}, 0);
                                }
                            }
                        }
                    });
                    // Listener for the personal menu.
                    document.addEventListener("messages-drawer:pm-toggle", function () {
                        if ($('#page-message-edit').length || $('#page-message-index').length) {
                            if ($('.snap-pm-open').length) {
                                $('.message-drawer').hide();
                            } else {
                                $('.message-drawer').show();
                            }
                        }
                    });
                    // Listeners for popovers.
                    var popover = $('div.popover-region');
                    popover.on('popoverregion:menuopened', function () {
                        if ($('#page-message-edit').length || $('#page-message-index').length) {
                            var popovername = $(this).attr("id");
                            if (openedpopovers.indexOf(popovername) == -1) {
                                openedpopovers.push(popovername);
                            }
                            // If there are open popovers, hide message-drawer.
                            if (openedpopovers.length > 0) {
                                if ($(window).width() < maxWidth) {
                                    $('.message-drawer').hide();
                                } else {
                                    $('.message-drawer').animate({width: '50%'}, 0);
                                }
                            }
                        }
                    }).bind();
                    popover.on('popoverregion:menuclosed', function () {
                        if ($('#page-message-edit').length || $('#page-message-index').length) {
                            var popovername = $(this).attr("id");
                            var index = openedpopovers.indexOf(popovername);
                            openedpopovers.splice(index, 1);
                            // Only open drawer when there are no opened popovers.
                            if (openedpopovers.length == 0) {
                                if ($(window).width() < maxWidth) {
                                    $('.message-drawer').show();
                                } else {
                                    $('.message-drawer').animate({width: '100%'}, 0);
                                }
                            }
                        }
                    }).bind();
                } else {
                    $('.message-drawer').hide();
                    $('#page-message-edit').css('overflow', 'auto');
                }
            }
        };
    }
);
