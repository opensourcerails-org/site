require("../../plugins/jquery/jquery.min.js")
const bootstrap = require("../../plugins/bootstrap/bootstrap.bundle.min.js")
! function($) {
    window.$ = $
    "use strict";
    function e() {
        var o = document.querySelector(".scroll-progress path"),
            n = o.getTotalLength();
        o.style.transition = o.style.WebkitTransition = "none", o.style.strokeDasharray = n + " " + n, o.style.strokeDashoffset = n, o.getBoundingClientRect(), o.style.transition = o.style.WebkitTransition = "stroke-dashoffset 10ms linear";

        function e() {
            var e = $(window).scrollTop(),
                s = $(document).height() - $(window).height();
            o.style.strokeDashoffset = n - e * n / s
        }
        e(), $(window).scroll(e);
        jQuery(window).on("scroll", function() {
            50 < jQuery(this).scrollTop() ? jQuery(".scroll-progress").addClass("active-progress") : jQuery(".scroll-progress").removeClass("active-progress")
        }), jQuery(".scroll-progress").on("click", function(e) {
            return e.preventDefault(), jQuery("html, body").animate({
                scrollTop: 0
            }, 500), !1
        })
    }
//
    $(document).on('turbo:before-cache', function() {
        const $modals = document.querySelectorAll('.modal.show');
        $('body').removeClass('modal-open')
        $modals.forEach(modal => {
            $(modal).modal('hide')
        });
    })
    $(document).on('turbo:load', (function() {
        $('.modal').modal('hide');
        $('body').on('show.bs.modal', function() {
            $('.navigation').addClass('header-unpinned');
        });
        var s;
        s = 0, window.onscroll = function() {
            var e = document.documentElement.scrollTop || document.body.scrollTop;
            300 < e && s <= e ? (s = e, $(".navigation").addClass("header-unpinned")) : (s = e, $(".navigation").removeClass("header-unpinned"))
        }, $('[data-toggle="navbar-menu"]').on("click", function() {
            $(this).attr("data-navbar", "visible"), $(".navigation").addClass("visible"), $("#navbar-menu").addClass("show"), $(".sidenav-overlay").addClass("show")
        }), $('[data-toggle="navbar-menu-close"], .sidenav-overlay').on("click", function() {
            $('[data-toggle="navbar-menu"]').attr("data-navbar", "hidden"), $(".navigation").removeClass("visible"), $("#navbar-menu").removeClass("show"), $(".sidenav-overlay").removeClass("show")
        }), e()
    }))
}(jQuery);
