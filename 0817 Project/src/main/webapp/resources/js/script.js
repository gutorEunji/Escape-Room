/*
   Theme Name: Escape Room
   Author: Skrylnik
   Author URI: https://themeforest.net/user/skrylnik
   Version: 1.0.0
*/

"use strict";

(function($) {
 
	/*-------------------------------------
		Sliders
	-------------------------------------*/

	$('.da-blog-slider').slick({
	  infinite: true,
	  slidesToShow: 3,
	  slidesToScroll: 3,
	  arrows: false,
	  dots: true,
	  responsive: [
	    {
	      breakpoint: 768,
	      settings: {
	        slidesToShow: 2,
	        slidesToScroll: 2
	      }
	    },
	    {
	      breakpoint: 480,
	      settings: {
	        slidesToShow: 1,
	        slidesToScroll: 1
	      }
	    }
	  ]
	});

	$('.da-review-slider').slick({
	  infinite: true,
	  slidesToShow: 1,
	  slidesToScroll: 1,
	  arrows: true,
	  dots: false,
	  responsive: [
	    {
	      breakpoint: 768,
	      settings: {
	        slidesToShow: 1,
	        slidesToScroll: 1
	      }
	    }
	 ]
	});

	$('.da-banner-slider').slick({
		dots: true,
		arrows: true,
		fade: true,
		nextArrow: '<button type="button" class="slick-next"><i class="fa fa-angle-right" aria-hidden="true"></i></button>',
		prevArrow: '<button type="button" class="slick-prev"><i class="fa fa-angle-left" aria-hidden="true"></i></button>',

	});

	$('.da-slider-post').slick({
		dots: false,
		arrows: true,
		nextArrow: '<button type="button" class="slick-next"><i class="fa fa-angle-right" aria-hidden="true"></i></button>',
		prevArrow: '<button type="button" class="slick-prev"><i class="fa fa-angle-left" aria-hidden="true"></i></button>',

	});

	/*-------------------------------------
		Background slider function
	-------------------------------------*/
	$('.background-image').each(function(){
		var url = $(this).attr('data-image');
		if(url){
			$(this).css('background-image', 'url(' + url + ')');
		}
	});

	/*-------------------------------------
		Menu
	-------------------------------------*/
	var window_view = $(window);

	var windowsHeight = window_view.height();
    var windowsWidth = window_view.width();
    var da_mob = $('.da-mobile-menu');

    $('.da-home-banner').css('height', windowsHeight);


    $('.da-menu-button').on('click', function(e) {
		e.preventDefault();

    	if (da_mob.hasClass('da-mobile-menu-hidden')){
    		da_mob.animate({right:windowsWidth},500);
    		da_mob.removeClass('da-mobile-menu-hidden');
    	} else {
    		da_mob.animate({right:0},500);
    		da_mob.addClass('da-mobile-menu-hidden');
    	}
	});

    $('.da-mobile-menu ul li').on('click', function() {
    	var da_submenu = $(this).children('.da-submenu');
		if ($(this).hasClass('da-wo-submenu')){
    		da_mob.animate({right:windowsWidth},500);
    	} else {
    		da_submenu.toggleClass('.da-submenu-visible');
    		da_submenu.slideToggle(400);
    	}
	});

    var lastScrollTop = 0;

    window_view.on('scroll', function() {


	    var st = $(this).scrollTop();
	    var header = $("header");

	    if (st > lastScrollTop) {
	      header.addClass("da-hide-menu");
	      header.removeClass("da-show-menu");
	      header.css("top", "none");
	    } else {
	      header.addClass("da-fixed-header");
	      header.addClass("da-show-menu");
	      header.removeClass("da-hide-menu");
	    }

	     lastScrollTop = st;

	    if ($(window).scrollTop() >= 100) {
	      header.addClass("da-fixed-header");
	    } else {
	      header.removeClass("da-hide-menu");
	      header.removeClass("da-show-menu");
	      header.removeClass("da-fixed-header");
	    }
	});

    $(function(){
    	var html_body = $('body, html');
	    $('.da-btn-up').on('click', function() {
			html_body.animate({scrollTop: 0}, 1100);
			return false;
		});

		$('.da-btn-down, .da-btn-down-no-border').on('click', function() {
			html_body.animate({scrollTop: windowsHeight}, 1100);
			return false;
		});
    });

	/*-------------------------------------
		Google maps API
	-------------------------------------*/
	if (typeof $.fn.gmap3 !== 'undefined') {
	
		$("#map").each(function() {
			
			var data_zoom = 15,
				data_height;
			
			if ($(this).attr("data-zoom") !== undefined) {
				data_zoom = parseInt($(this).attr("data-zoom"),10);
			}
			if ($(this).attr("data-height") !== undefined) {
				data_height = parseInt($(this).attr("data-height"),10);
			}	
			
			$(this).gmap3({
				marker: {
					values: [{
						address: $(this).attr("data-address"),
						data: $(this).attr("data-address-details")
					}],
					options:{
						draggable: false,
						icon: "img/marker.png"
					},
					events:{
						mouseover: function(marker, event, context){
							var map = $(this).gmap3("get"),
							infowindow = $(this).gmap3({get:{name:"infowindow"}});
							if (infowindow){
								infowindow.open(map, marker);
								infowindow.setContent(context.data);
							} else {
								$(this).gmap3({
									infowindow:{
										anchor:marker, 
										options:{content: context.data}
									}
								});
							}
						},
						mouseout: function(){
							var infowindow = $(this).gmap3({get:{name:"infowindow"}});
							if (infowindow){
								infowindow.close();
							}
						}
					}
				},
				map: {
					options: {
						mapTypeId: google.maps.MapTypeId.ROADMAP,
						zoom: data_zoom,
						scrollwheel: false,
						styles: [{"featureType":"all","elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#000000"},{"lightness":40}]},{"featureType":"all","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#000000"},{"lightness":16}]},{"featureType":"all","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":17},{"weight":1.2}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":21}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":16}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":19}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":17}]}]
					}
				}
			});
			$(this).css("height", data_height + "px");
		});
		
	}


	/*-------------------------------------
		FAQ
	-------------------------------------*/

    $('.da-question-container').on('click', function(e) {
        e.preventDefault();

        var question_block = $(this);
        question_block.children('.da-question').toggleClass("da-question-open");
        question_block.children('.da-answer').slideToggle(400);

	    if ($('.da-question').hasClass('da-question-open')){
	    	question_block.find('.da-answer-btn p').text('-');
	    } else {
	    	question_block.find('.da-answer-btn p').text('+');
	    }
    });


	/*-------------------------------------
		Video post
	-------------------------------------*/

    $('.da-video-post-container video, .da-video-player-container video').on('click', function() {
      if ($(this).get(0).paused) {
        $(this).get(0).play();
      } else {
        $(this).get(0).pause();
      }
    });

    $('.da-video-play-btn').on('click', function(e) {
    	e.preventDefault();
    	$(".da-video-player").css('display', 'block');
    });

    $(".da-video-player").on('mouseup', function(e) {
		var div = $(".da-video-player-container");
		if (!div.is(e.target) && div.has(e.target).length === 0) {
			div.parents(".da-video-player").hide();
		}
	});

	$(document).keydown(function(e) {
	    if (e.keyCode == 27) {
	        $(".da-video-player").css("display", "none");
	    }
	});

	/*-------------------------------------
		Calendar
	-------------------------------------*/
	$(function(){
		var da_calendar_page = $('.da-calendar-page'),
			da_inside_page = $('.da-inside-date');

	    $('.da-booking-btn').on('click', function(e) {
	    	e.preventDefault();
	    	da_calendar_page.css('display', 'none');
	    	da_inside_page.css('display', 'block');
	    });

		$('.da-close-booking').on('click', function(e) {
	    	e.preventDefault();
	    	da_calendar_page.css('display', 'block');
	    	da_inside_page.css('display', 'none');
	    });
	});
	var windowWidth = window_view.width();

	if (windowWidth >= 1200) {

	    $('.da-positioned-block').addClass("invisible").viewportChecker({
	        classToAdd: 'visible animated fadeInUpBig',
	        offset: 100
	    });

	    $('.da-text-news > div, .da-game-container, .da-month-name, .da-booking-day-container, .da-booking-date').addClass("invisible").viewportChecker({
	        classToAdd: 'visible animated fadeInUp',
	        offset: 100
	    });

	    $('.da-left-animated-block').addClass("invisible").viewportChecker({
	        classToAdd: 'visible animated fadeInLeft',
	        offset: 100
	    });

	    $('.da-right-animated-block').addClass("invisible").viewportChecker({
	        classToAdd: 'visible animated fadeInRight',
	        offset: 100
	    });

	    $('.da-game-img').addClass("invisible").viewportChecker({
	        classToAdd: 'visible animated fadeIn',
	        offset: 100
	    });
	}


})(jQuery);
