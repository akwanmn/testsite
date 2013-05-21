/* ============================================================
 * bootstrap-dropdown.js v2.0.4
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(o){"use strict";function t(){o(n).parent().removeClass("open")}var n='[data-toggle="dropdown"]',a=function(t){var n=o(t).on("click.dropdown.data-api",this.toggle);o("html").on("click.dropdown.data-api",function(){n.parent().removeClass("open")})};a.prototype={constructor:a,toggle:function(){var n,a,r,d=o(this);if(!d.is(".disabled, :disabled"))return a=d.attr("data-target"),a||(a=d.attr("href"),a=a&&a.replace(/.*(?=#[^\s]*$)/,"")),n=o(a),n.length||(n=d.parent()),r=n.hasClass("open"),t(),r||n.toggleClass("open"),!1}},o.fn.dropdown=function(t){return this.each(function(){var n=o(this),r=n.data("dropdown");r||n.data("dropdown",r=new a(this)),"string"==typeof t&&r[t].call(n)})},o.fn.dropdown.Constructor=a,o(function(){o("html").on("click.dropdown.data-api",t),o("body").on("click.dropdown",".dropdown form",function(o){o.stopPropagation()}).on("click.dropdown.data-api",n,a.prototype.toggle)})}(window.jQuery);