(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["common"],{"0580":function(t,e){var n=["input","select","textarea","a[href]","button","[tabindex]","audio[controls]","video[controls]",'[contenteditable]:not([contenteditable="false"])'],a=n.join(","),r="undefined"===typeof Element?function(){}:Element.prototype.matches||Element.prototype.msMatchesSelector||Element.prototype.webkitMatchesSelector;function i(t,e){e=e||{};var n,i,s,l=[],u=[],c=t.querySelectorAll(a);for(e.includeContainer&&r.call(t,a)&&(c=Array.prototype.slice.apply(c),c.unshift(t)),n=0;n<c.length;n++)i=c[n],o(i)&&(s=d(i),0===s?l.push(i):u.push({documentOrder:n,tabIndex:s,node:i}));var p=u.sort(f).map((function(t){return t.node})).concat(l);return p}function o(t){return!(!l(t)||b(t)||d(t)<0)}function s(t){if(!t)throw new Error("No node provided");return!1!==r.call(t,a)&&o(t)}function l(t){return!(t.disabled||v(t)||_(t))}i.isTabbable=s,i.isFocusable=c;var u=n.concat("iframe").join(",");function c(t){if(!t)throw new Error("No node provided");return!1!==r.call(t,u)&&l(t)}function d(t){var e=parseInt(t.getAttribute("tabindex"),10);return isNaN(e)?p(t)?0:t.tabIndex:e}function f(t,e){return t.tabIndex===e.tabIndex?t.documentOrder-e.documentOrder:t.tabIndex-e.tabIndex}function p(t){return"true"===t.contentEditable}function h(t){return"INPUT"===t.tagName}function v(t){return h(t)&&"hidden"===t.type}function m(t){return h(t)&&"radio"===t.type}function b(t){return m(t)&&!w(t)}function g(t){for(var e=0;e<t.length;e++)if(t[e].checked)return t[e]}function w(t){if(!t.name)return!0;var e=t.ownerDocument.querySelectorAll('input[type="radio"][name="'+t.name+'"]'),n=g(e);return!n||n===t}function _(t){return null===t.offsetParent||"hidden"===getComputedStyle(t).visibility}t.exports=i},"0daa":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("router-link",{attrs:{to:t.url,title:t.actor.full_username}},[t.avatar?[n("actor-avatar",{attrs:{actor:t.actor}}),n("span")]:t._e(),t._t("default",[t._v(t._s(t._f("truncate")(t.repr,t.truncateLength)))])],2)},r=[],i=(n("a9e3"),n("5e9f"),{props:{actor:{type:Object},avatar:{type:Boolean,default:!0},admin:{type:Boolean,default:!1},displayName:{type:Boolean,default:!1},truncateLength:{type:Number,default:30}},computed:{url:function(){return this.admin?{name:"manage.moderation.accounts.detail",params:{id:this.actor.full_username}}:this.actor.is_local?{name:"profile.overview",params:{username:this.actor.preferred_username}}:{name:"profile.full.overview",params:{username:this.actor.preferred_username,domain:this.actor.domain}}},repr:function(){return this.displayName||this.actor.is_local?this.actor.preferred_username:this.actor.full_username}}}),o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},"0f6a":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("form",{staticClass:"ui inline form",on:{submit:function(e){return e.stopPropagation(),e.preventDefault(),t.$emit("search",t.value)}}},[n("div",{class:["ui","action",{icon:t.isClearable},"input"]},[n("label",{staticClass:"hidden",attrs:{for:"search-query"}},[n("translate",{attrs:{"translate-context":"Content/Search/Input.Label/Noun"}},[t._v("Search")])],1),n("input",{attrs:{id:"search-query",name:"search-query",type:"text",placeholder:t.placeholder||t.labels.searchPlaceholder},domProps:{value:t.value},on:{input:function(e){return t.$emit("input",e.target.value)}}}),t.isClearable?n("i",{staticClass:"x link icon",attrs:{title:t.labels.clear},on:{click:function(e){e.stopPropagation(),e.preventDefault(),t.$emit("input",""),t.$emit("search",t.value)}}}):t._e(),t._m(0)])])},r=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("button",{staticClass:"ui icon basic button",attrs:{type:"submit"}},[n("i",{staticClass:"search icon"})])}],i={props:{value:{type:String,required:!0},placeholder:{type:String,required:!1}},computed:{labels:function(){return{searchPlaceholder:this.$pgettext("Content/Search/Input.Placeholder","Search…"),clear:this.$pgettext("Content/Library/Button.Label","Clear")}},isClearable:function(){return!!this.value}}},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},"1d39":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"ui fluid action input component-copy-input"},[t.copied?n("p",{staticClass:"message"},[n("translate",{attrs:{"translate-context":"Content/*/Paragraph"}},[t._v("Text copied to clipboard!")])],1):t._e(),n("input",{ref:"input",attrs:{id:t.id,name:t.id,type:"text",readonly:""},domProps:{value:t.value}}),n("button",{class:["ui",t.buttonClasses,"right","labeled","icon","button"],on:{click:t.copy}},[n("i",{staticClass:"copy icon"}),n("translate",{attrs:{"translate-context":"*/*/Button.Label/Short, Verb"}},[t._v("Copy")])],1)])},r=[],i={props:{value:{type:String},buttonClasses:{type:String,default:"accent"},id:{type:String,default:"copy-input"}},data:function(){return{copied:!1,timeout:null}},methods:{copy:function(){this.timeout&&clearTimeout(this.timeout),this.$refs.input.select(),document.execCommand("Copy");var t=this;t.copied=!0,this.timeout=setTimeout((function(){t.copied=!1}),5e3)}}},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},"27b3":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("button",{class:["ui",{loading:t.isLoading},"button"],on:{click:t.ajaxCall}},[t._t("default")],2)},r=[],i=n("bc3a"),o=n.n(i),s={props:{url:{type:String,required:!0},method:{type:String,required:!0}},data:function(){return{isLoading:!1}},methods:{ajaxCall:function(){var t=this;this.isLoading=!0,o.a[this.method](this.url).then((function(e){t.$emit("action-done",e.data),t.isLoading=!1}),(function(e){t.isLoading=!1,t.$emit("action-error",e)}))}}},l=s,u=n("2877"),c=Object(u["a"])(l,a,r,!1,null,null,null);e["default"]=c.exports},"2e46":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("time",{attrs:{datetime:t.duration+"s"}},[t._v(" "+t._s(t._f("duration")(t.duration))+" ")])},r=[],i={props:{duration:{required:!0}}},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},"404d":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{class:["ui",{active:t.show},{"overlay fullscreen":t.fullscreen&&["phone","tablet"].indexOf(t.$store.getters["ui/windowSize"])>-1},"modal"]},[n("i",{staticClass:"close inside icon"}),t.show?t._t("default"):t._e()],2)},r=[],i=n("1157"),o=n.n(i),s=n("6c92"),l=n.n(s),u={props:{show:{type:Boolean,required:!0},fullscreen:{type:Boolean,default:!0}},data:function(){return{control:null,focusTrap:null}},mounted:function(){this.focusTrap=l()(this.$el)},beforeDestroy:function(){this.control&&o()(this.$el).modal("hide"),o()(this.$el).remove()},methods:{initModal:function(){this.control=o()(this.$el).modal({duration:100,onApprove:function(){this.$emit("approved")}.bind(this),onDeny:function(){this.$emit("deny")}.bind(this),onHidden:function(){this.$emit("update:show",!1)}.bind(this),onVisible:function(){this.focusTrap.activate(),this.focusTrap.unpause()}.bind(this)})}},watch:{show:{handler:function(t){t?(this.initModal(),this.$emit("show"),this.control.modal("show"),this.focusTrap.activate(),this.focusTrap.unpause()):this.control&&(this.$emit("hide"),this.control.modal("hide"),this.control.remove(),this.focusTrap.deactivate(),this.focusTrap.pause())}}}},c=u,d=n("2877"),f=Object(d["a"])(c,a,r,!1,null,null,null);e["default"]=f.exports},"42d1":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("button",{class:[{disabled:t.disabled}],attrs:{disabled:t.disabled},on:{click:function(e){t.showModal=!0}}},[t._t("default"),n("modal",{staticClass:"small",attrs:{show:t.showModal},on:{"update:show":function(e){t.showModal=e}}},[n("h4",{staticClass:"header"},[t._t("modal-header",[n("translate",{attrs:{"translate-context":"Modal/*/Title"}},[t._v("Do you want to confirm this action?")])])],2),n("div",{staticClass:"scrolling content"},[n("div",{staticClass:"description"},[t._t("modal-content")],2)]),n("div",{staticClass:"actions"},[n("button",{staticClass:"ui basic cancel button"},[n("translate",{attrs:{"translate-context":"*/*/Button.Label/Verb"}},[t._v("Cancel")])],1),n("button",{class:["ui","confirm",t.confirmButtonColor,"button"],on:{click:t.confirm}},[t._t("modal-confirm",[n("translate",{attrs:{"translate-context":"Modal/*/Button.Label/Short, Verb"}},[t._v("Confirm")])])],2)])])],2)},r=[],i=n("404d"),o={props:{action:{type:Function,required:!1},disabled:{type:Boolean,default:!1},confirmColor:{type:String,default:"danger",required:!1}},components:{Modal:i["default"]},data:function(){return{showModal:!1}},computed:{confirmButtonColor:function(){return this.confirmColor?this.confirmColor:this.color}},methods:{confirm:function(){this.showModal=!1,this.$emit("confirm"),this.action&&this.action()}}},s=o,l=n("2877"),u=Object(l["a"])(s,a,r,!1,null,null,null);e["default"]=u.exports},"53a8":function(t,e){t.exports=a;var n=Object.prototype.hasOwnProperty;function a(){for(var t={},e=0;e<arguments.length;e++){var a=arguments[e];for(var r in a)n.call(a,r)&&(t[r]=a[r])}return t}},"5e9f":function(t,e,n){"use strict";n.d(e,"a",(function(){return a})),n.d(e,"b",(function(){return r}));n("d3b7"),n("25f0");function a(t){for(var e=0,n=0;n<t.length;n++)e=t.charCodeAt(n)+((e<<5)-e);return e}function r(t){var e=(16777215&t).toString(16).toUpperCase();return"00000".substring(0,6-e.length)+e}},"6c92":function(t,e,n){var a,r=n("0580"),i=n("53a8"),o=function(){var t=[];return{activateTrap:function(e){if(t.length>0){var n=t[t.length-1];n!==e&&n.pause()}var a=t.indexOf(e);-1===a||t.splice(a,1),t.push(e)},deactivateTrap:function(e){var n=t.indexOf(e);-1!==n&&t.splice(n,1),t.length>0&&t[t.length-1].unpause()}}}();function s(t,e){var n=document,s="string"===typeof t?n.querySelector(t):t,f=i({returnFocusOnDeactivate:!0,escapeDeactivates:!0},e),p={firstTabbableNode:null,lastTabbableNode:null,nodeFocusedBeforeActivation:null,mostRecentlyFocusedNode:null,active:!1,paused:!1},h={activate:v,deactivate:m,pause:b,unpause:g};return h;function v(t){if(!p.active){$(),p.active=!0,p.paused=!1,p.nodeFocusedBeforeActivation=n.activeElement;var e=t&&t.onActivate?t.onActivate:f.onActivate;return e&&e(),w(),h}}function m(t){if(p.active){clearTimeout(a),_(),p.active=!1,p.paused=!1,o.deactivateTrap(h);var e=t&&void 0!==t.onDeactivate?t.onDeactivate:f.onDeactivate;e&&e();var n=t&&void 0!==t.returnFocus?t.returnFocus:f.returnFocusOnDeactivate;return n&&d((function(){A(y(p.nodeFocusedBeforeActivation))})),h}}function b(){!p.paused&&p.active&&(p.paused=!0,_())}function g(){p.paused&&p.active&&(p.paused=!1,$(),w())}function w(){if(p.active)return o.activateTrap(h),a=d((function(){A(x())})),n.addEventListener("focusin",E,!0),n.addEventListener("mousedown",k,{capture:!0,passive:!1}),n.addEventListener("touchstart",k,{capture:!0,passive:!1}),n.addEventListener("click",T,{capture:!0,passive:!1}),n.addEventListener("keydown",L,{capture:!0,passive:!1}),h}function _(){if(p.active)return n.removeEventListener("focusin",E,!0),n.removeEventListener("mousedown",k,!0),n.removeEventListener("touchstart",k,!0),n.removeEventListener("click",T,!0),n.removeEventListener("keydown",L,!0),h}function C(t){var e=f[t],a=e;if(!e)return null;if("string"===typeof e&&(a=n.querySelector(e),!a))throw new Error("`"+t+"` refers to no known node");if("function"===typeof e&&(a=e(),!a))throw new Error("`"+t+"` did not return a node");return a}function x(){var t;if(t=null!==C("initialFocus")?C("initialFocus"):s.contains(n.activeElement)?n.activeElement:p.firstTabbableNode||C("fallbackFocus"),!t)throw new Error("Your focus-trap needs to have at least one focusable element");return t}function y(t){var e=C("setReturnFocus");return e||t}function k(t){s.contains(t.target)||(f.clickOutsideDeactivates?m({returnFocus:!r.isFocusable(t.target)}):f.allowOutsideClick&&f.allowOutsideClick(t)||t.preventDefault())}function E(t){s.contains(t.target)||t.target instanceof Document||(t.stopImmediatePropagation(),A(p.mostRecentlyFocusedNode||x()))}function L(t){if(!1!==f.escapeDeactivates&&u(t))return t.preventDefault(),void m();c(t)&&O(t)}function O(t){return $(),t.shiftKey&&t.target===p.firstTabbableNode?(t.preventDefault(),void A(p.lastTabbableNode)):t.shiftKey||t.target!==p.lastTabbableNode?void 0:(t.preventDefault(),void A(p.firstTabbableNode))}function T(t){f.clickOutsideDeactivates||s.contains(t.target)||f.allowOutsideClick&&f.allowOutsideClick(t)||(t.preventDefault(),t.stopImmediatePropagation())}function $(){var t=r(s);p.firstTabbableNode=t[0]||x(),p.lastTabbableNode=t[t.length-1]||x()}function A(t){t!==n.activeElement&&(t&&t.focus?(t.focus(),p.mostRecentlyFocusedNode=t,l(t)&&t.select()):A(x()))}}function l(t){return t.tagName&&"input"===t.tagName.toLowerCase()&&"function"===typeof t.select}function u(t){return"Escape"===t.key||"Esc"===t.key||27===t.keyCode}function c(t){return"Tab"===t.key||9===t.keyCode}function d(t){return setTimeout(t,0)}t.exports=s},7156:function(t,e,n){var a=n("861d"),r=n("d2bb");t.exports=function(t,e,n){var i,o;return r&&"function"==typeof(i=e.constructor)&&i!==n&&a(o=i.prototype)&&o!==n.prototype&&r(t,o),t}},"7c10":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("span",{staticClass:"tooltip",attrs:{"data-tooltip":t.content}},[n("i",{staticClass:"question circle icon"})])},r=[],i={props:{content:{type:String,required:!0}}},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},"911c":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return t.actor.icon&&t.actor.icon.urls.original?n("img",{staticClass:"ui avatar circular image",attrs:{alt:"",src:t.actor.icon.urls.medium_square_crop}}):n("span",{staticClass:"ui avatar circular label",style:t.defaultAvatarStyle},[t._v(t._s(t.actor.preferred_username[0]))])},r=[],i=n("5e9f"),o={props:["actor"],computed:{actorColor:function(){return Object(i["b"])(Object(i["a"])(this.actor.full_username))},defaultAvatarStyle:function(){return{"background-color":"#".concat(this.actorColor)}}}},s=o,l=n("2877"),u=Object(l["a"])(s,a,r,!1,null,null,null);e["default"]=u.exports},9435:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("span",[t.durationData.hours>0?n("translate",{attrs:{"translate-context":"Content/*/Paragraph","translate-params":{minutes:t.durationData.minutes,hours:t.durationData.hours}}},[t._v("%{ hours } h %{ minutes } min")]):n("translate",{attrs:{"translate-context":"Content/*/Paragraph","translate-params":{minutes:t.durationData.minutes}}},[t._v("%{ minutes } min")])],1)},r=[],i=n("98fc"),o={props:["seconds"],computed:{durationData:function(){return Object(i["c"])(this.seconds)}}},s=o,l=n("2877"),u=Object(l["a"])(s,a,r,!1,null,null,null);e["default"]=u.exports},a4a4:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("a",{staticClass:"collapse link",attrs:{role:"button"},on:{click:function(e){return e.preventDefault(),t.$emit("input",!t.value)}}},[t.isCollapsed?n("translate",{key:"1",attrs:{"translate-context":"*/*/Button,Label"}},[t._v("Expand")]):n("translate",{key:"2",attrs:{"translate-context":"*/*/Button,Label"}},[t._v("Collapse")]),n("i",{class:[{down:!t.isCollapsed},{right:t.isCollapsed},"angle","icon"]})],1)},r=[],i={props:{value:{type:Boolean,required:!0}},computed:{isCollapsed:function(){return this.value}}},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},a9e3:function(t,e,n){"use strict";var a=n("83ab"),r=n("da84"),i=n("94ca"),o=n("6eeb"),s=n("5135"),l=n("c6b6"),u=n("7156"),c=n("c04e"),d=n("d039"),f=n("7c73"),p=n("241c").f,h=n("06cf").f,v=n("9bf2").f,m=n("58a8").trim,b="Number",g=r[b],w=g.prototype,_=l(f(w))==b,C=function(t){var e,n,a,r,i,o,s,l,u=c(t,!1);if("string"==typeof u&&u.length>2)if(u=m(u),e=u.charCodeAt(0),43===e||45===e){if(n=u.charCodeAt(2),88===n||120===n)return NaN}else if(48===e){switch(u.charCodeAt(1)){case 66:case 98:a=2,r=49;break;case 79:case 111:a=8,r=55;break;default:return+u}for(i=u.slice(2),o=i.length,s=0;s<o;s++)if(l=i.charCodeAt(s),l<48||l>r)return NaN;return parseInt(i,a)}return+u};if(i(b,!g(" 0o1")||!g("0b1")||g("+0x1"))){for(var x,y=function(t){var e=arguments.length<1?0:t,n=this;return n instanceof y&&(_?d((function(){w.valueOf.call(n)})):l(n)!=b)?u(new g(C(e)),n,y):C(e)},k=a?p(g):"MAX_VALUE,MIN_VALUE,NaN,NEGATIVE_INFINITY,POSITIVE_INFINITY,EPSILON,isFinite,isInteger,isNaN,isSafeInteger,MAX_SAFE_INTEGER,MIN_SAFE_INTEGER,parseFloat,parseInt,isInteger".split(","),E=0;k.length>E;E++)s(g,x=k[E])&&!s(y,x)&&v(y,x,h(g,x));y.prototype=w,w.constructor=y,o(r,b,y)}},adfd:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("span",[t._v(t._s(t.username))])},r=[],i={props:["username"]},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},b6e7:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return t.isLoading||t.isDone?n("span",{staticClass:"feedback"},[t.isLoading?n("span",{class:["ui","active",t.size,"inline","loader"]}):t._e(),t.isDone?n("i",{class:["success",t.size,"check","icon"]}):t._e()]):t._e()},r=[],i=(n("5e9f"),{props:{isLoading:{type:Boolean,required:!0},size:{type:String,default:"small"}},data:function(){return{timer:null,isDone:!1}},destroyed:function(){this.timer&&clearTimeout(this.timer)},watch:{isLoading:function(t){var e=this;t&&this.timer&&clearTimeout(this.timer),t?this.isDone=!1:(this.isDone=!0,this.timer=setTimeout((function(){e.isDone=!1}),2e3))}}}),o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},b7e8:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",[t.content&&!t.isUpdating?[n("div",{domProps:{innerHTML:t._s(t.html)}}),t.isTruncated?[n("div",{staticClass:"ui small hidden divider"}),!1===t.showMore?n("a",{attrs:{href:""},on:{click:function(e){e.stopPropagation(),e.preventDefault(),t.showMore=!0}}},[n("translate",{attrs:{"translate-context":"*/*/Button,Label"}},[t._v("Show more")])],1):n("a",{attrs:{href:""},on:{click:function(e){e.stopPropagation(),e.preventDefault(),t.showMore=!1}}},[n("translate",{attrs:{"translate-context":"*/*/Button,Label"}},[t._v("Show less")])],1)]:t._e()]:t.isUpdating?t._e():n("p",[n("translate",{attrs:{"translate-context":"*/*/Placeholder"}},[t._v("No description available")])],1),!t.isUpdating&&t.canUpdate&&t.updateUrl?[n("div",{staticClass:"ui hidden divider"}),n("span",{attrs:{role:"button"},on:{click:function(e){t.isUpdating=!0}}},[n("i",{staticClass:"pencil icon"}),n("translate",{attrs:{"translate-context":"Content/*/Button.Label/Verb"}},[t._v("Edit")])],1)]:t._e(),t.isUpdating?n("form",{staticClass:"ui form",on:{submit:function(e){return e.preventDefault(),t.submit()}}},[t.errors.length>0?n("div",{staticClass:"ui negative message",attrs:{role:"alert"}},[n("h4",{staticClass:"header"},[n("translate",{attrs:{"translate-context":"Content/Channels/Error message.Title"}},[t._v("Error while updating description")])],1),n("ul",{staticClass:"list"},t._l(t.errors,(function(e){return n("li",[t._v(t._s(e))])})),0)]):t._e(),n("content-form",{attrs:{autofocus:!0},model:{value:t.newText,callback:function(e){t.newText=e},expression:"newText"}}),n("a",{staticClass:"left floated",on:{click:function(e){e.preventDefault(),t.isUpdating=!1}}},[n("translate",{attrs:{"translate-context":"*/*/Button.Label/Verb"}},[t._v("Cancel")])],1),n("button",{class:["ui",{loading:t.isLoading},"right","floated","button"],attrs:{type:"submit",disabled:t.isLoading}},[n("translate",{attrs:{"translate-context":"Content/Channels/Button.Label/Verb"}},[t._v("Update description")])],1),n("div",{staticClass:"ui clearing hidden divider"})],1):t._e()],2)},r=[],i=(n("a9e3"),n("96cf"),n("1da1")),o=n("ade3"),s=(n("98fc"),n("bc3a")),l=n.n(s),u=n("bf6d"),c=n.n(u),d={props:{content:{required:!0},fieldName:{required:!1,default:"description"},updateUrl:{required:!1,type:String},canUpdate:{required:!1,default:!0,type:Boolean},fetchHtml:{required:!1,default:!1,type:Boolean},permissive:{required:!1,default:!1,type:Boolean},truncateLength:{required:!1,default:500,type:Number}},data:function(){var t;return t={isUpdating:!1,showMore:!1,newText:(this.content||{text:""}).text,errors:null,isLoading:!1},Object(o["a"])(t,"errors",[]),Object(o["a"])(t,"preview",null),t},created:function(){var t=this;return Object(i["a"])(regeneratorRuntime.mark((function e(){return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:if(!t.fetchHtml){e.next=3;break}return e.next=3,t.fetchPreview();case 3:case"end":return e.stop()}}),e)})))()},computed:{html:function(){return this.fetchHtml?this.preview:this.truncateLength>0&&!this.showMore?this.truncatedHtml:this.content.html},truncatedHtml:function(){return c()(this.content.html,this.truncateLength,{html:!0,maxLines:3})},isTruncated:function(){return this.truncateLength>0&&this.truncatedHtml.length<this.content.html.length}},methods:{fetchPreview:function(){var t=this;return Object(i["a"])(regeneratorRuntime.mark((function e(){var n;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,l.a.post("text-preview/",{text:t.content.text,permissive:t.permissive});case 2:n=e.sent,t.preview=n.data.rendered;case 4:case"end":return e.stop()}}),e)})))()},submit:function(){var t=this;this.isLoading=!0,this.errors=[];var e={};e[this.fieldName]=null,this.newText&&(e[this.fieldName]={content_type:"text/markdown",text:this.newText}),l.a.patch(this.updateUrl,e).then((function(e){t.$emit("updated",e.data),t.isLoading=!1,t.isUpdating=!1}),(function(e){t.errors=e.backendErrors,t.isLoading=!1}))}}},f=d,p=n("2877"),h=Object(p["a"])(f,a,r,!1,null,null,null);e["default"]=h.exports},bf6d:function(t,e,n){"use strict";var a=["area","base","br","col","command","embed","hr","img","input","keygen","link","meta","param","source","track","wbr"],r=["address","article","aside","blockquote","canvas","dd","div","dl","dt","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","header","hgroup","hr","li","main","nav","noscript","ol","output","p","pre","section","table","tfoot","ul","video"],i=10,o=33,s=34,l=38,u=39,c=47,d=59,f=60,p=61,h=62,v=/[<&\n\ud800-\udbff]/,m=/\s+$/;function b(t,e,n){for(var b=n.imageWeight,g=void 0===b?2:b,y=n.indicator,E=n.maxLines,L=y.length,O=1,T=0,$=!1,A=[],N=t.length;T<N;T++){var S=T?t.slice(T):t,P=S.search(v),D=P>-1?P:S.length;if(T+=D,!$&&(L+=D,L>e)){T=Math.max(T-L+e,0);break}if(-1===P)break;var j=t.charCodeAt(T);if(j===f){var q=t.charCodeAt(T+1),I=q===o;if(I&&"--"===t.substr(T+2,2)){var B=t.indexOf("--\x3e",T+4)+3;T=B-1}else if(I&&"[CDATA["===t.substr(T+2,7)){var M=t.indexOf("]]>",T+9)+3;T=M-1}else{if(L===e&&t.charCodeAt(T+1)!==c){L++;break}var F=0,U=T,V=!1;while(1){if(U++,U>=N)throw new Error("Invalid HTML: "+t);var R=t.charCodeAt(U);if(V)F?R===F&&(V=!1):x(R)?V=!1:R===h&&(V=!1,U--);else if(R===p){while(x(t.charCodeAt(U+1)))U++;V=!0;var H=t.charCodeAt(U+1);H===s||H===u?(F=H,U++):F=0}else if(R===h){var z=t.charCodeAt(T+1)===c,W=T+(z?2:1),G=Math.min(w(t,W),U),Y=t.slice(W,G).toLowerCase();if(Y.charCodeAt(Y.length-1)===c&&(Y=Y.slice(0,Y.length-1)),z){var J=A.pop();if(J!==Y)throw new Error("Invalid HTML: "+t);if(("math"===Y||"svg"===Y)&&($=-1!==A.indexOf("math")||-1!==A.indexOf("svg"),!$&&(L+=g,L>e)))break;if(-1!==r.indexOf(Y)&&!$&&(O++,O>E)){A.push(Y);break}}else if(-1!==a.indexOf(Y)||t.charCodeAt(U-1)===c){if("br"===Y){if(O++,O>E)break}else if("img"===Y&&(L+=g,L>e))break}else A.push(Y),"math"!==Y&&"svg"!==Y||($=!0);T=U;break}}if(L>e||O>E)break}}else if(j===l){var K=T+1,X=!0;while(1){var Q=t.charCodeAt(K);if(!_(Q)){if(Q===d)break;X=!1;break}K++}if(!$&&(L++,L>e))break;X&&(T=K)}else if(j===i){if(!$){if(L++,L>e)break;if(O++,O>E)break}}else{if(!$&&(L++,L>e))break;var Z=t.charCodeAt(T+1);56320===(64512&Z)&&T++}}if(L>e){var tt=k(t,T);if(y){var et=T+tt.length;while(t.charCodeAt(et)===f&&t.charCodeAt(et+1)===c){var nt=t.indexOf(">",et+2)+1;if(!nt)break;et=nt}et&&(et===t.length||C(t,et))&&(T+=tt.length,tt=t.charAt(T))}while("<"===tt&&t.charCodeAt(T+1)===c){var at=A.pop(),rt=at?t.indexOf(">",T+2):-1;if(-1===rt||t.replace(m,"").slice(T+2,rt)!==at)throw new Error("Invalid HTML: "+t);T=rt+1,tt=t.charAt(T)}if(T<t.length){if(!n.breakWords)for(var it=T-y.length;it>=0;it--){var ot=t.charCodeAt(it);if(ot===h||ot===d)break;if(ot===i||ot===f){T=it;break}if(x(ot)){T=it+(y?1:0);break}}var st=t.slice(0,T)+(C(t,T)?"":y);while(A.length){var lt=A.pop();st+="</"+lt+">"}return st}}else if(O>E){var ut=t.slice(0,T);while(A.length){var ct=A.pop();ut+="</"+ct+">"}return ut}return t}function g(t,e,n){for(var a=n.indicator,r=n.maxLines,o=a.length,s=1,l=0,u=t.length;l<u;l++){if(o++,o>e)break;var c=t.charCodeAt(l);if(c===i){if(s++,s>r)break}else if(55296===(64512&c)){var d=t.charCodeAt(l+1);56320===(64512&d)&&l++}}if(o>e){var f=y(t,l);if(a){var p=l+f.length;if(p===t.length)return t;if(t.charCodeAt(p)===i)return t.slice(0,l+f.length)}if(!n.breakWords)for(var h=l-a.length;h>=0;h--){var v=t.charCodeAt(h);if(v===i){l=h,f="\n";break}if(x(v)){l=h+(a?1:0);break}}return t.slice(0,l)+("\n"===f?"":a)}return s>r?t.slice(0,l):t}function w(t,e){for(var n=t.length,a=e;a<n;a++)if(x(t.charCodeAt(a)))return a;return n}function _(t){return t>=48&&t<=57||t>=65&&t<=90||t>=97&&t<=122}function C(t,e){var n=t.charCodeAt(e);if(n===i)return!0;if(n===f){var a="("+r.join("|")+"|br)",o=new RegExp("^<"+a+"[\t\n\f\r ]*/?>","i");return o.test(t.slice(e))}return!1}function x(t){return 9===t||10===t||12===t||13===t||32===t}function y(t,e){var n=t.charCodeAt(e);if(55296===(64512&n)){var a=t.charCodeAt(e+1);if(56320===(64512&a))return String.fromCharCode(n,a)}return String.fromCharCode(n)}function k(t,e){var n=y(t,e);if("&"===n)while(1){e++;var a=t.charCodeAt(e);if(!_(a)){if(a===d){n+=String.fromCharCode(a);break}break}n+=String.fromCharCode(a)}return n}t.exports=function(t,e){var n=arguments.length>2&&void 0!==arguments[2]?arguments[2]:{};return t?(t=t.toString(),void 0===n.indicator&&(n.indicator="…"),n.html?b(t,e,n):g(t,e,n)):""}},d848:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("time",{attrs:{datetime:t.date,title:t._f("moment")(t.date)}},[t.icon?n("i",{staticClass:"outline clock icon"}):t._e(),t._v(" "+t._s(t._f("ago")(t.realDate,t.$store.state.ui.momentLocale))+" ")])},r=[],i=n("5530"),o=n("2f62"),s={props:{date:{required:!0},icon:{type:Boolean,required:!1,default:!1}},computed:Object(i["a"])(Object(i["a"])({},Object(o["d"])({lastDate:function(t){return t.ui.lastDate}})),{},{realDate:function(){return this.lastDate,this.date}})},l=s,u=n("2877"),c=Object(u["a"])(l,a,r,!1,null,null,null);e["default"]=c.exports},d99d:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div")},r=[],i=n("5530"),o=n("1157"),s=n.n(o),l={props:["message"],mounted:function(){var t=this,e=Object(i["a"])({context:"#app",message:this.message.content,showProgress:"top",position:"bottom right",progressUp:!0,onRemove:function(){t.$store.commit("ui/removeMessage",t.message.key)}},this.message);s()("body").toast(e),s()(".ui.toast.visible").last().attr("role","alert")}},u=l,c=n("2877"),d=Object(c["a"])(u,a,r,!1,null,null,null);e["default"]=d.exports},e591:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"ui small placeholder segment component-placeholder component-empty-state"},[n("h4",{staticClass:"ui header"},[n("div",{staticClass:"content"},[t._t("title",[n("i",{staticClass:"search icon"}),n("translate",{attrs:{"translate-context":"Content/*/Paragraph"}},[t._v(" No results were found. ")])])],2)]),n("div",{staticClass:"inline center aligned text"},[t._t("default"),t.refresh?n("button",{staticClass:"ui button",on:{click:function(e){return t.$emit("refresh")}}},[n("translate",{attrs:{"translate-context":"Content/*/Button.Label/Short, Verb"}},[t._v(" Refresh ")])],1):t._e()],2)])},r=[],i={props:{refresh:{type:Boolean,default:!1}}},o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},e703:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"content-form ui segments"},[n("div",{staticClass:"ui segment"},[n("div",{staticClass:"ui tiny secondary pointing menu"},[n("button",{class:[{active:!t.isPreviewing},"item"],on:{click:function(e){e.preventDefault(),t.isPreviewing=!1}}},[n("translate",{attrs:{"translate-context":"*/Form/Menu.item"}},[t._v("Write")])],1),n("button",{class:[{active:t.isPreviewing},"item"],on:{click:function(e){e.preventDefault(),t.isPreviewing=!0}}},[n("translate",{attrs:{"translate-context":"*/Form/Menu.item"}},[t._v("Preview")])],1)]),t.isPreviewing?[t.isLoadingPreview?n("div",{staticClass:"ui placeholder"},[t._m(0)]):null===t.preview?n("p",[n("translate",{attrs:{"translate-context":"*/Form/Paragraph"}},[t._v("Nothing to preview.")])],1):n("div",{domProps:{innerHTML:t._s(t.preview)}})]:[n("div",{staticClass:"ui transparent input"},[n("textarea",{directives:[{name:"model",rawName:"v-model",value:t.newValue,expression:"newValue"}],ref:"textarea",attrs:{name:t.fieldId,id:t.fieldId,rows:t.rows,required:t.required,placeholder:t.placeholder||t.labels.placeholder},domProps:{value:t.newValue},on:{input:function(e){e.target.composing||(t.newValue=e.target.value)}}})]),n("div",{staticClass:"ui very small hidden divider"})]],2),n("div",{staticClass:"ui bottom attached segment"},[t.charLimit?n("span",{class:["right","floated",{"ui danger text":t.remainingChars<0}]},[t._v(" "+t._s(t.remainingChars)+" ")]):t._e(),n("p",[n("translate",{attrs:{"translate-context":"*/Form/Paragraph"}},[t._v("Markdown syntax is supported.")])],1)])])},r=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"paragraph"},[n("div",{staticClass:"line"}),n("div",{staticClass:"line"}),n("div",{staticClass:"line"}),n("div",{staticClass:"line"})])}],i=(n("a9e3"),n("96cf"),n("1da1")),o=n("bc3a"),s=n.n(o),l={props:{value:{type:String,default:""},fieldId:{type:String,default:"change-content"},placeholder:{type:String,default:null},autofocus:{type:Boolean,default:!1},charLimit:{type:Number,default:5e3,required:!1},rows:{type:Number,default:5,required:!1},permissive:{type:Boolean,default:!1},required:{type:Boolean,default:!1}},data:function(){return{isPreviewing:!1,preview:null,newValue:this.value,isLoadingPreview:!1}},mounted:function(){var t=this;this.autofocus&&this.$nextTick((function(){t.$refs.textarea.focus()}))},methods:{loadPreview:function(){var t=this;return Object(i["a"])(regeneratorRuntime.mark((function e(){var n;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return t.isLoadingPreview=!0,e.prev=1,e.next=4,s.a.post("text-preview/",{text:t.newValue,permissive:t.permissive});case 4:n=e.sent,t.preview=n.data.rendered,e.next=10;break;case 8:e.prev=8,e.t0=e["catch"](1);case 10:t.isLoadingPreview=!1;case 11:case"end":return e.stop()}}),e,null,[[1,8]])})))()}},computed:{labels:function(){return{placeholder:this.$pgettext("*/Form/Placeholder","Write a few words here…")}},remainingChars:function(){return this.charLimit-(this.value||"").length}},watch:{newValue:function(t){this.preview=null,this.$emit("input",t)},value:{handler:function(t){var e=this;return Object(i["a"])(regeneratorRuntime.mark((function n(){return regeneratorRuntime.wrap((function(n){while(1)switch(n.prev=n.next){case 0:if(e.preview=null,e.newValue=t,!e.isPreviewing){n.next=5;break}return n.next=5,e.loadPreview();case 5:case"end":return n.stop()}}),n)})))()},immediate:!0},isPreviewing:function(t){var e=this;return Object(i["a"])(regeneratorRuntime.mark((function n(){return regeneratorRuntime.wrap((function(n){while(1)switch(n.prev=n.next){case 0:if(!t||!e.value||null!==e.preview||e.isLoadingPreview){n.next=3;break}return n.next=3,e.loadPreview();case 3:t||e.$nextTick((function(){e.$refs.textarea.focus()}));case 4:case"end":return n.stop()}}),n)})))()}}},u=l,c=n("2877"),d=Object(c["a"])(u,a,r,!1,null,null,null);e["default"]=d.exports},e8f4:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"expandable-wrapper"},[n("div",{class:["expandable-content",{expandable:t.truncated.length<t.content.length},{expanded:t.isExpanded}]},[t._t("default",[t._v(t._s(t.content))])],2),t.truncated.length<t.content.length?n("a",{attrs:{role:"button"},on:{click:function(e){e.preventDefault(),t.isExpanded=!t.isExpanded}}},[n("br"),t.isExpanded?n("translate",{key:"1",attrs:{"translate-context":"*/*/Button,Label"}},[t._v("Show less")]):n("translate",{key:"2",attrs:{"translate-context":"*/*/Button,Label"}},[t._v("Show more")])],1):t._e()])},r=[],i=(n("a9e3"),{props:{content:{type:String,required:!0},length:{type:Number,default:150,required:!1}},data:function(){return{isExpanded:!1}},computed:{truncated:function(){return this.content.substring(0,this.length)}}}),o=i,s=n("2877"),l=Object(s["a"])(o,a,r,!1,null,null,null);e["default"]=l.exports},ff9e:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("span",{staticClass:"component-user-link"},[t.avatar?[t.user.avatar&&t.user.avatar.urls.medium_square_crop?n("img",{directives:[{name:"lazy",rawName:"v-lazy",value:t.$store.getters["instance/absoluteUrl"](t.user.avatar.urls.medium_square_crop),expression:"$store.getters['instance/absoluteUrl'](user.avatar.urls.medium_square_crop)"}],staticClass:"ui tiny circular avatar",attrs:{alt:""}}):n("span",{staticClass:"ui circular label",style:t.defaultAvatarStyle},[t._v(t._s(t.user.username[0]))])]:t._e(),t._v(" @"+t._s(t.user.username)+" ")],2)},r=[],i=n("5e9f"),o={props:{user:{required:!0},avatar:{type:Boolean,default:!0}},computed:{userColor:function(){return Object(i["b"])(Object(i["a"])(this.user.username+String(this.user.id)))},defaultAvatarStyle:function(){return{"background-color":"#".concat(this.userColor)}}}},s=o,l=n("2877"),u=Object(l["a"])(s,a,r,!1,null,null,null);e["default"]=u.exports}}]);